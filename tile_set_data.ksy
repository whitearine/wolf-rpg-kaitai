meta:
  id: tile_set_data
  endian: le
  imports:
    - len_str
types:
  hmm:
    params:
      - id: ver
        type: u4
    seq:
      - id: unk1_len
        type: u4
      - id: unk1
        size: unk1_len
      
      - id: unk2
        repeat: expr
        repeat-expr: ver > 209 ? 8 : 16
        type: len_str
      
      - id: check
        type: u1
        valid: 0xFF
      
      - id: unk3_len
        type: u4
      - id: unk3
        size: unk3_len
      
      - id: check2
        type: u1
        valid: 0xFF
      
      - id: unk4_len
        type: u4
      - id: unk4_ver207
        size: unk4_len
        if: ver == 207
      - id: unk4
        type: u4
        repeat: expr
        repeat-expr: unk4_len
        if: ver >= 208
      
      # ㅁ?ㄹ
      # if ver < 209
      # if (unk3_item & 0x110) != 0 unk3_item |= 0x200
        
seq:
  - id: magic
    contents: [0, 'W', 0, 0, 'O', 'L', 0, 'F', 'M', 0]
    
  - id: version
    type: u1
    valid:
      any-of:
        - 207
        - 208
        - 209
      
  - id: a
    type: u4
    
  - id: tt
    type: hmm(version)
    repeat: expr
    repeat-expr: a
  
  - id: footer
    type: u1
    valid: 0xCF
