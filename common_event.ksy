meta:
  id: common_event
  endian: le
  imports:
    - len_str
types:
  kuku:
    seq:
      - id: ku1
        type: u1
      - id: ku2_len
        type: u1
      - id: ku2
        type: u4
        repeat: expr
        repeat-expr: ku2_len
      - id: ku3_len
        type: u1
      - id: ku3
        size: ku3_len
  arg_special_str_data:
    seq:
      - id: values_len
        type: u4
      - id: values
        type: len_str
        repeat: expr
        repeat-expr: values_len
  arg_special_num_data:
    seq:
      - id: values_len
        type: u4
      - id: values
        type: u4
        repeat: expr
        repeat-expr: values_len
  po:
    seq:
      - id: color
        type: u4
      - id: var_names
        type: len_str
        repeat: expr
        repeat-expr: 100
      - id: check
        type: u1
        valid:
          any-of:
            - 0x90
            - 0x91
      - id: wm
        type: wm
        if: check == 0x91
  wm:
    seq:
      - id: a
        type: len_str
      - id: check
        type: u1
        valid:
          any-of:
            - 0x91
            - 0x92
      - id: return
        type: return
        if: check == 0x92
  return:
    seq:
      - id: name
        type: len_str
      - id: value_id
        type: u4
      - id: check
        type: u1
        valid: 0x92
  hmm:
    enums:
      special_type:
        0: no
        1: db_ref
        2: options
    seq:
      - id: arg_names_len
        type: u4
      - id: arg_names
        type: len_str
        repeat: expr
        repeat-expr: arg_names_len
      
      - id: type_len
        type: u4
      - id: types
        type: u1
        enum: special_type
        repeat: expr
        repeat-expr: type_len
        
        
      - id: arg_special_str_data_len
        type: u4
      - id: arg_special_str_data
        type: arg_special_str_data
        repeat: expr
        repeat-expr: arg_special_str_data_len
      
      - id: arg_special_num_data_len
        type: u4
      - id: arg_special_num_data
        type: arg_special_num_data
        repeat: expr
        repeat-expr: arg_special_num_data_len
        
      - id: arg_default_len
        type: u4
      - id: arg_default
        type: u4
        repeat: expr
        repeat-expr: arg_default_len
        
      - id: check
        type: u1
        valid:
          any-of:
            - 0x8F
            - 0x90
      
      - id: po
        type: po
        if: check == 0x90
  event:
    seq:
      - id: checka
        type: u1
        valid: 0x8E
      - id: id
        type: u4
      - id: run_cond
        type: u1
      - id: c
        type: u4
        valid: 0x1E8480
      - id: d
        type: u4
        valid: 0
      - id: enabled_num_arg_num
        type: u1
      - id: enabled_str_arg_num
        type: u1
      - id: name
        type: len_str
      - id: len
        type: u4
      - id: ins
        type: instruction
        repeat: expr
        repeat-expr: len
      - id: note_len
        type: u4
      - id: unk
        size: note_len
      - id: note
        if: note_len >= 1
        type: len_str
      
      - id: check
        type: u1
        valid:
          any-of:
           - 0x8E
           - 0x8F
           - 0x90
      - id: hmm
        type: hmm
        if: check != 0x8E
  instruction:
    seq:
      - id: u8_arg_len
        type: u1
      - id: u8_arg
        type: u4
        repeat: expr
        repeat-expr: u8_arg_len
      - id: indent
        type: u1
      - id: str_arg_len
        type: u1
      - id: str_arg
        type: len_str
        repeat: expr
        repeat-expr: str_arg_len 
      - id: l4
        type: u1
        
      - id: l5
        size: 6
        if: l4 >= 1
      - id: l6
        type: u4
        if: l4 >= 1
      - id: l7
        if: l6 <= 65536
        type: kuku
seq:
  - id: magic
    contents: [0, 'W', 0, 0, 'O', 'L', 0, 'F', 'C', 0]
  
  - id: check
    type: u1
    valid: 0x8f
  
  - id: events_len
    type: u4
  
  - id: events
    type: event
    repeat: expr
    repeat-expr: events_len
  
  - id: footer
    type: u1
    valid: 0x8F
    
