unit S_VIEWF;

interface

    uses TYPEF, TOKENIZERF;

    type 
        string_view_t = ^string_view;

        string_view = record 
            content: string;
            current_index: integer;
            content_size: integer;
        end; 
    
    function get_input_type(s: string): INPUT_TYPE;
    function sv_split(s: string): token_list;

implementation

function sv_create(content: string): string_view_t;

    var result: string_view_t;

    begin
        new(result);
        result^.content := content;
        result^.content_size := length(content);
        result^.current_index := 1;
        sv_create := result;
        result := NIL;
        writeln('[STRING VIEW] STRING VIEW WITH VALUE: ', content, ' CREATED SUCCESFULLY!');
    end;

function sv_end(sv: string_view_t): boolean;

    begin 
        sv_end := (sv^.current_index > sv^.content_size);
    end;

function sv_consume(sv: string_view_t): char;

    begin 
        sv_consume := sv^.content[sv^.current_index];
        inc(sv^.current_index);
    end;

function sv_peek(sv: string_view_t): char;

    begin
        sv_peek := sv^.content[sv^.current_index];
    end;

function get_input_type(s: string): INPUT_TYPE;

    begin
        case s[1] of 
            ':': get_input_type := COMMAND_T;
            '-': get_input_type := OPTION_T;
        else 
            get_input_type := FILENAME_T;
        end; 
    end;

function sv_split(s: string): token_list;

    var sv: string_view_t; 
        tokens: token_list;
        buffer: string;

    begin
        tokens := tokens_create();
        sv := sv_create(s);
        buffer := '';
    
        while (not sv_end(sv)) do 
            if (sv_peek(sv) = ' ') then 
                begin 
                    if (buffer <> '') then
                        begin 
                            tokens_add(tokens, buffer, get_input_type(buffer));
                            buffer := '';
                        end;
                    sv_consume(sv);
                end
            else 
                buffer := buffer + sv_consume(sv);   

        if (buffer <> '') then 
            tokens_add(tokens, buffer, get_input_type(buffer));

        sv_split := tokens;         
    end;

begin 
end.