
[Mesh]
  type = FileMesh
  file = chimadmeshb.e
[]

[MeshModifiers]  # To prevent the solution of the Poisson equation from shifting arbitrarily when Neumann boundary condition is applied.
  [./interior_nodeset]
    type = BoundingBoxNodeSet
    new_boundary = node1
    bottom_left = '50 50 0'
    top_right = '50 50 0'
  [../]
[]

[Variables]
  [./c] #composition
    order = FIRST
    family = LAGRANGE
  [../]

  [./w] #chemical potential
    order = FIRST
    family = LAGRANGE
  [../]

  [./phi_int] #electrostatic potential
    order = FIRST
    family = LAGRANGE
  [../]

  [./phi_ext]
    order = FIRST
    family = LAGRANGE
  [../]

  [./c0]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./dcx]
    order = FIRST
    family = MONOMIAL
  [../]
  [./dcy]
    order = FIRST
    family = MONOMIAL
  [../]

  [./phi_tot_aux]
    order = FIRST
    family = MONOMIAL
  [../]
[]

[ICs]
  [./c0_0.5]
    type = ConstantIC
    variable = c0
    value = 0.5
  [../]

  [./c_func_ic]
    type = FunctionIC
    variable = c
    function = c_ic_function
  [../]

  [./phi_int_zero]
    type = ConstantIC
    variable = phi_int
    value = 0
  [../]

  [./phi_ext_func]
    type = FunctionIC
    variable = phi_ext
    function = phi_ext_function
  [../]
[]

[Functions]
  [./c_ic_function]
    type = ParsedFunction
    value = '0.5 + 0.04*( cos(0.2*x)*cos(0.11*y) + (cos(0.13*x)*cos(0.087*y)) + cos(0.025*x-0.015*y)*cos(0.07*x-0.02*y))'
  [../]

  [./phi_ext_function]
    type = ParsedFunction
    vars = 'A      B     C'
    vals = '0.0002 -0.01 0.02'
    value = 'A*x*y + B*x + C*y'
  [../]

  [./OneConst]
    type = ConstantFunction
    value = 1
  [../]
[]

[BCs]
  [./w_Neumann]
    type = NeumannBC
    variable = w
    boundary = '1 2 3 4'
    value = 0
  [../]

  [./fixedpoint]
    type = DirichletBC
    variable = phi_int
    boundary = 'node1'
    value = 0
  [../]

  [./phi_ext_bc]
    type = FunctionDirichletBC
    variable = phi_ext
    boundary = '1 2 3 4'
    function = phi_ext_function
  [../]
[../]

[AuxKernels]
  [./gradcx]
    type = VariableGradientComponent
    variable = dcx
    gradient_variable = c
    component = x
  [../]
  [./gradcy]
    type = VariableGradientComponent
    variable = dcy
    gradient_variable = c
    component = y
  [../]

  [./phi_tot]
    type = MaterialRealAux
    variable = phi_tot_aux
    property = phi_tot
  [../]
[]

