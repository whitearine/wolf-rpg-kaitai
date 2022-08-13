meta:
  id: game_info
  endian: le
types:
  len_str:
    seq:
      - id: len
        type: u4
      - id: str
        size: len
seq:
  - id: magic
    contents: [0, 'W', 0, 0, 'O', 'L', 0, 'F', 'M', 0]
    
  - id: setting1_len
    type: u4
  - id: setting1
    type: u1
    repeat: expr
    repeat-expr: setting1_len
    
  - id: setting2_len
    type: u4
  - id: setting2
    type: len_str
    repeat: expr
    repeat-expr: setting2_len
    
  - id: filesize
    type: u4
    
  - id: keysize
    type: u4
  
  - id: setting3_len
    type: u4
  - id: setting3
    type: u2
    repeat: expr
    repeat-expr: setting3_len
  
  - id: keydata
    size: filesize - _io.pos
    doc: |
      encrypted_keydata
      
      ptr1 = readU4()
      ptr2 = readU4()
      arr1 = all_file_bytes[ptr1] as u2[keysize]
      arr2 = all_file_bytes[ptr2] as u2[keysize]
      key  = all_file_bytes[...sum(arr1, arr2) & 0xffff]
  
  - id: footer
    type: u1
    valid: 0xC2
