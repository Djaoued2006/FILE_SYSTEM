unit ERRF;

interface

    uses FILESYS;
    
    procedure handle_error(RESULT: RESULT_TYPE; filename: string);

implementation

procedure handle_error(RESULT: RESULT_TYPE; filename: string);

    begin 
        case RESULT of 
            FILE_NOT_FOUND: 
                writeln(filename, ': No such file or directory!');
            FILE_FOUND:
                writeln(filename, ': File Already exists!');
            ROOT_EXCEPTION: 
                writeln('Can not modify the root file:', filename);
        end;
    end;

begin
end.