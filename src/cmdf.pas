unit CMDF;

interface

    uses CRT, ERRF, FILESYS;

    procedure ls(parent: file_t);
    procedure rm(parent: file_t; filename: string);
    function cd(parent: file_t; filename: string): file_t;
    procedure mkdir(parent: file_t; filename: string);

implementation

procedure ls(parent: file_t);

    var current_file: file_t;

    begin 
        current_file := get_sub_files(parent);
        if (current_file = NIL) then 
            begin 
                Textcolor(RED);
                writeln('EMPTY!');
                Textcolor(lightgray);
                exit();
            end;

        Textcolor(BLUE);
        while (current_file <> NIL) do 
            begin
                write(get_filename(current_file), '  ');
                current_file := get_next_file(current_file);
            end; 
        Textcolor(lightgray);
        writeln();
    end;

procedure rm(parent: file_t; filename: string);

    var RESULT: RESULT_TYPE;
        myfile: file_t;

    begin 
        myfile := get_file(parent, filename);
        
        if (myfile = NIL) then 
            begin
                handle_error(FILE_NOT_FOUND, filename);
                exit(); 
            end;
        
        RESULT := file_remove(myfile);
        // if RESULT = DONE, NOTHING WILL BE DONE! :)
        handle_error(RESULT, filename);
    end;

// this will return the file after making the cd command!
function cd(parent: file_t; filename: string): file_t;

    var myfile: file_t;

    begin 
        myfile := get_file(parent, filename);

        if (myfile = NIL) then 
            begin 
                handle_error(FILE_NOT_FOUND, filename);
                cd := parent
            end
        else 
            cd := myfile;
    end;

procedure mkdir(parent: file_t; filename: string);

    var RESULT: RESULT_TYPE;

    begin
        RESULT := file_add(parent, filename);
        handle_error(RESULT, filename);
    end;

begin 
end.