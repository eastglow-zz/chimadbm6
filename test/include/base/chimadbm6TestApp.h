//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#ifndef CHIMADBM6TESTAPP_H
#define CHIMADBM6TESTAPP_H

#include "MooseApp.h"

class chimadbm6TestApp;

template <>
InputParameters validParams<chimadbm6TestApp>();

class chimadbm6TestApp : public MooseApp
{
public:
  chimadbm6TestApp(InputParameters parameters);
  virtual ~chimadbm6TestApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
  static void registerExecFlags(Factory & factory);
};

#endif /* CHIMADBM6TESTAPP_H */
