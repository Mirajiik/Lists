program ConsoleProject;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  FastMM4 in 'FastMM4.pas',
  System.SysUtils,
  Lists in 'Lists.pas';

var
  List, Source, Dest, Clon: IBaseList;
  Choice, pos, a : Integer;
  SwitchList : Boolean = False;
begin
  Dest := TArrayList.Create;
  Dest.Add(14); Dest.Add(7); Dest.Add(77);
  Source := TLinkedList.Create;
  Source.Add(5); Source.Add(10);Source.Add(25);
  Clon := TLinkedList.Create;
  Clon.Add(32); Clon.Add(16); Clon.Add(8); Clon.Add(4); Clon.Add(2);
  repeat
    Writeln;
    if SwitchList then
    begin
      Writeln('LinkedList');
    end
    else
    begin
      Writeln('ArrayList');
    end;
    Writeln('Select action:' + #13#10 + '0. Exit' + #13#10 + '1. Create list' + #13#10 + '2. Add element'
      + #13#10 + '3. Insert element' + #13#10 + '4. Delete element' + #13#10 + '5. Clear list' + #13#10
      + '6. Count elements' + #13#10 + '7. GetElement' + #13#10 + '8. SetElement' + #13#10 + '9. Print List'
      + #13#10 + '10. Switch List' + #13#10 + '11. Assign(LinkedSource{5, 10, 25})' + #13#10
      + '12. Dest.AssignTo  (Dest{7, 14, 77})' + #13#10 + '13. Clone : [2, 4, 8, 16, 32]' + #13#10 + '14. Sort'
      + #13#10 + '15. Save' + #13#10 + '16. Load');
    Readln(Choice);
    Writeln;
    case Choice of
      0:
      begin
        List := nil;
      end;
      1:
      begin
        if SwitchList then
        begin
          List := TLinkedList.Create;
        end
        else
        begin
          List := TArrayList.Create;
        end;
        Writeln('List created');
      end;
      2:
      begin
        Write('Enter value: ');
        Readln(a);
        Writeln('Add' + #13#10 + IntToStr(List.Add(a)));
      end;
      3:
      begin
        Write('Enter value: ');
        Readln(a);
        Write('Enter position: ');
        Readln(pos);
        try
          List.Insert(pos, a);
          Writeln('Insert' + #13#10);
        except
          on EListError do
          begin
            Writeln('Error');
          end;
        end;
      end;
      4:
      begin
        Write('Enter position: ');
        Readln(pos);
        Writeln('Delete' + #13#10);
        List.Delete(pos);
      end;
      5:
      begin
        List.Clear;
        Writeln('List cleared');
      end;
      6: Writeln('Count' + #13#10 + IntToStr(List.Count));
      7:
      begin
        Write('Enter position: ');
        Readln(pos);
        Writeln(Format('List[%d] = %d', [pos, List[pos]]));
      end;
      8:
      begin
        Write('Enter value: ');
        Readln(a);
        Write('Enter position: ');
        Readln(pos);
        List[pos] := a;
      end;
      9:
      begin
        Writeln('Print');
        List.Print;
      end;
      10:
      begin
        SwitchList := not SwitchList;
      end;
      11:
      begin
        List.Assign(Source);
        Writeln('List.Assign([5, 10, 25])');
      end;
      12:
      begin
        Dest.AssignTo(List);
        Writeln('[14, 7, 77].AssignTo(List)');
      end;
      13:
      begin
        List := Clon.Clone;
        Writeln('List := [32, 16, 8, 4, 2];');
      end;
      14:
      begin
        List.Sort;
        Writeln('List sorted');
      end;
      15: Writeln(List.Save('input.txt'));
      16: Writeln(List.Load('input.txt'));
    end;
  until Choice = 0;
end.
