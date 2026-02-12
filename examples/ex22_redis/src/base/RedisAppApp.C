#include "RedisAppApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
RedisAppApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

RedisAppApp::RedisAppApp(InputParameters parameters) : MooseApp(parameters)
{
  RedisAppApp::registerAll(_factory, _action_factory, _syntax);
}

RedisAppApp::~RedisAppApp() {}

void
RedisAppApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAllObjects<RedisAppApp>(f, af, syntax);
  Registry::registerObjectsTo(f, {"RedisAppApp"});
  Registry::registerActionsTo(af, {"RedisAppApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
RedisAppApp::registerApps()
{
  registerApp(RedisAppApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
RedisAppApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  RedisAppApp::registerAll(f, af, s);
}
extern "C" void
RedisAppApp__registerApps()
{
  RedisAppApp::registerApps();
}
