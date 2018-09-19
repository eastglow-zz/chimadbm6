//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#ifndef CHIMADBM6APP_H
#define CHIMADBM6APP_H

#include "MooseApp.h"

class chimadbm6App;

template <>
InputParameters validParams<chimadbm6App>();

class chimadbm6App : public MooseApp
{
public:
  chimadbm6App(InputParameters parameters);
  virtual ~chimadbm6App();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void registerObjectDepends(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
  static void associateSyntaxDepends(Syntax & syntax, ActionFactory & action_factory);
  static void registerExecFlags(Factory & factory);
};

#endif /* CHIMADBM6APP_H */
