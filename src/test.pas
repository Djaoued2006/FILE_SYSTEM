uses S_VIEWF, TOKENIZERF;


function read_input(): string;

    var result: string;

    begin   
        write('> '); 
        readln(result);
        read_input := result;
    end;

procedure main();

    var input: string;
        tokens: token_list;


    begin
        input := read_input();
        while (input <> 'q') do 
            begin   
                tokens := sv_split(input);
                tokens_show(tokens);
                tokens_remove(tokens);
                input := read_input();
            end;
    end;

begin
    main();
end.