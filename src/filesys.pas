unit FILESYS;

interface 

    type 
        FILE_TYPE = (DIRECTORY, EXECUTABLE, TEXT, IMAGE);
        RESULT_TYPE = (ROOT_EXCEPTION, DONE, FILE_NOT_FOUND, FILE_FOUND);

        // file_data = record 
        //     name: string;
        //     content: string;
        //     size: integer;
        //     _type: FILE_TYPE;
        // end;

        file_t = ^file_type_t;
        file_type_t = record 
            // data: file_data;
            name: string;
            parent: file_t;
            sub: file_t;
            prev, next: file_t;
        end;
    
        file_tree = ^file_tree_type;

        file_tree_type = record 
            root: file_t;
        end;
    
    function file_create(filename: string): file_t;
    function file_tree_create(): file_tree;

    function get_filename(myfile: file_t): string;
    function get_sub_files(myfile: file_t): file_t;
    function get_prev_file(myfile: file_t): file_t;
    function get_parent_file(myfile: file_t): file_t;
    function get_next_file(myfile: file_t): file_t;

    function file_exists(parent: file_t; filename: string): boolean;
    function get_file(parent: file_t; filename: string): file_t;
    function file_add(parent: file_t; name: string): RESULT_TYPE;
    function remove_sub_files(myfile: file_t): RESULT_TYPE;
    function file_remove(myfile: file_t): RESULT_TYPE;

implementation

function file_create(filename: string): file_t;

    var result: file_t;

    begin
        new(result);
        result^.name := filename;
        result^.parent := NIL;
        result^.next := NIL;
        result^.prev := NIL;
        result^.sub := NIL;
        file_create := result;
        result := NIL;
    end;

function file_tree_create(): file_tree;

    var result: file_tree;

    begin
        new(result);
        result^.root := NIL;
        file_tree_create := result;
        result := NIL; 
    end;

function get_filename(myfile: file_t): string;

    begin 
        get_filename := myfile^.name;
    end;

function get_sub_files(myfile: file_t): file_t;

    begin 
        get_sub_files := myfile^.sub;
    end;

function get_prev_file(myfile: file_t): file_t;

    begin
        get_prev_file := myfile^.prev; 
    end;

function get_parent_file(myfile: file_t): file_t;

    begin 
        get_parent_file := myfile^.parent;
    end;

function get_next_file(myfile: file_t): file_t;

    begin
        get_next_file := myfile^.next; 
    end;

function file_exists(parent: file_t; filename: string): boolean;

    var current_file: file_t;
        result: BOOLEAN;

    begin
        current_file := get_sub_files(parent);
        result := FALSE;

        while ((not result) and (current_file <> NIL)) do 
            begin
                result := (get_filename(current_file) = filename);
                current_file := current_file^.next;
            end; 
        
        file_exists := result;
    end;

function get_file(parent: file_t; filename: string): file_t;

    var current_file: file_t;

    begin
        current_file := get_sub_files(parent);

        while (current_file <> NIL) do 
            if (get_filename(current_file) = filename) then 
                break
            else 
                current_file := get_next_file(current_file);
        
        get_file := current_file;
    end;

// assuming the parent file isn't NULL (aka the new file added isn't the root!)
function file_add(parent: file_t; name: string): RESULT_TYPE;

    var sub_files, new_file: file_t;

    begin
        if (file_exists(parent, name)) then 
            begin 
                file_add := FILE_FOUND;
                exit();
            end;
        
        new_file := file_create(name); 
        sub_files := get_sub_files(parent);

        new_file^.next := sub_files;
        parent^.sub := new_file;
        new_file^.parent := parent;
        
        if (sub_files <> NIL) then 
            sub_files^.prev := new_file;
        
        file_add := DONE;
    end;

function remove_sub_files(myfile: file_t): RESULT_TYPE;

    var next_file, current_file : file_t;

    begin
        if (myfile = NIL) then 
            begin
                remove_sub_files := FILE_NOT_FOUND;
                exit(); 
            end;
        
        current_file := get_sub_files(myfile);

        while (current_file <> NIL) do 
            begin
                next_file := get_next_file(myfile);
                remove_sub_files(current_file);

                current_file^.prev := NIL;
                current_file^.next := NIL;
                dispose(current_file);
                current_file := NIL;

                current_file := next_file;
            end;

        myfile^.sub := NIL;
        remove_sub_files := DONE;
    end;

function file_remove(myfile: file_t): RESULT_TYPE;

    var parent_file, prev_file, next_file: file_t;

    begin 
        parent_file := get_parent_file(myfile);
        prev_file := get_prev_file(myfile);
        next_file := get_next_file(myfile);

        if (parent_file = NIL) then 
            begin
                file_remove := ROOT_EXCEPTION;
                exit(); 
            end;

        if (prev_file = NIL) then 
            parent_file^.sub := next_file
        else 
            begin 
                parent_file^.sub := prev_file;
                prev_file^.next := next_file;
            end;
        
        if (next_file <> NIL) then 
            next_file^.prev := prev_file;   
        
        remove_sub_files(myfile);
        dispose(myfile);
        myfile := NIL;

        file_remove := DONE;
    end;

begin 
end.



