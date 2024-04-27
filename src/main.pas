uses EXECF, PARSERF, FILESYS, CMDF;

function read_input(): string;

    var result: string;

    begin   
        write('> '); 
        readln(result);
        read_input := result;
    end;

procedure main();

    var fs: file_tree;
        current_file: file_t;
        input: string;
        cmd: command;

    begin
        fs := file_tree_create();
        fs^.root := file_create('/');
        fs^.root^.parent := NIL;
        current_file := fs^.root;

        repeat
            input := read_input();
            if (input <> 'q') then 
                begin 
                    cmd := parse(input, current_file);
                    execute_command(cmd);
                    current_file := cmd.current_file;
                end;
        until (input = 'q');

    end;

begin 
    main();
end.