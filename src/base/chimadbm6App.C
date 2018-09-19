#include "chimadbm6App.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template <>
InputParameters
validParams<chimadbm6App>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

chimadbm6App::chimadbm6App(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  chimadbm6App::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  chimadbm6App::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  chimadbm6App::registerExecFlags(_factory);
}

chimadbm6App::~chimadbm6App() {}

void
chimadbm6App::registerApps()
{
  registerApp(chimadbm6App);
}

void
chimadbm6App::registerObjects(Factory & factory)
{
    Registry::registerObjectsTo(factory, {"chimadbm6App"});
}

void
chimadbm6App::associateSyntax(Syntax & /*syntax*/, ActionFactory & action_factory)
{
  Registry::registerActionsTo(action_factory, {"chimadbm6App"});

  /* Uncomment Syntax parameter and register your new production objects here! */
}

void
chimadbm6App::registerObjectDepends(Factory & /*factory*/)
{
}

void
chimadbm6App::associateSyntaxDepends(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}

void
chimadbm6App::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execution flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
chimadbm6App__registerApps()
{
  chimadbm6App::registerApps();
}

extern "C" void
chimadbm6App__registerObjects(Factory & factory)
{
  chimadbm6App::registerObjects(factory);
}

extern "C" void
chimadbm6App__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  chimadbm6App::associateSyntax(syntax, action_factory);
}

extern "C" void
chimadbm6App__registerExecFlags(Factory & factory)
{
  chimadbm6App::registerExecFlags(factory);
}
