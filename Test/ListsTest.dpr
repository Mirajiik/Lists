program ListsTest;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  FastMM4 in '..\FastMM4.pas',
  FastMM4Messages in '..\FastMM4Messages.pas',
  Lists in '..\Lists.pas',
  TestArrayList in 'TestArrayList.pas',
  TestLinkedList in 'TestLinkedList.pas',
  RandomTestLists in 'RandomTestLists.pas',
  DUnitTestRunner;

{R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

