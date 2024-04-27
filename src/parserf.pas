unit PARSERF;

interface

    uses TYPEF, FILESYS, S_VIEWF, TOKENIZERF;

    type 
        COMMAND_TYPE = (CHANGE, REMOVE, CREATE, DISPLAY, NO_TYPE);
    
        command = record 
            current_file: file_t;
            filename: string;
            options: string;
            _type: COMMAND_TYPE;
        end;

        parser_t = ^parser_type;
        parser_type = record 
            tokens: token_list;
            current_token: token_t;
        end;
    
    function parse(input: string; current_file: file_t): command;

implementation

function parser_create(tokens: token_list): parser_t;

    var result: parser_t;

    begin 
        new(result);
        result^.tokens := tokens;
        result^.current_token := tokens^.head;
        parser_create := result;
        result := NIL;
        writeln('[PARSER] PARSER CREATED SUCCESFULLY!');
    end;

function parser_peek(parser: parser_t): token_t;

    begin
        parser_peek := parser^.current_token; 
        writeLn('[PARSER] PEEKING A TOKEN: VALUE: ', parser_peek^.value, ' TYPE: ', parser_peek^._type);
    end;

function parser_consume(parser: parser_t): token_t;

    begin 
        parser_consume := parser_peek(parser);
        parser^.current_token := parser^.current_token^.next;
        writeln('[PARSER] CONSUMING A TOKEN: VALUE: ', parser_consume^.value, ' TYPE: ', parser_consume^._type)
    end;

function no_tokens(parser: parser_t): boolean;

    begin
        no_tokens := parser^.current_token = NIL; 
    end;

function get_command(s: string): COMMAND_TYPE;

    var result: COMMAND_TYPE;

    begin
        case s of 
            ':ls': 
                result := DISPLAY;
            ':cd': 
                result := CHANGE;
            ':rm': 
                result := REMOVE;
            ':mkdir', ':touch': 
                result := CREATE;
        end;

        get_command := result;
    end;

procedure write_command(cmd: command);

    begin   
        writeln('COMMAND {');
        writeln('       TYPE: ', cmd._type);
        writeln('       CURRENT_FILE: ', cmd.current_file^.name);
        writeln('       FILENAME: ', cmd.filename);
        writeln('}')
    end;

function command_init(): command;

    var result: command;

    begin
        result.current_file := NIL;
        result.filename := '';
        result.options := '';
        result._type := NO_TYPE;
        command_init := result;
    end;

function parse(input: string; current_file: file_t): command;

    var result: command;
        tokens: token_list;
        parser: parser_t;

    begin 
        writeln('[PARSER] ENTERING PARSING FUNCTION');
        tokens := sv_split(input);
        parser := parser_create(tokens);
        result := command_init();
        
        result.current_file := current_file;
        while (not no_tokens(parser)) do 
            begin
                case get_input_type(parser_peek(parser)^.value) of 
                    COMMAND_T: 
                        result._type := get_command(parser_consume(parser)^.value);
                    OPTION_T: 
                        result.options := result.options + copy(parser_consume(parser)^.value, 1, 256);
                    FILENAME_T:
                        result.filename := parser_consume(parser)^.value;
                end;
            end;
            
        parse := result;
        writeln('[PARSER] GETTING THE NEW COMMAND');
        writeln();
        write_command(parse);
        writeln();
        writeln('[PARSER] EXITING PARSING FUNCTION');
    end;

begin 
end.

