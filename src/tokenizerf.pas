unit TOKENIZERF;

interface

    uses TYPEF;

    type
        token_t = ^token_type;
        token_type = record 
            value: string;
            _type: INPUT_TYPE;
            next: token_t;
        end;

        token_list = ^token_list_type;
        token_list_type = record 
            head, tail: token_t;
        end;
    
    function tokens_create(): token_list;
    function token_create(value: string; _type: INPUT_TYPE): token_t;
    procedure tokens_add(tokens: token_list; value: string; _type: INPUT_TYPE);
    procedure tokens_remove(tokens: token_list);
    procedure tokens_show(tokens: token_list);

implementation

function token_create(value: string; _type: INPUT_TYPE): token_t;

    var result: token_t;

    begin   
        new(result);
        result^.value := value;
        result^._type := _type;
        result^.next := NIL;
        token_create := result; 
        result := NIL;
    end;

function tokens_create(): token_list;

    var result: token_list;

    begin   
        new(result);
        result^.head := NIL;
        result^.tail := NIL;
        tokens_create := result;
        result := NIL;
    end;

procedure tokens_add(tokens: token_list; value: string; _type: INPUT_TYPE);

    var new_token: token_t;

    begin
        new_token := token_create(value, _type);

        if (tokens^.head = NIL) then 
            begin 
                tokens^.head := new_token;
                tokens^.tail := new_token;
            end
        else 
            begin
                tokens^.tail^.next := new_token;
                tokens^.tail := new_token; 
            end;
        
        writeln('[TOKENIZER] TOKEN OF VALUE: ', value, ', TYPE: ', _type,' ADDED TO TOKENS!');
        new_token := NIL;
    end;

procedure tokens_remove(tokens: token_list);

    var current, next: token_t;

    begin
        current := tokens^.head;
        while (current <> NIL) do 
            begin
                next := current^.next;
                dispose(current);
                current := next; 
            end;

        tokens^.head := NIL;
        tokens^.tail := NIL;
    end;

procedure tokens_show(tokens: token_list);

    var token: token_t;

    begin 
        token := tokens^.head;
        while (token <> NIL) do     
            begin
                writeln('TOKEN VALUE: ', token^.value);
                writeln('TOKEN TYPE: ', token^._type);
                token := token^.next; 
            end;
    end;


begin 
end.