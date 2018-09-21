
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmax = 100
  ymax = 100
  elem_type = QUAD4
  # uniform_refine = 3
[]

[MeshModifiers]
  [./interior_nodeset]
    type = BoundingBoxNodeSet
    new_boundary = node1
    bottom_left = '0 50 0'
    top_right = '0 50 0'
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
[]

[ICs]
  [./c0_0.5]
    type = ConstantIC
    variable = c0
    # value = 4.993365e-01
    value = 0.5
  [../]

  [./c_func_ic]
    type = FunctionIC
    variable = c
    function = c_ic_function
    # function = dipoleIC
  [../]
  [./phi_int_zero]
    type = ConstantIC
    variable = phi_int
    value = 0
  [../]
  # [./phi_int_func]
  #   type = FunctionIC
  #   variable = phi_int
  #   function = phi_int_function
  # [../]
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
    # value = 0
  [../]

  [./OneConst]
    type = ConstantFunction
    value = 1
  [../]

  [./phi_int_function]
    type = LinearCombinationFunction
    # functions = 'OneConst TheCircle TheSurface'
    functions = 'OneConst phi_ext_function'
    w =         '0        -1'
  [../]

  [./Eext_xn]
    type = ParsedFunction
    vars = 'A      B'
    vals = '0.0002 -0.01'
    value = 'A*y + B'
  [../]

  [./Eext_xp]
    type = ParsedFunction
    vars = 'A      B'
    vals = '0.0002 -0.01'
    value = '-A*y - B'
  [../]

  [./Eext_yn]
    type = ParsedFunction
    vars = 'A      C'
    vals = '0.0002 0.02'
    value = 'A*x + C'
  [../]

  [./Eext_yp]
    type = ParsedFunction
    vars = 'A      C'
    vals = '0.0002 0.02'
    value = '-A*x - C'
  [../]
[]

[BCs]
  # [./phi_int_zero_normal_component]
  #   type = NeumannBC
  #   variable = phi_int
  #   boundary = 'top bottom left right'
  #   value = 0
  # [../]
  # [./phi_int_dirichlet]
  #   type = DirichletBC
  #   variable = phi_int
  #   value = 0
  #   boundary = 'top bottom left right'
  # [../]

  [./w_Neumann]
    type = NeumannBC
    variable = w
    boundary = 'top bottom left right'
    value = 0
  [../]


  # [./phi_int_hackathon_left]
  #   type = DirichletBC
  #   variable = phi_int
  #   boundary = 'left'
  #   value = 0
  # [../]

  # [./phi_int_left_FncNeumann]
  #   type = FunctionNeumannBC
  #   variable = phi_int
  #   boundary = 'left'
  #   function = Eext_xn
  # [../]

  # [./phi_int_hackathon_right]
  #   type = FunctionDirichletBC
  #   variable = phi_int
  #   boundary = 'right'
  #   function = phi_int_hackathon_right
  # [../]

  # [./phi_int_hackathon_left_with_Eext]
  #   type = FunctionDirichletBC
  #   variable = phi_int
  #   boundary = 'left'
  #   function = phi_int_function
  # [../]

  # [./reference_potential_at_origin]
  #   type = FunctionDirichletBC
  #   variable = phi_int
  #   boundary = 'origin'
  #   function = phi_int_function
  # [../]

  [./fixedpoint]
    type = DirichletBC
    variable = phi_int
    boundary = 'node1'
    value = 0
  [../]

  [./phi_ext_bc]
    type = FunctionDirichletBC
    variable = phi_ext
    boundary = 'top bottom left right'
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
[]