[Kernels]
  # # Revers split method
  # [./cres]
  #   type = SplitCHParsed
  #   variable = c
  #   f_name = fbulk
  #   kappa_name = kappa
  #   w = w
  # [../]
  # [./wres]
  #   type = SplitCHWRes
  #   variable = w
  #   mob_name = Mc
  # [../]
  # [./time]
  #   type = CoupledTimeDerivative
  #   variable = w
  #   v = c
  # [../]

  # Forward split method
  [./c_time_derivative]
    type = TimeDerivative
    variable = c
  [../]

  [./c_divgrad_w]
    type = FwdSplitCH1
    variable = c
    mu_name = w
    mob_name = Mc
  [../]

  [./w_itself]
    type = MassEigenKernel
    variable = w
    eigen = false
  [../]

  [./w_lapc]
    type = SimpleCoupledACInterface
    variable = w
    v = c
    kappa_name = kappa
    mob_name = One
  [../]

  [./w_doublewell]
    type = CoupledAllenCahn
    variable = w
    v = c
    f_name = fc
    mob_name = One
  [../]

  [./w_electric]
    type = CoupledAllenCahn
    variable = w
    v = c
    f_name = felec   #This will give a warning that phi_int and phi_ext are missing. It's okay to neglect, since we don't need those derivatives here.
    mob_name = One
  [../]

  [./phi_int_lap_phi_tot]
    type = CoefLaplacian
    variable = phi_int
    basefield_var = phi_ext
    M = epsilon_over_k
    prefactor = 1
  [../]

  [./phi_int_comp]
    type = CoupledForce
    variable = phi_int
    v = c
    coef = -1
  [../]

  [./phi_int_comp0]
    type = CoupledForce
    variable = phi_int
    v = c0
    coef = 1
  [../]

  [./phi_ext_dummy]
    type = TimeDerivative
    variable = phi_ext
  [../]

  [./c0_itself]
    type = MassEigenKernel
    variable = c0
    eigen = false
  [../]

  [./c0_avg_of_c_from_postprocessor]
    type = BodyForce
    variable = c0
    postprocessor = avg_c
    value = -1
  [../]
[]

[Materials]
  [./Constant_materials]
    type = GenericConstantMaterial
    prop_names =  'ca  cb  kappa W M0 k   epsilon One negOne'
    prop_values = '0.3 0.7 2     5 10 0.3 20      1   -1'
  [../]

  [./Mobility]
    type = DerivativeParsedMaterial
    material_property_names = 'M0'
    f_name = Mc
    args = 'c'
    function = 'M0/(1+c^2)'
    derivative_order = 2
  [../]

  [./Double_well]
    type = DerivativeParsedMaterial
    material_property_names = 'W ca cb'
    f_name = fc
    args = 'c'
    function = 'W * (c-ca)^2 * (c-cb)^2'
    derivative_order = 2
  [../]

  [./felec]
    type = DerivativeParsedMaterial
    material_property_names = 'k'
    f_name = felec
    args = 'c phi_int phi_ext c0'
    function = '0.5 * k * (c - c0) * (phi_int + phi_ext)'
    derivative_order = 2
  [../]

  [./fbulk_for_reverse_split]
    type = DerivativeParsedMaterial
    f_name = fbulk
    material_property_names = 'fc(c) felec(c,phi_int,phi_ext,c0)'
    args = 'c phi_int phi_ext c0'
    function = 'fc + felec'
    derivative_order = 2
  [../]

  [./epsilon_over_k]
    type = ParsedMaterial
    material_property_names = 'k epsilon'
    f_name = epsilon_over_k
    function = 'epsilon/k'
  [../]

  [./phi_tot]
    type = ParsedMaterial
    f_name = phi_tot
    args = 'phi_int phi_ext'
    function = 'phi_int + phi_ext'
    outputs = exodus
  [../]

  [./FE_density]
    type = ParsedMaterial
    f_name = ftot
    material_property_names = 'kappa fc(c) felec(c,phi_int,phi_ext,c0)'
    args = 'c phi_int phi_ext c0 dcx dcy'
    function = '0.5*(dcx^2+dcy^2) + fc + felec'
    outputs = exodus
  [../]
[]

[Preconditioning]
  [./cw_coupling]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  scheme = bdf2

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'

  l_max_its = 30
  l_tol = 1e-6
  nl_max_its = 30
  nl_rel_tol = 1e-9
  nl_abs_tol = 1e-9

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-5
    cutback_factor = 0.5
    growth_factor = 1.8
  [../]
  dtmax = 5
  end_time = 400.0
  start_time = 0.0
[]

[Postprocessors]
  [./avg_c]
    type = AverageNodalVariableValue
    variable = c
    outputs = console
    execute_on = TIMESTEP_BEGIN
  [../]

  [./Total_free_energy]
    type = ElementIntegralMaterialProperty
    mat_prop = ftot
    outputs = csv
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]

[Outputs]
  exodus = true
  csv = true
  print_perf_log = true
  sync_times = '5 10 20 50 100 200 400'
[]
