//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "chimadbm6TestApp.h"
#include "chimadbm6App.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

template <>
InputParameters
validParams<chimadbm6TestApp>()
{
  InputParameters params = validParams<chimadbm6App>();
  return params;
}

chimadbm6TestApp::chimadbm6TestApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  chimadbm6App::registerObjectDepends(_factory);
  chimadbm6App::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  chimadbm6App::associateSyntaxDepends(_syntax, _action_factory);
  chimadbm6App::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  chimadbm6App::registerExecFlags(_factory);

  bool use_test_objs = getParam<bool>("allow_test_objects");
  if (use_test_objs)
  {
    chimadbm6TestApp::registerObjects(_factory);
    chimadbm6TestApp::associateSyntax(_syntax, _action_factory);
    chimadbm6TestApp::registerExecFlags(_factory);
  }
}

chimadbm6TestApp::~chimadbm6TestApp() {}

void
chimadbm6TestApp::registerApps()
{
  registerApp(chimadbm6App);
  registerApp(chimadbm6TestApp);
}

void
chimadbm6TestApp::registerObjects(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new test objects here! */
}

void
chimadbm6TestApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
  /* Uncomment Syntax and ActionFactory parameters and register your new test objects here! */
}

void
chimadbm6TestApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execute flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
chimadbm6TestApp__registerApps()
{
  chimadbm6TestApp::registerApps();
}

// External entry point for dynamic object registration
extern "C" void
chimadbm6TestApp__registerObjects(Factory & factory)
{
  chimadbm6TestApp::registerObjects(factory);
}

// External entry point for dynamic syntax association
extern "C" void
chimadbm6TestApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  chimadbm6TestApp::associateSyntax(syntax, action_factory);
}

// External entry point for dynamic execute flag loading
extern "C" void
chimadbm6TestApp__registerExecFlags(Factory & factory)
{
  chimadbm6TestApp::registerExecFlags(factory);
}
