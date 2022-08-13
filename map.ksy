meta:
  id: map
  endian: le
  imports:
    - len_str
types:
  graphic:
    seq:
      - id: unk
        type: u4
      - id: graphic_name
        type: len_str
      - id: graphic_direction
        type: u1
      - id: graphic_frame
        type: u1
      - id: graphic_opacity
        type: u1
      - id: graphic_render_mode
        type: u1
  cond:
    enums:
      type:
        0: confirm_key
        1: autorun
        2: paralle_process
        3: player_touch
        4: event_touch
      operator:
        0: gt
        8: gte
        16: eq
        24: lte
        32: lt
        40: ne
        48: bit_and
    types:
      flag:
        seq:
          - id: flag
            type: u1
        instances:
          operator:
            value: flag >> 1
            enum: operator
          enable:
            value: (flag & 1) != 0
    seq:
      - id: type
        type: u1
        enum: type
      - id: flags
        type: flag
        repeat: expr
        repeat-expr: 4
      - id: vars
        type: u4
        repeat: expr
        repeat-expr: 4
      - id: values
        type: u4
        repeat: expr
        repeat-expr: 4
  move_route:
    enums:
      type:
        0: dont_move
        1: custom
        2: random
        3: toward_hero
    types:
      options:
        seq:
          - id: flag
            type: u1
        instances:
          idle_animation:
            value: (flag & 1) != 0
          move_animation:
            value: ((flag >> 1) & 1) != 0
          fixed_direction:
            value: ((flag >> 2) & 1) != 0
          slip_through:
            value: ((flag >> 3) & 1) != 0
          above_hero:
            value: ((flag >> 4) & 1) != 0
          square_hitbox:
            value: ((flag >> 5) & 1) != 0
          place_half_step_up:
            value: ((flag >> 6) & 1) != 0
          
      custom_route_options:
        seq:
          - id: flag
            type: u1
        instances:
          repeat_actions:
            value: (flag & 1) != 0
          skip_impossible_moves:
            value: ((flag >> 1) & 1) != 0
          wait_until_done:
            value: ((flag >> 2) & 1) != 0
      route:
        seq:
          - id: type
            type: u1
          - id: u4_arg_len
            type: u1
          - id: u4_arg
            type: u4
            repeat: expr
            repeat-expr: u4_arg_len
          - id: u1_arg_len
            type: u1
          - id: u1_arg
            type: u1
            repeat: expr
            repeat-expr: u1_arg_len
    seq:
      - id: anim_speed
        type: u1
      - id: move_speed
        type: u1
      - id: move_freq
        type: u1
      - id: type
        type: u1
        enum: type
      - id: options
        type: options
      - id: custom_route_options
        type: custom_route_options
      - id: route_len
        type: u4
      - id: routes
        type: route
        repeat: expr
        repeat-expr: route_len
  cmd:
    seq:
      - id: num_arg_len
        type: u1
      - id: num_arg
        doc: 'first item: cmd type'
        type: u4
        repeat: expr
        repeat-expr: num_arg_len
      - id: indent
        type: u1
      - id: str_arg_len
        type: u1
      - id: str_arg
        type: len_str
        repeat: expr
        repeat-expr: str_arg_len
      - id: has_move_route
        type: u1
        valid:
          any-of:
            - 0
            - 1
      - id: move_route
        type: move_route
        if: has_move_route >= 1
  page:
    seq:
      - id: check
        type: u1
        valid: 0x79
      - id: graphic
        type: graphic
      - id: cond
        type: cond
      - id: move_route
        type: move_route
      - id: cmd_len
        type: u4
      - id: cmd
        type: cmd
        repeat: expr
        repeat-expr: cmd_len
      - id: unk_len
        type: u4
      - id: unk
        size: unk_len
      
      - id: check2
        type: u1
        valid: 0x7a
  event:
    seq:
      - id: check1
        type: u1
        valid: 0x6f
      - id: check2
        type: u4
        valid: 0x3039
      
      - id: event_id
        type: u4
      - id: name
        type: len_str
      - id: x
        type: u4
      - id: y
        type: u4
      
      - id: page_len
        type: u4
        
      - id: unk_len
        type: u4
      - id: unk
        size: unk_len
      
      - id: pages
        type: page
        repeat: expr
        repeat-expr: page_len
      
      - id: check3
        type: u1
        valid: 0x70
      
seq:
  - id: magic
    contents: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'WOLFM', 0, 0, 0, 0, 0]
  
  - id: len
    type: u4
  - id: check
    type: u1
    valid: 0x65
  
  - id: unk
    type: len_str
  
  - id: tileset_id
    type: u4
  
  - id: width
    type: u4
  - id: height
    type: u4
  
  - id: event_size
    type: u4
    
  - id: map
    doc: 'map[layer][w][h]'
    type: u4
    repeat: expr
    repeat-expr: width*height*3
    
  - id: events
    type: event
    repeat: expr
    repeat-expr: event_size
  
  - id: check3
    type: u1
    valid: 0x66
