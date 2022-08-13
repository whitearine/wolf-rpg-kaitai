meta:
  id: len_str
  endian: le
types:
  len_str:
    seq:
      - id: len
        type: u4
      - id: str
        size: len