[Kernels]
  # Revers split method
  [./cres]
    type = SplitCHParsed
    variable = c
    f_name = fbulk
    kappa_name = kappa
    w = w
  [../]
  [./wres]
    type = SplitCHWRes
    variable = w
    mob_name = Mc
  [../]
  [./time]
    type = CoupledTimeDerivative
    variable = w
    v = c
  [../]

  # # Forward split method
  # [./c_time_derivative]
  #   type = TimeDerivative
  #   variable = c
  # [../]
  #
  # [./c_divgrad_w]
  #   type = FwdSplitCH1
  #   variable = c
  #   mu_name = w
  #   mob_name = Mc
  # [../]
  #
  # [./w_itself]
  #   type = MassEigenKernel
  #   variable = w
  #   eigen = false
  # [../]
  #
  # [./w_lapc]
  #   type = SimpleCoupledACInterface
  #   variable = w
  #   v = c
  #   kappa_name = kappa
  #   mob_name = One
  # [../]
  #
  # [./w_doublewell]
  #   type = CoupledAllenCahn
  #   variable = w
  #   v = c
  #   f_name = fc
  #   mob_name = One
  # [../]
  #
  # [./w_electric]
  #   type = CoupledAllenCahn
  #   variable = w
  #   v = c
  #   f_name = felec   #This will give a warning that phi_int and phi_ext are missing. It's okay to neglect, since we don't need those derivatives here.
  #   mob_name = One
  # [../]

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
  #
  # [./phi_int_avgc]
  #   type = BodyForce
  #   variable = phi_int
  #   postprocessor = avg_c
  #   value = 1
  # [../]

  # [./phi_int_dummy]
  #   type = TimeDerivative
  #   variable = phi_int
  # [../]

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
    # function = 'M0'
    derivative_order = 2
    outputs = exodus
  [../]

  [./Double_well]
    type = DerivativeParsedMaterial
    material_property_names = 'W ca cb'
    f_name = fc
    args = 'c'
    function = 'W * (c-ca)^2 * (c-cb)^2'
    derivative_order = 2
    outputs = exodus
  [../]

  [./felec]
    type = DerivativeParsedMaterial
    material_property_names = 'k'
    f_name = felec
    # args = 'c c0 phi_int phi_ext'
    args = 'c phi_int phi_ext c0'
    function = '0.5 * k * (c - c0) * (phi_int + phi_ext)'
    derivative_order = 2
    outputs = exodus
  [../]

  [./fbulk_for_reverse_split]
    type = DerivativeParsedMaterial
    f_name = fbulk
    material_property_names = 'fc(c) felec(c,phi_int,phi_ext,c0)'
    args = 'c phi_int phi_ext c0'
    function = 'fc + felec'
    derivative_order = 2
    outputs = exodus
  [../]

  [./epsilon_over_k]
    type = ParsedMaterial
    material_property_names = 'k epsilon'
    f_name = epsilon_over_k
    function = 'epsilon/k'
    outputs = exodus
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
    function = '0.5*kappa*(dcx^2+dcy^2) + fc + felec'
    outputs = exodus
  [../]

  [./phi_ext_mat]
    type = GenericFunctionMaterial
    prop_names = phi_ext_mat
    prop_values = phi_ext_function
  [../]
[]

[Preconditioning]
  [./cw_coupling]
    type = SMP
    full = true
  #  type = FDP
  #  full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  scheme = bdf2

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'
  #petsc_options_iname = '-pc_type -sub_pc_type'
  # petsc_options_value = 'asm      lu          '
  # petsc_options_iname = '-pc_type -pc_asm_overlap'
  # petsc_options_value = 'asm      1'

  # petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_levels'
  # petsc_options_value = 'bjacobi  ilu          4'

  l_max_its = 30
  l_tol = 1e-6
  nl_max_its = 30
  nl_rel_tol = 1e-9
  nl_abs_tol = 1e-9
  # line_search = 'none'

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-5
    cutback_factor = 0.5
    growth_factor = 1.8
    # optimal_iterations = 20
    # iteration_window = 5
  [../]
  dtmax = 5
  end_time = 400.0
  # start_time = -0.01
  start_time = 0.0
  #end_time = 170.0

  # # adaptive mesh to resolve an interface
  # [./Adaptivity]
  #   initial_adaptivity = 3
  #   max_h_level = 3
  #   refine_fraction = 0.99
  #   coarsen_fraction = 0.001
  #   weight_names =  'c w phi_int phi_ext'
  #   weight_values = '1 1 1       1'
  #
  # [../]
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
  #show_var_residual = true
  show_var_residual_norms = true
[]

[Outputs]
  exodus = true
  csv = true
  #interval = 20
  sync_times = '5 10 20 50 100 200 400'
[]
