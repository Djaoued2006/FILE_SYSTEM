unit EXECF;

interface

    uses PARSERF, CMDF;

    procedure execute_command(var cmd: command);


implementation

procedure execute_command(var cmd: command);

    begin
        case cmd._type of 
            CHANGE:
                begin 
                    writeln('[EXECUTE] EXECUTING THE CHANGE_DIRECTORY COMMAND!');
                    cmd.current_file := cd(cmd.current_file, cmd.filename);
                end;
            DISPLAY:
                begin 
                    writeln('[EXECUTE] EXECUTING THE LIST COMMAND!');
                    ls(cmd.current_file);
                end;
            REMOVE:
                begin 
                    writeln('[EXECUTE] EXECUTING THE REMOVE COMMAND!');
                    rm(cmd.current_file, cmd.filename);
                end;
            CREATE: 
                begin 
                    writeln('[EXECUTE] EXECUTING THE MAKE_DIRECTORY COMMAND!');
                    mkdir(cmd.current_file, cmd.filename);
                end;
        end;
    end;

begin 
end.