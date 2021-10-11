unit AllMessages;

interface
const
  LicensedSin='Sin is registered version feature.';
  LicensedCos='Cos is registered version feature.';
  LicensedExp='Exp is registered version feature.';
  ThanksForRegistration='Thank you for registration.'+#13+'Please restart the programm.';
  ErrorRegistration='The registration key does not appear to be valid.'+#13+'Please re-enter the key.';

  procedure ShowRegistrationThanks;
  procedure ShowErrorRegistration;
implementation
uses
  Dialogs;
procedure ShowRegistrationThanks;
begin
  ShowMessage(ThanksForRegistration);
end;

procedure ShowErrorRegistration;
begin
  ShowMessage(ErrorRegistration);
end;

end.
