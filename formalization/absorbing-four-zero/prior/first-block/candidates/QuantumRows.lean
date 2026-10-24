import FastQuantumData

set_option maxHeartbeats 0

set_option maxRecDepth 1000000

namespace SmallQuantum

def ZAfast (v : V) : Finset C :=

  if v.val < 84 then
    if v.val < 42 then
      if v.val < 21 then
        if v.val < 10 then
          if v.val < 5 then
            if v.val < 2 then
              match v.val with
              | 0 => {0,1,3}
              | 1 => {1,2,4}
              | _ => ∅
            else
              if v.val < 3 then
                match v.val with
                | 2 => {2,3,5}
                | _ => ∅
              else
                match v.val with
                | 3 => {3,4,6}
                | 4 => {0,4,5}
                | _ => ∅
          else
            if v.val < 7 then
              match v.val with
              | 5 => {1,5,6}
              | 6 => {0,2,6}
              | _ => ∅
            else
              if v.val < 8 then
                match v.val with
                | 7 => {7,8,10}
                | _ => ∅
              else
                match v.val with
                | 8 => {8,9,11}
                | 9 => {9,10,12}
                | _ => ∅
        else
          if v.val < 15 then
            if v.val < 12 then
              match v.val with
              | 10 => {10,11,13}
              | 11 => {7,11,12}
              | _ => ∅
            else
              if v.val < 13 then
                match v.val with
                | 12 => {8,12,13}
                | _ => ∅
              else
                match v.val with
                | 13 => {7,9,13}
                | 14 => {14,15,17}
                | _ => ∅
          else
            if v.val < 18 then
              if v.val < 16 then
                match v.val with
                | 15 => {15,16,18}
                | _ => ∅
              else
                match v.val with
                | 16 => {16,17,19}
                | 17 => {17,18,20}
                | _ => ∅
            else
              if v.val < 19 then
                match v.val with
                | 18 => {14,18,19}
                | _ => ∅
              else
                match v.val with
                | 19 => {15,19,20}
                | 20 => {14,16,20}
                | _ => ∅
      else
        if v.val < 31 then
          if v.val < 26 then
            if v.val < 23 then
              match v.val with
              | 21 => {21,22,24}
              | 22 => {22,23,25}
              | _ => ∅
            else
              if v.val < 24 then
                match v.val with
                | 23 => {23,24,26}
                | _ => ∅
              else
                match v.val with
                | 24 => {24,25,27}
                | 25 => {21,25,26}
                | _ => ∅
          else
            if v.val < 28 then
              match v.val with
              | 26 => {22,26,27}
              | 27 => {21,23,27}
              | _ => ∅
            else
              if v.val < 29 then
                match v.val with
                | 28 => {28,29,31}
                | _ => ∅
              else
                match v.val with
                | 29 => {29,30,32}
                | 30 => {30,31,33}
                | _ => ∅
        else
          if v.val < 36 then
            if v.val < 33 then
              match v.val with
              | 31 => {31,32,34}
              | 32 => {28,32,33}
              | _ => ∅
            else
              if v.val < 34 then
                match v.val with
                | 33 => {29,33,34}
                | _ => ∅
              else
                match v.val with
                | 34 => {28,30,34}
                | 35 => {35,36,38}
                | _ => ∅
          else
            if v.val < 39 then
              if v.val < 37 then
                match v.val with
                | 36 => {36,37,39}
                | _ => ∅
              else
                match v.val with
                | 37 => {37,38,40}
                | 38 => {38,39,41}
                | _ => ∅
            else
              if v.val < 40 then
                match v.val with
                | 39 => {35,39,40}
                | _ => ∅
              else
                match v.val with
                | 40 => {36,40,41}
                | 41 => {35,37,41}
                | _ => ∅
    else
      if v.val < 63 then
        if v.val < 52 then
          if v.val < 47 then
            if v.val < 44 then
              match v.val with
              | 42 => {42,43,45}
              | 43 => {43,44,46}
              | _ => ∅
            else
              if v.val < 45 then
                match v.val with
                | 44 => {44,45,47}
                | _ => ∅
              else
                match v.val with
                | 45 => {45,46,48}
                | 46 => {42,46,47}
                | _ => ∅
          else
            if v.val < 49 then
              match v.val with
              | 47 => {43,47,48}
              | 48 => {42,44,48}
              | _ => ∅
            else
              if v.val < 50 then
                match v.val with
                | 49 => {49,50,52}
                | _ => ∅
              else
                match v.val with
                | 50 => {50,51,53}
                | 51 => {51,52,54}
                | _ => ∅
        else
          if v.val < 57 then
            if v.val < 54 then
              match v.val with
              | 52 => {52,53,55}
              | 53 => {49,53,54}
              | _ => ∅
            else
              if v.val < 55 then
                match v.val with
                | 54 => {50,54,55}
                | _ => ∅
              else
                match v.val with
                | 55 => {49,51,55}
                | 56 => {56,57,59}
                | _ => ∅
          else
            if v.val < 60 then
              if v.val < 58 then
                match v.val with
                | 57 => {57,58,60}
                | _ => ∅
              else
                match v.val with
                | 58 => {58,59,61}
                | 59 => {59,60,62}
                | _ => ∅
            else
              if v.val < 61 then
                match v.val with
                | 60 => {56,60,61}
                | _ => ∅
              else
                match v.val with
                | 61 => {57,61,62}
                | 62 => {56,58,62}
                | _ => ∅
      else
        if v.val < 73 then
          if v.val < 68 then
            if v.val < 65 then
              match v.val with
              | 63 => {63,64,66}
              | 64 => {64,65,67}
              | _ => ∅
            else
              if v.val < 66 then
                match v.val with
                | 65 => {65,66,68}
                | _ => ∅
              else
                match v.val with
                | 66 => {66,67,69}
                | 67 => {63,67,68}
                | _ => ∅
          else
            if v.val < 70 then
              match v.val with
              | 68 => {64,68,69}
              | 69 => {63,65,69}
              | _ => ∅
            else
              if v.val < 71 then
                match v.val with
                | 70 => {70,71,73}
                | _ => ∅
              else
                match v.val with
                | 71 => {71,72,74}
                | 72 => {72,73,75}
                | _ => ∅
        else
          if v.val < 78 then
            if v.val < 75 then
              match v.val with
              | 73 => {73,74,76}
              | 74 => {70,74,75}
              | _ => ∅
            else
              if v.val < 76 then
                match v.val with
                | 75 => {71,75,76}
                | _ => ∅
              else
                match v.val with
                | 76 => {70,72,76}
                | 77 => {77,78,80}
                | _ => ∅
          else
            if v.val < 81 then
              if v.val < 79 then
                match v.val with
                | 78 => {78,79,81}
                | _ => ∅
              else
                match v.val with
                | 79 => {79,80,82}
                | 80 => {80,81,83}
                | _ => ∅
            else
              if v.val < 82 then
                match v.val with
                | 81 => {77,81,82}
                | _ => ∅
              else
                match v.val with
                | 82 => {78,82,83}
                | 83 => {77,79,83}
                | _ => ∅
  else
    if v.val < 126 then
      if v.val < 105 then
        if v.val < 94 then
          if v.val < 89 then
            if v.val < 86 then
              match v.val with
              | 84 => {0,7,14}
              | 85 => {1,8,15}
              | _ => ∅
            else
              if v.val < 87 then
                match v.val with
                | 86 => {2,9,16}
                | _ => ∅
              else
                match v.val with
                | 87 => {3,10,17}
                | 88 => {4,11,18}
                | _ => ∅
          else
            if v.val < 91 then
              match v.val with
              | 89 => {5,12,19}
              | 90 => {6,13,20}
              | _ => ∅
            else
              if v.val < 92 then
                match v.val with
                | 91 => {0,21,28}
                | _ => ∅
              else
                match v.val with
                | 92 => {1,22,29}
                | 93 => {2,23,30}
                | _ => ∅
        else
          if v.val < 99 then
            if v.val < 96 then
              match v.val with
              | 94 => {3,24,31}
              | 95 => {4,25,32}
              | _ => ∅
            else
              if v.val < 97 then
                match v.val with
                | 96 => {5,26,33}
                | _ => ∅
              else
                match v.val with
                | 97 => {6,27,34}
                | 98 => {0,35,42}
                | _ => ∅
          else
            if v.val < 102 then
              if v.val < 100 then
                match v.val with
                | 99 => {1,36,43}
                | _ => ∅
              else
                match v.val with
                | 100 => {2,37,44}
                | 101 => {3,38,45}
                | _ => ∅
            else
              if v.val < 103 then
                match v.val with
                | 102 => {4,39,46}
                | _ => ∅
              else
                match v.val with
                | 103 => {5,40,47}
                | 104 => {6,41,48}
                | _ => ∅
      else
        if v.val < 115 then
          if v.val < 110 then
            if v.val < 107 then
              match v.val with
              | 105 => {7,21,49}
              | 106 => {8,22,50}
              | _ => ∅
            else
              if v.val < 108 then
                match v.val with
                | 107 => {9,23,51}
                | _ => ∅
              else
                match v.val with
                | 108 => {10,24,52}
                | 109 => {11,25,53}
                | _ => ∅
          else
            if v.val < 112 then
              match v.val with
              | 110 => {12,26,54}
              | 111 => {13,27,55}
              | _ => ∅
            else
              if v.val < 113 then
                match v.val with
                | 112 => {7,35,56}
                | _ => ∅
              else
                match v.val with
                | 113 => {8,36,57}
                | 114 => {9,37,58}
                | _ => ∅
        else
          if v.val < 120 then
            if v.val < 117 then
              match v.val with
              | 115 => {10,38,59}
              | 116 => {11,39,60}
              | _ => ∅
            else
              if v.val < 118 then
                match v.val with
                | 117 => {12,40,61}
                | _ => ∅
              else
                match v.val with
                | 118 => {13,41,62}
                | 119 => {21,35,63}
                | _ => ∅
          else
            if v.val < 123 then
              if v.val < 121 then
                match v.val with
                | 120 => {22,36,64}
                | _ => ∅
              else
                match v.val with
                | 121 => {23,37,65}
                | 122 => {24,38,66}
                | _ => ∅
            else
              if v.val < 124 then
                match v.val with
                | 123 => {25,39,67}
                | _ => ∅
              else
                match v.val with
                | 124 => {26,40,68}
                | 125 => {27,41,69}
                | _ => ∅
    else
      if v.val < 147 then
        if v.val < 136 then
          if v.val < 131 then
            if v.val < 128 then
              match v.val with
              | 126 => {28,49,70}
              | 127 => {29,50,71}
              | _ => ∅
            else
              if v.val < 129 then
                match v.val with
                | 128 => {30,51,72}
                | _ => ∅
              else
                match v.val with
                | 129 => {31,52,73}
                | 130 => {32,53,74}
                | _ => ∅
          else
            if v.val < 133 then
              match v.val with
              | 131 => {33,54,75}
              | 132 => {34,55,76}
              | _ => ∅
            else
              if v.val < 134 then
                match v.val with
                | 133 => {49,56,63}
                | _ => ∅
              else
                match v.val with
                | 134 => {50,57,64}
                | 135 => {51,58,65}
                | _ => ∅
        else
          if v.val < 141 then
            if v.val < 138 then
              match v.val with
              | 136 => {52,59,66}
              | 137 => {53,60,67}
              | _ => ∅
            else
              if v.val < 139 then
                match v.val with
                | 138 => {54,61,68}
                | _ => ∅
              else
                match v.val with
                | 139 => {55,62,69}
                | 140 => {56,70,77}
                | _ => ∅
          else
            if v.val < 144 then
              if v.val < 142 then
                match v.val with
                | 141 => {57,71,78}
                | _ => ∅
              else
                match v.val with
                | 142 => {58,72,79}
                | 143 => {59,73,80}
                | _ => ∅
            else
              if v.val < 145 then
                match v.val with
                | 144 => {60,74,81}
                | _ => ∅
              else
                match v.val with
                | 145 => {61,75,82}
                | 146 => {62,76,83}
                | _ => ∅
      else
        if v.val < 157 then
          if v.val < 152 then
            if v.val < 149 then
              match v.val with
              | 147 => {28,42,77}
              | 148 => {29,43,78}
              | _ => ∅
            else
              if v.val < 150 then
                match v.val with
                | 149 => {30,44,79}
                | _ => ∅
              else
                match v.val with
                | 150 => {31,45,80}
                | 151 => {32,46,81}
                | _ => ∅
          else
            if v.val < 154 then
              match v.val with
              | 152 => {33,47,82}
              | 153 => {34,48,83}
              | _ => ∅
            else
              if v.val < 155 then
                match v.val with
                | 154 => {14,42,70}
                | _ => ∅
              else
                match v.val with
                | 155 => {15,43,71}
                | 156 => {16,44,72}
                | _ => ∅
        else
          if v.val < 162 then
            if v.val < 159 then
              match v.val with
              | 157 => {17,45,73}
              | 158 => {18,46,74}
              | _ => ∅
            else
              if v.val < 160 then
                match v.val with
                | 159 => {19,47,75}
                | _ => ∅
              else
                match v.val with
                | 160 => {20,48,76}
                | 161 => {14,63,77}
                | _ => ∅
          else
            if v.val < 165 then
              if v.val < 163 then
                match v.val with
                | 162 => {15,64,78}
                | _ => ∅
              else
                match v.val with
                | 163 => {16,65,79}
                | 164 => {17,66,80}
                | _ => ∅
            else
              if v.val < 166 then
                match v.val with
                | 165 => {18,67,81}
                | _ => ∅
              else
                match v.val with
                | 166 => {19,68,82}
                | 167 => {20,69,83}
                | _ => ∅

theorem ZAfast_eq : ZAfast = ZA := by

  funext v

  have h : ∀ v, ZAfast v = ZA v := by decide

  exact h v

def rowXA (c : C) : Finset V :=

  if c.val < 42 then
    if c.val < 21 then
      if c.val < 10 then
        if c.val < 5 then
          if c.val < 2 then
            match c.val with
            | 0 => {0,7,14,84,85,87}
            | 1 => {1,8,15,85,86,88}
            | _ => ∅
          else
            if c.val < 3 then
              match c.val with
              | 2 => {2,9,16,86,87,89}
              | _ => ∅
            else
              match c.val with
              | 3 => {3,10,17,87,88,90}
              | 4 => {4,11,18,84,88,89}
              | _ => ∅
        else
          if c.val < 7 then
            match c.val with
            | 5 => {5,12,19,85,89,90}
            | 6 => {6,13,20,84,86,90}
            | _ => ∅
          else
            if c.val < 8 then
              match c.val with
              | 7 => {0,21,28,91,92,94}
              | _ => ∅
            else
              match c.val with
              | 8 => {1,22,29,92,93,95}
              | 9 => {2,23,30,93,94,96}
              | _ => ∅
      else
        if c.val < 15 then
          if c.val < 12 then
            match c.val with
            | 10 => {3,24,31,94,95,97}
            | 11 => {4,25,32,91,95,96}
            | _ => ∅
          else
            if c.val < 13 then
              match c.val with
              | 12 => {5,26,33,92,96,97}
              | _ => ∅
            else
              match c.val with
              | 13 => {6,27,34,91,93,97}
              | 14 => {0,35,42,98,99,101}
              | _ => ∅
        else
          if c.val < 18 then
            if c.val < 16 then
              match c.val with
              | 15 => {1,36,43,99,100,102}
              | _ => ∅
            else
              match c.val with
              | 16 => {2,37,44,100,101,103}
              | 17 => {3,38,45,101,102,104}
              | _ => ∅
          else
            if c.val < 19 then
              match c.val with
              | 18 => {4,39,46,98,102,103}
              | _ => ∅
            else
              match c.val with
              | 19 => {5,40,47,99,103,104}
              | 20 => {6,41,48,98,100,104}
              | _ => ∅
    else
      if c.val < 31 then
        if c.val < 26 then
          if c.val < 23 then
            match c.val with
            | 21 => {7,21,49,105,106,108}
            | 22 => {8,22,50,106,107,109}
            | _ => ∅
          else
            if c.val < 24 then
              match c.val with
              | 23 => {9,23,51,107,108,110}
              | _ => ∅
            else
              match c.val with
              | 24 => {10,24,52,108,109,111}
              | 25 => {11,25,53,105,109,110}
              | _ => ∅
        else
          if c.val < 28 then
            match c.val with
            | 26 => {12,26,54,106,110,111}
            | 27 => {13,27,55,105,107,111}
            | _ => ∅
          else
            if c.val < 29 then
              match c.val with
              | 28 => {7,35,56,112,113,115}
              | _ => ∅
            else
              match c.val with
              | 29 => {8,36,57,113,114,116}
              | 30 => {9,37,58,114,115,117}
              | _ => ∅
      else
        if c.val < 36 then
          if c.val < 33 then
            match c.val with
            | 31 => {10,38,59,115,116,118}
            | 32 => {11,39,60,112,116,117}
            | _ => ∅
          else
            if c.val < 34 then
              match c.val with
              | 33 => {12,40,61,113,117,118}
              | _ => ∅
            else
              match c.val with
              | 34 => {13,41,62,112,114,118}
              | 35 => {21,35,63,119,120,122}
              | _ => ∅
        else
          if c.val < 39 then
            if c.val < 37 then
              match c.val with
              | 36 => {22,36,64,120,121,123}
              | _ => ∅
            else
              match c.val with
              | 37 => {23,37,65,121,122,124}
              | 38 => {24,38,66,122,123,125}
              | _ => ∅
          else
            if c.val < 40 then
              match c.val with
              | 39 => {25,39,67,119,123,124}
              | _ => ∅
            else
              match c.val with
              | 40 => {26,40,68,120,124,125}
              | 41 => {27,41,69,119,121,125}
              | _ => ∅
  else
    if c.val < 63 then
      if c.val < 52 then
        if c.val < 47 then
          if c.val < 44 then
            match c.val with
            | 42 => {28,49,70,126,127,129}
            | 43 => {29,50,71,127,128,130}
            | _ => ∅
          else
            if c.val < 45 then
              match c.val with
              | 44 => {30,51,72,128,129,131}
              | _ => ∅
            else
              match c.val with
              | 45 => {31,52,73,129,130,132}
              | 46 => {32,53,74,126,130,131}
              | _ => ∅
        else
          if c.val < 49 then
            match c.val with
            | 47 => {33,54,75,127,131,132}
            | 48 => {34,55,76,126,128,132}
            | _ => ∅
          else
            if c.val < 50 then
              match c.val with
              | 49 => {49,56,63,133,134,136}
              | _ => ∅
            else
              match c.val with
              | 50 => {50,57,64,134,135,137}
              | 51 => {51,58,65,135,136,138}
              | _ => ∅
      else
        if c.val < 57 then
          if c.val < 54 then
            match c.val with
            | 52 => {52,59,66,136,137,139}
            | 53 => {53,60,67,133,137,138}
            | _ => ∅
          else
            if c.val < 55 then
              match c.val with
              | 54 => {54,61,68,134,138,139}
              | _ => ∅
            else
              match c.val with
              | 55 => {55,62,69,133,135,139}
              | 56 => {56,70,77,140,141,143}
              | _ => ∅
        else
          if c.val < 60 then
            if c.val < 58 then
              match c.val with
              | 57 => {57,71,78,141,142,144}
              | _ => ∅
            else
              match c.val with
              | 58 => {58,72,79,142,143,145}
              | 59 => {59,73,80,143,144,146}
              | _ => ∅
          else
            if c.val < 61 then
              match c.val with
              | 60 => {60,74,81,140,144,145}
              | _ => ∅
            else
              match c.val with
              | 61 => {61,75,82,141,145,146}
              | 62 => {62,76,83,140,142,146}
              | _ => ∅
    else
      if c.val < 73 then
        if c.val < 68 then
          if c.val < 65 then
            match c.val with
            | 63 => {28,42,77,147,148,150}
            | 64 => {29,43,78,148,149,151}
            | _ => ∅
          else
            if c.val < 66 then
              match c.val with
              | 65 => {30,44,79,149,150,152}
              | _ => ∅
            else
              match c.val with
              | 66 => {31,45,80,150,151,153}
              | 67 => {32,46,81,147,151,152}
              | _ => ∅
        else
          if c.val < 70 then
            match c.val with
            | 68 => {33,47,82,148,152,153}
            | 69 => {34,48,83,147,149,153}
            | _ => ∅
          else
            if c.val < 71 then
              match c.val with
              | 70 => {14,42,70,154,155,157}
              | _ => ∅
            else
              match c.val with
              | 71 => {15,43,71,155,156,158}
              | 72 => {16,44,72,156,157,159}
              | _ => ∅
      else
        if c.val < 78 then
          if c.val < 75 then
            match c.val with
            | 73 => {17,45,73,157,158,160}
            | 74 => {18,46,74,154,158,159}
            | _ => ∅
          else
            if c.val < 76 then
              match c.val with
              | 75 => {19,47,75,155,159,160}
              | _ => ∅
            else
              match c.val with
              | 76 => {20,48,76,154,156,160}
              | 77 => {14,63,77,161,162,164}
              | _ => ∅
        else
          if c.val < 81 then
            if c.val < 79 then
              match c.val with
              | 78 => {15,64,78,162,163,165}
              | _ => ∅
            else
              match c.val with
              | 79 => {16,65,79,163,164,166}
              | 80 => {17,66,80,164,165,167}
              | _ => ∅
          else
            if c.val < 82 then
              match c.val with
              | 81 => {18,67,81,161,165,166}
              | _ => ∅
            else
              match c.val with
              | 82 => {19,68,82,162,166,167}
              | 83 => {20,69,83,161,163,167}
              | _ => ∅

theorem rowXA_correct : ∀ c, rowXA c =

    Finset.univ.filter (fun v => c ∈ XAfast v) := by decide

#print axioms rowXA_correct

def rowZA (c : C) : Finset V :=

  if c.val < 42 then
    if c.val < 21 then
      if c.val < 10 then
        if c.val < 5 then
          if c.val < 2 then
            match c.val with
            | 0 => {0,4,6,84,91,98}
            | 1 => {0,1,5,85,92,99}
            | _ => ∅
          else
            if c.val < 3 then
              match c.val with
              | 2 => {1,2,6,86,93,100}
              | _ => ∅
            else
              match c.val with
              | 3 => {0,2,3,87,94,101}
              | 4 => {1,3,4,88,95,102}
              | _ => ∅
        else
          if c.val < 7 then
            match c.val with
            | 5 => {2,4,5,89,96,103}
            | 6 => {3,5,6,90,97,104}
            | _ => ∅
          else
            if c.val < 8 then
              match c.val with
              | 7 => {7,11,13,84,105,112}
              | _ => ∅
            else
              match c.val with
              | 8 => {7,8,12,85,106,113}
              | 9 => {8,9,13,86,107,114}
              | _ => ∅
      else
        if c.val < 15 then
          if c.val < 12 then
            match c.val with
            | 10 => {7,9,10,87,108,115}
            | 11 => {8,10,11,88,109,116}
            | _ => ∅
          else
            if c.val < 13 then
              match c.val with
              | 12 => {9,11,12,89,110,117}
              | _ => ∅
            else
              match c.val with
              | 13 => {10,12,13,90,111,118}
              | 14 => {14,18,20,84,154,161}
              | _ => ∅
        else
          if c.val < 18 then
            if c.val < 16 then
              match c.val with
              | 15 => {14,15,19,85,155,162}
              | _ => ∅
            else
              match c.val with
              | 16 => {15,16,20,86,156,163}
              | 17 => {14,16,17,87,157,164}
              | _ => ∅
          else
            if c.val < 19 then
              match c.val with
              | 18 => {15,17,18,88,158,165}
              | _ => ∅
            else
              match c.val with
              | 19 => {16,18,19,89,159,166}
              | 20 => {17,19,20,90,160,167}
              | _ => ∅
    else
      if c.val < 31 then
        if c.val < 26 then
          if c.val < 23 then
            match c.val with
            | 21 => {21,25,27,91,105,119}
            | 22 => {21,22,26,92,106,120}
            | _ => ∅
          else
            if c.val < 24 then
              match c.val with
              | 23 => {22,23,27,93,107,121}
              | _ => ∅
            else
              match c.val with
              | 24 => {21,23,24,94,108,122}
              | 25 => {22,24,25,95,109,123}
              | _ => ∅
        else
          if c.val < 28 then
            match c.val with
            | 26 => {23,25,26,96,110,124}
            | 27 => {24,26,27,97,111,125}
            | _ => ∅
          else
            if c.val < 29 then
              match c.val with
              | 28 => {28,32,34,91,126,147}
              | _ => ∅
            else
              match c.val with
              | 29 => {28,29,33,92,127,148}
              | 30 => {29,30,34,93,128,149}
              | _ => ∅
      else
        if c.val < 36 then
          if c.val < 33 then
            match c.val with
            | 31 => {28,30,31,94,129,150}
            | 32 => {29,31,32,95,130,151}
            | _ => ∅
          else
            if c.val < 34 then
              match c.val with
              | 33 => {30,32,33,96,131,152}
              | _ => ∅
            else
              match c.val with
              | 34 => {31,33,34,97,132,153}
              | 35 => {35,39,41,98,112,119}
              | _ => ∅
        else
          if c.val < 39 then
            if c.val < 37 then
              match c.val with
              | 36 => {35,36,40,99,113,120}
              | _ => ∅
            else
              match c.val with
              | 37 => {36,37,41,100,114,121}
              | 38 => {35,37,38,101,115,122}
              | _ => ∅
          else
            if c.val < 40 then
              match c.val with
              | 39 => {36,38,39,102,116,123}
              | _ => ∅
            else
              match c.val with
              | 40 => {37,39,40,103,117,124}
              | 41 => {38,40,41,104,118,125}
              | _ => ∅
  else
    if c.val < 63 then
      if c.val < 52 then
        if c.val < 47 then
          if c.val < 44 then
            match c.val with
            | 42 => {42,46,48,98,147,154}
            | 43 => {42,43,47,99,148,155}
            | _ => ∅
          else
            if c.val < 45 then
              match c.val with
              | 44 => {43,44,48,100,149,156}
              | _ => ∅
            else
              match c.val with
              | 45 => {42,44,45,101,150,157}
              | 46 => {43,45,46,102,151,158}
              | _ => ∅
        else
          if c.val < 49 then
            match c.val with
            | 47 => {44,46,47,103,152,159}
            | 48 => {45,47,48,104,153,160}
            | _ => ∅
          else
            if c.val < 50 then
              match c.val with
              | 49 => {49,53,55,105,126,133}
              | _ => ∅
            else
              match c.val with
              | 50 => {49,50,54,106,127,134}
              | 51 => {50,51,55,107,128,135}
              | _ => ∅
      else
        if c.val < 57 then
          if c.val < 54 then
            match c.val with
            | 52 => {49,51,52,108,129,136}
            | 53 => {50,52,53,109,130,137}
            | _ => ∅
          else
            if c.val < 55 then
              match c.val with
              | 54 => {51,53,54,110,131,138}
              | _ => ∅
            else
              match c.val with
              | 55 => {52,54,55,111,132,139}
              | 56 => {56,60,62,112,133,140}
              | _ => ∅
        else
          if c.val < 60 then
            if c.val < 58 then
              match c.val with
              | 57 => {56,57,61,113,134,141}
              | _ => ∅
            else
              match c.val with
              | 58 => {57,58,62,114,135,142}
              | 59 => {56,58,59,115,136,143}
              | _ => ∅
          else
            if c.val < 61 then
              match c.val with
              | 60 => {57,59,60,116,137,144}
              | _ => ∅
            else
              match c.val with
              | 61 => {58,60,61,117,138,145}
              | 62 => {59,61,62,118,139,146}
              | _ => ∅
    else
      if c.val < 73 then
        if c.val < 68 then
          if c.val < 65 then
            match c.val with
            | 63 => {63,67,69,119,133,161}
            | 64 => {63,64,68,120,134,162}
            | _ => ∅
          else
            if c.val < 66 then
              match c.val with
              | 65 => {64,65,69,121,135,163}
              | _ => ∅
            else
              match c.val with
              | 66 => {63,65,66,122,136,164}
              | 67 => {64,66,67,123,137,165}
              | _ => ∅
        else
          if c.val < 70 then
            match c.val with
            | 68 => {65,67,68,124,138,166}
            | 69 => {66,68,69,125,139,167}
            | _ => ∅
          else
            if c.val < 71 then
              match c.val with
              | 70 => {70,74,76,126,140,154}
              | _ => ∅
            else
              match c.val with
              | 71 => {70,71,75,127,141,155}
              | 72 => {71,72,76,128,142,156}
              | _ => ∅
      else
        if c.val < 78 then
          if c.val < 75 then
            match c.val with
            | 73 => {70,72,73,129,143,157}
            | 74 => {71,73,74,130,144,158}
            | _ => ∅
          else
            if c.val < 76 then
              match c.val with
              | 75 => {72,74,75,131,145,159}
              | _ => ∅
            else
              match c.val with
              | 76 => {73,75,76,132,146,160}
              | 77 => {77,81,83,140,147,161}
              | _ => ∅
        else
          if c.val < 81 then
            if c.val < 79 then
              match c.val with
              | 78 => {77,78,82,141,148,162}
              | _ => ∅
            else
              match c.val with
              | 79 => {78,79,83,142,149,163}
              | 80 => {77,79,80,143,150,164}
              | _ => ∅
          else
            if c.val < 82 then
              match c.val with
              | 81 => {78,80,81,144,151,165}
              | _ => ∅
            else
              match c.val with
              | 82 => {79,81,82,145,152,166}
              | 83 => {80,82,83,146,153,167}
              | _ => ∅

theorem rowZA_correct : ∀ c, rowZA c =

    Finset.univ.filter (fun v => c ∈ ZAfast v) := by decide

#print axioms rowZA_correct

theorem css_A : ∀ c d, ((rowXA c ∩ rowZA d).card % 2) = 0 := by decide

#print axioms css_A

def ZBfast (v : V) : Finset C :=

  if v.val < 84 then
    if v.val < 42 then
      if v.val < 21 then
        if v.val < 10 then
          if v.val < 5 then
            if v.val < 2 then
              match v.val with
              | 0 => {0,1,3}
              | 1 => {1,2,4}
              | _ => ∅
            else
              if v.val < 3 then
                match v.val with
                | 2 => {2,3,5}
                | _ => ∅
              else
                match v.val with
                | 3 => {3,4,6}
                | 4 => {0,4,5}
                | _ => ∅
          else
            if v.val < 7 then
              match v.val with
              | 5 => {1,5,6}
              | 6 => {0,2,6}
              | _ => ∅
            else
              if v.val < 8 then
                match v.val with
                | 7 => {7,8,10}
                | _ => ∅
              else
                match v.val with
                | 8 => {8,9,11}
                | 9 => {9,10,12}
                | _ => ∅
        else
          if v.val < 15 then
            if v.val < 12 then
              match v.val with
              | 10 => {10,11,13}
              | 11 => {7,11,12}
              | _ => ∅
            else
              if v.val < 13 then
                match v.val with
                | 12 => {8,12,13}
                | _ => ∅
              else
                match v.val with
                | 13 => {7,9,13}
                | 14 => {14,15,17}
                | _ => ∅
          else
            if v.val < 18 then
              if v.val < 16 then
                match v.val with
                | 15 => {15,16,18}
                | _ => ∅
              else
                match v.val with
                | 16 => {16,17,19}
                | 17 => {17,18,20}
                | _ => ∅
            else
              if v.val < 19 then
                match v.val with
                | 18 => {14,18,19}
                | _ => ∅
              else
                match v.val with
                | 19 => {15,19,20}
                | 20 => {14,16,20}
                | _ => ∅
      else
        if v.val < 31 then
          if v.val < 26 then
            if v.val < 23 then
              match v.val with
              | 21 => {21,22,24}
              | 22 => {22,23,25}
              | _ => ∅
            else
              if v.val < 24 then
                match v.val with
                | 23 => {23,24,26}
                | _ => ∅
              else
                match v.val with
                | 24 => {24,25,27}
                | 25 => {21,25,26}
                | _ => ∅
          else
            if v.val < 28 then
              match v.val with
              | 26 => {22,26,27}
              | 27 => {21,23,27}
              | _ => ∅
            else
              if v.val < 29 then
                match v.val with
                | 28 => {28,29,31}
                | _ => ∅
              else
                match v.val with
                | 29 => {29,30,32}
                | 30 => {30,31,33}
                | _ => ∅
        else
          if v.val < 36 then
            if v.val < 33 then
              match v.val with
              | 31 => {31,32,34}
              | 32 => {28,32,33}
              | _ => ∅
            else
              if v.val < 34 then
                match v.val with
                | 33 => {29,33,34}
                | _ => ∅
              else
                match v.val with
                | 34 => {28,30,34}
                | 35 => {35,36,38}
                | _ => ∅
          else
            if v.val < 39 then
              if v.val < 37 then
                match v.val with
                | 36 => {36,37,39}
                | _ => ∅
              else
                match v.val with
                | 37 => {37,38,40}
                | 38 => {38,39,41}
                | _ => ∅
            else
              if v.val < 40 then
                match v.val with
                | 39 => {35,39,40}
                | _ => ∅
              else
                match v.val with
                | 40 => {36,40,41}
                | 41 => {35,37,41}
                | _ => ∅
    else
      if v.val < 63 then
        if v.val < 52 then
          if v.val < 47 then
            if v.val < 44 then
              match v.val with
              | 42 => {42,43,45}
              | 43 => {43,44,46}
              | _ => ∅
            else
              if v.val < 45 then
                match v.val with
                | 44 => {44,45,47}
                | _ => ∅
              else
                match v.val with
                | 45 => {45,46,48}
                | 46 => {42,46,47}
                | _ => ∅
          else
            if v.val < 49 then
              match v.val with
              | 47 => {43,47,48}
              | 48 => {42,44,48}
              | _ => ∅
            else
              if v.val < 50 then
                match v.val with
                | 49 => {49,50,52}
                | _ => ∅
              else
                match v.val with
                | 50 => {50,51,53}
                | 51 => {51,52,54}
                | _ => ∅
        else
          if v.val < 57 then
            if v.val < 54 then
              match v.val with
              | 52 => {52,53,55}
              | 53 => {49,53,54}
              | _ => ∅
            else
              if v.val < 55 then
                match v.val with
                | 54 => {50,54,55}
                | _ => ∅
              else
                match v.val with
                | 55 => {49,51,55}
                | 56 => {56,57,59}
                | _ => ∅
          else
            if v.val < 60 then
              if v.val < 58 then
                match v.val with
                | 57 => {57,58,60}
                | _ => ∅
              else
                match v.val with
                | 58 => {58,59,61}
                | 59 => {59,60,62}
                | _ => ∅
            else
              if v.val < 61 then
                match v.val with
                | 60 => {56,60,61}
                | _ => ∅
              else
                match v.val with
                | 61 => {57,61,62}
                | 62 => {56,58,62}
                | _ => ∅
      else
        if v.val < 73 then
          if v.val < 68 then
            if v.val < 65 then
              match v.val with
              | 63 => {63,64,66}
              | 64 => {64,65,67}
              | _ => ∅
            else
              if v.val < 66 then
                match v.val with
                | 65 => {65,66,68}
                | _ => ∅
              else
                match v.val with
                | 66 => {66,67,69}
                | 67 => {63,67,68}
                | _ => ∅
          else
            if v.val < 70 then
              match v.val with
              | 68 => {64,68,69}
              | 69 => {63,65,69}
              | _ => ∅
            else
              if v.val < 71 then
                match v.val with
                | 70 => {70,71,73}
                | _ => ∅
              else
                match v.val with
                | 71 => {71,72,74}
                | 72 => {72,73,75}
                | _ => ∅
        else
          if v.val < 78 then
            if v.val < 75 then
              match v.val with
              | 73 => {73,74,76}
              | 74 => {70,74,75}
              | _ => ∅
            else
              if v.val < 76 then
                match v.val with
                | 75 => {71,75,76}
                | _ => ∅
              else
                match v.val with
                | 76 => {70,72,76}
                | 77 => {77,78,80}
                | _ => ∅
          else
            if v.val < 81 then
              if v.val < 79 then
                match v.val with
                | 78 => {78,79,81}
                | _ => ∅
              else
                match v.val with
                | 79 => {79,80,82}
                | 80 => {80,81,83}
                | _ => ∅
            else
              if v.val < 82 then
                match v.val with
                | 81 => {77,81,82}
                | _ => ∅
              else
                match v.val with
                | 82 => {78,82,83}
                | 83 => {77,79,83}
                | _ => ∅
  else
    if v.val < 126 then
      if v.val < 105 then
        if v.val < 94 then
          if v.val < 89 then
            if v.val < 86 then
              match v.val with
              | 84 => {0,7,14}
              | 85 => {1,8,15}
              | _ => ∅
            else
              if v.val < 87 then
                match v.val with
                | 86 => {2,9,16}
                | _ => ∅
              else
                match v.val with
                | 87 => {3,10,17}
                | 88 => {4,11,18}
                | _ => ∅
          else
            if v.val < 91 then
              match v.val with
              | 89 => {5,12,19}
              | 90 => {6,13,20}
              | _ => ∅
            else
              if v.val < 92 then
                match v.val with
                | 91 => {0,21,28}
                | _ => ∅
              else
                match v.val with
                | 92 => {1,22,29}
                | 93 => {2,23,30}
                | _ => ∅
        else
          if v.val < 99 then
            if v.val < 96 then
              match v.val with
              | 94 => {3,24,31}
              | 95 => {4,25,32}
              | _ => ∅
            else
              if v.val < 97 then
                match v.val with
                | 96 => {5,26,33}
                | _ => ∅
              else
                match v.val with
                | 97 => {6,27,34}
                | 98 => {7,21,35}
                | _ => ∅
          else
            if v.val < 102 then
              if v.val < 100 then
                match v.val with
                | 99 => {8,22,36}
                | _ => ∅
              else
                match v.val with
                | 100 => {9,23,37}
                | 101 => {10,24,38}
                | _ => ∅
            else
              if v.val < 103 then
                match v.val with
                | 102 => {11,25,39}
                | _ => ∅
              else
                match v.val with
                | 103 => {12,26,40}
                | 104 => {13,27,41}
                | _ => ∅
      else
        if v.val < 115 then
          if v.val < 110 then
            if v.val < 107 then
              match v.val with
              | 105 => {0,42,49}
              | 106 => {1,43,50}
              | _ => ∅
            else
              if v.val < 108 then
                match v.val with
                | 107 => {2,44,51}
                | _ => ∅
              else
                match v.val with
                | 108 => {3,45,52}
                | 109 => {4,46,53}
                | _ => ∅
          else
            if v.val < 112 then
              match v.val with
              | 110 => {5,47,54}
              | 111 => {6,48,55}
              | _ => ∅
            else
              if v.val < 113 then
                match v.val with
                | 112 => {7,42,56}
                | _ => ∅
              else
                match v.val with
                | 113 => {8,43,57}
                | 114 => {9,44,58}
                | _ => ∅
        else
          if v.val < 120 then
            if v.val < 117 then
              match v.val with
              | 115 => {10,45,59}
              | 116 => {11,46,60}
              | _ => ∅
            else
              if v.val < 118 then
                match v.val with
                | 117 => {12,47,61}
                | _ => ∅
              else
                match v.val with
                | 118 => {13,48,62}
                | 119 => {21,42,63}
                | _ => ∅
          else
            if v.val < 123 then
              if v.val < 121 then
                match v.val with
                | 120 => {22,43,64}
                | _ => ∅
              else
                match v.val with
                | 121 => {23,44,65}
                | 122 => {24,45,66}
                | _ => ∅
            else
              if v.val < 124 then
                match v.val with
                | 123 => {25,46,67}
                | _ => ∅
              else
                match v.val with
                | 124 => {26,47,68}
                | 125 => {27,48,69}
                | _ => ∅
    else
      if v.val < 147 then
        if v.val < 136 then
          if v.val < 131 then
            if v.val < 128 then
              match v.val with
              | 126 => {28,49,70}
              | 127 => {29,50,71}
              | _ => ∅
            else
              if v.val < 129 then
                match v.val with
                | 128 => {30,51,72}
                | _ => ∅
              else
                match v.val with
                | 129 => {31,52,73}
                | 130 => {32,53,74}
                | _ => ∅
          else
            if v.val < 133 then
              match v.val with
              | 131 => {33,54,75}
              | 132 => {34,55,76}
              | _ => ∅
            else
              if v.val < 134 then
                match v.val with
                | 133 => {49,56,63}
                | _ => ∅
              else
                match v.val with
                | 134 => {50,57,64}
                | 135 => {51,58,65}
                | _ => ∅
        else
          if v.val < 141 then
            if v.val < 138 then
              match v.val with
              | 136 => {52,59,66}
              | 137 => {53,60,67}
              | _ => ∅
            else
              if v.val < 139 then
                match v.val with
                | 138 => {54,61,68}
                | _ => ∅
              else
                match v.val with
                | 139 => {55,62,69}
                | 140 => {56,70,77}
                | _ => ∅
          else
            if v.val < 144 then
              if v.val < 142 then
                match v.val with
                | 141 => {57,71,78}
                | _ => ∅
              else
                match v.val with
                | 142 => {58,72,79}
                | 143 => {59,73,80}
                | _ => ∅
            else
              if v.val < 145 then
                match v.val with
                | 144 => {60,74,81}
                | _ => ∅
              else
                match v.val with
                | 145 => {61,75,82}
                | 146 => {62,76,83}
                | _ => ∅
      else
        if v.val < 157 then
          if v.val < 152 then
            if v.val < 149 then
              match v.val with
              | 147 => {28,35,77}
              | 148 => {29,36,78}
              | _ => ∅
            else
              if v.val < 150 then
                match v.val with
                | 149 => {30,37,79}
                | _ => ∅
              else
                match v.val with
                | 150 => {31,38,80}
                | 151 => {32,39,81}
                | _ => ∅
          else
            if v.val < 154 then
              match v.val with
              | 152 => {33,40,82}
              | 153 => {34,41,83}
              | _ => ∅
            else
              if v.val < 155 then
                match v.val with
                | 154 => {14,35,70}
                | _ => ∅
              else
                match v.val with
                | 155 => {15,36,71}
                | 156 => {16,37,72}
                | _ => ∅
        else
          if v.val < 162 then
            if v.val < 159 then
              match v.val with
              | 157 => {17,38,73}
              | 158 => {18,39,74}
              | _ => ∅
            else
              if v.val < 160 then
                match v.val with
                | 159 => {19,40,75}
                | _ => ∅
              else
                match v.val with
                | 160 => {20,41,76}
                | 161 => {14,63,77}
                | _ => ∅
          else
            if v.val < 165 then
              if v.val < 163 then
                match v.val with
                | 162 => {15,64,78}
                | _ => ∅
              else
                match v.val with
                | 163 => {16,65,79}
                | 164 => {17,66,80}
                | _ => ∅
            else
              if v.val < 166 then
                match v.val with
                | 165 => {18,67,81}
                | _ => ∅
              else
                match v.val with
                | 166 => {19,68,82}
                | 167 => {20,69,83}
                | _ => ∅

theorem ZBfast_eq : ZBfast = ZB := by

  funext v

  have h : ∀ v, ZBfast v = ZB v := by decide

  exact h v

def rowXB (c : C) : Finset V :=

  if c.val < 42 then
    if c.val < 21 then
      if c.val < 10 then
        if c.val < 5 then
          if c.val < 2 then
            match c.val with
            | 0 => {0,7,14,84,85,87}
            | 1 => {1,8,15,85,86,88}
            | _ => ∅
          else
            if c.val < 3 then
              match c.val with
              | 2 => {2,9,16,86,87,89}
              | _ => ∅
            else
              match c.val with
              | 3 => {3,10,17,87,88,90}
              | 4 => {4,11,18,84,88,89}
              | _ => ∅
        else
          if c.val < 7 then
            match c.val with
            | 5 => {5,12,19,85,89,90}
            | 6 => {6,13,20,84,86,90}
            | _ => ∅
          else
            if c.val < 8 then
              match c.val with
              | 7 => {0,21,28,91,92,94}
              | _ => ∅
            else
              match c.val with
              | 8 => {1,22,29,92,93,95}
              | 9 => {2,23,30,93,94,96}
              | _ => ∅
      else
        if c.val < 15 then
          if c.val < 12 then
            match c.val with
            | 10 => {3,24,31,94,95,97}
            | 11 => {4,25,32,91,95,96}
            | _ => ∅
          else
            if c.val < 13 then
              match c.val with
              | 12 => {5,26,33,92,96,97}
              | _ => ∅
            else
              match c.val with
              | 13 => {6,27,34,91,93,97}
              | 14 => {7,21,35,98,99,101}
              | _ => ∅
        else
          if c.val < 18 then
            if c.val < 16 then
              match c.val with
              | 15 => {8,22,36,99,100,102}
              | _ => ∅
            else
              match c.val with
              | 16 => {9,23,37,100,101,103}
              | 17 => {10,24,38,101,102,104}
              | _ => ∅
          else
            if c.val < 19 then
              match c.val with
              | 18 => {11,25,39,98,102,103}
              | _ => ∅
            else
              match c.val with
              | 19 => {12,26,40,99,103,104}
              | 20 => {13,27,41,98,100,104}
              | _ => ∅
    else
      if c.val < 31 then
        if c.val < 26 then
          if c.val < 23 then
            match c.val with
            | 21 => {0,42,49,105,106,108}
            | 22 => {1,43,50,106,107,109}
            | _ => ∅
          else
            if c.val < 24 then
              match c.val with
              | 23 => {2,44,51,107,108,110}
              | _ => ∅
            else
              match c.val with
              | 24 => {3,45,52,108,109,111}
              | 25 => {4,46,53,105,109,110}
              | _ => ∅
        else
          if c.val < 28 then
            match c.val with
            | 26 => {5,47,54,106,110,111}
            | 27 => {6,48,55,105,107,111}
            | _ => ∅
          else
            if c.val < 29 then
              match c.val with
              | 28 => {7,42,56,112,113,115}
              | _ => ∅
            else
              match c.val with
              | 29 => {8,43,57,113,114,116}
              | 30 => {9,44,58,114,115,117}
              | _ => ∅
      else
        if c.val < 36 then
          if c.val < 33 then
            match c.val with
            | 31 => {10,45,59,115,116,118}
            | 32 => {11,46,60,112,116,117}
            | _ => ∅
          else
            if c.val < 34 then
              match c.val with
              | 33 => {12,47,61,113,117,118}
              | _ => ∅
            else
              match c.val with
              | 34 => {13,48,62,112,114,118}
              | 35 => {21,42,63,119,120,122}
              | _ => ∅
        else
          if c.val < 39 then
            if c.val < 37 then
              match c.val with
              | 36 => {22,43,64,120,121,123}
              | _ => ∅
            else
              match c.val with
              | 37 => {23,44,65,121,122,124}
              | 38 => {24,45,66,122,123,125}
              | _ => ∅
          else
            if c.val < 40 then
              match c.val with
              | 39 => {25,46,67,119,123,124}
              | _ => ∅
            else
              match c.val with
              | 40 => {26,47,68,120,124,125}
              | 41 => {27,48,69,119,121,125}
              | _ => ∅
  else
    if c.val < 63 then
      if c.val < 52 then
        if c.val < 47 then
          if c.val < 44 then
            match c.val with
            | 42 => {28,49,70,126,127,129}
            | 43 => {29,50,71,127,128,130}
            | _ => ∅
          else
            if c.val < 45 then
              match c.val with
              | 44 => {30,51,72,128,129,131}
              | _ => ∅
            else
              match c.val with
              | 45 => {31,52,73,129,130,132}
              | 46 => {32,53,74,126,130,131}
              | _ => ∅
        else
          if c.val < 49 then
            match c.val with
            | 47 => {33,54,75,127,131,132}
            | 48 => {34,55,76,126,128,132}
            | _ => ∅
          else
            if c.val < 50 then
              match c.val with
              | 49 => {49,56,63,133,134,136}
              | _ => ∅
            else
              match c.val with
              | 50 => {50,57,64,134,135,137}
              | 51 => {51,58,65,135,136,138}
              | _ => ∅
      else
        if c.val < 57 then
          if c.val < 54 then
            match c.val with
            | 52 => {52,59,66,136,137,139}
            | 53 => {53,60,67,133,137,138}
            | _ => ∅
          else
            if c.val < 55 then
              match c.val with
              | 54 => {54,61,68,134,138,139}
              | _ => ∅
            else
              match c.val with
              | 55 => {55,62,69,133,135,139}
              | 56 => {56,70,77,140,141,143}
              | _ => ∅
        else
          if c.val < 60 then
            if c.val < 58 then
              match c.val with
              | 57 => {57,71,78,141,142,144}
              | _ => ∅
            else
              match c.val with
              | 58 => {58,72,79,142,143,145}
              | 59 => {59,73,80,143,144,146}
              | _ => ∅
          else
            if c.val < 61 then
              match c.val with
              | 60 => {60,74,81,140,144,145}
              | _ => ∅
            else
              match c.val with
              | 61 => {61,75,82,141,145,146}
              | 62 => {62,76,83,140,142,146}
              | _ => ∅
    else
      if c.val < 73 then
        if c.val < 68 then
          if c.val < 65 then
            match c.val with
            | 63 => {28,35,77,147,148,150}
            | 64 => {29,36,78,148,149,151}
            | _ => ∅
          else
            if c.val < 66 then
              match c.val with
              | 65 => {30,37,79,149,150,152}
              | _ => ∅
            else
              match c.val with
              | 66 => {31,38,80,150,151,153}
              | 67 => {32,39,81,147,151,152}
              | _ => ∅
        else
          if c.val < 70 then
            match c.val with
            | 68 => {33,40,82,148,152,153}
            | 69 => {34,41,83,147,149,153}
            | _ => ∅
          else
            if c.val < 71 then
              match c.val with
              | 70 => {14,35,70,154,155,157}
              | _ => ∅
            else
              match c.val with
              | 71 => {15,36,71,155,156,158}
              | 72 => {16,37,72,156,157,159}
              | _ => ∅
      else
        if c.val < 78 then
          if c.val < 75 then
            match c.val with
            | 73 => {17,38,73,157,158,160}
            | 74 => {18,39,74,154,158,159}
            | _ => ∅
          else
            if c.val < 76 then
              match c.val with
              | 75 => {19,40,75,155,159,160}
              | _ => ∅
            else
              match c.val with
              | 76 => {20,41,76,154,156,160}
              | 77 => {14,63,77,161,162,164}
              | _ => ∅
        else
          if c.val < 81 then
            if c.val < 79 then
              match c.val with
              | 78 => {15,64,78,162,163,165}
              | _ => ∅
            else
              match c.val with
              | 79 => {16,65,79,163,164,166}
              | 80 => {17,66,80,164,165,167}
              | _ => ∅
          else
            if c.val < 82 then
              match c.val with
              | 81 => {18,67,81,161,165,166}
              | _ => ∅
            else
              match c.val with
              | 82 => {19,68,82,162,166,167}
              | 83 => {20,69,83,161,163,167}
              | _ => ∅

theorem rowXB_correct : ∀ c, rowXB c =

    Finset.univ.filter (fun v => c ∈ XBfast v) := by decide

#print axioms rowXB_correct

def rowZB (c : C) : Finset V :=

  if c.val < 42 then
    if c.val < 21 then
      if c.val < 10 then
        if c.val < 5 then
          if c.val < 2 then
            match c.val with
            | 0 => {0,4,6,84,91,105}
            | 1 => {0,1,5,85,92,106}
            | _ => ∅
          else
            if c.val < 3 then
              match c.val with
              | 2 => {1,2,6,86,93,107}
              | _ => ∅
            else
              match c.val with
              | 3 => {0,2,3,87,94,108}
              | 4 => {1,3,4,88,95,109}
              | _ => ∅
        else
          if c.val < 7 then
            match c.val with
            | 5 => {2,4,5,89,96,110}
            | 6 => {3,5,6,90,97,111}
            | _ => ∅
          else
            if c.val < 8 then
              match c.val with
              | 7 => {7,11,13,84,98,112}
              | _ => ∅
            else
              match c.val with
              | 8 => {7,8,12,85,99,113}
              | 9 => {8,9,13,86,100,114}
              | _ => ∅
      else
        if c.val < 15 then
          if c.val < 12 then
            match c.val with
            | 10 => {7,9,10,87,101,115}
            | 11 => {8,10,11,88,102,116}
            | _ => ∅
          else
            if c.val < 13 then
              match c.val with
              | 12 => {9,11,12,89,103,117}
              | _ => ∅
            else
              match c.val with
              | 13 => {10,12,13,90,104,118}
              | 14 => {14,18,20,84,154,161}
              | _ => ∅
        else
          if c.val < 18 then
            if c.val < 16 then
              match c.val with
              | 15 => {14,15,19,85,155,162}
              | _ => ∅
            else
              match c.val with
              | 16 => {15,16,20,86,156,163}
              | 17 => {14,16,17,87,157,164}
              | _ => ∅
          else
            if c.val < 19 then
              match c.val with
              | 18 => {15,17,18,88,158,165}
              | _ => ∅
            else
              match c.val with
              | 19 => {16,18,19,89,159,166}
              | 20 => {17,19,20,90,160,167}
              | _ => ∅
    else
      if c.val < 31 then
        if c.val < 26 then
          if c.val < 23 then
            match c.val with
            | 21 => {21,25,27,91,98,119}
            | 22 => {21,22,26,92,99,120}
            | _ => ∅
          else
            if c.val < 24 then
              match c.val with
              | 23 => {22,23,27,93,100,121}
              | _ => ∅
            else
              match c.val with
              | 24 => {21,23,24,94,101,122}
              | 25 => {22,24,25,95,102,123}
              | _ => ∅
        else
          if c.val < 28 then
            match c.val with
            | 26 => {23,25,26,96,103,124}
            | 27 => {24,26,27,97,104,125}
            | _ => ∅
          else
            if c.val < 29 then
              match c.val with
              | 28 => {28,32,34,91,126,147}
              | _ => ∅
            else
              match c.val with
              | 29 => {28,29,33,92,127,148}
              | 30 => {29,30,34,93,128,149}
              | _ => ∅
      else
        if c.val < 36 then
          if c.val < 33 then
            match c.val with
            | 31 => {28,30,31,94,129,150}
            | 32 => {29,31,32,95,130,151}
            | _ => ∅
          else
            if c.val < 34 then
              match c.val with
              | 33 => {30,32,33,96,131,152}
              | _ => ∅
            else
              match c.val with
              | 34 => {31,33,34,97,132,153}
              | 35 => {35,39,41,98,147,154}
              | _ => ∅
        else
          if c.val < 39 then
            if c.val < 37 then
              match c.val with
              | 36 => {35,36,40,99,148,155}
              | _ => ∅
            else
              match c.val with
              | 37 => {36,37,41,100,149,156}
              | 38 => {35,37,38,101,150,157}
              | _ => ∅
          else
            if c.val < 40 then
              match c.val with
              | 39 => {36,38,39,102,151,158}
              | _ => ∅
            else
              match c.val with
              | 40 => {37,39,40,103,152,159}
              | 41 => {38,40,41,104,153,160}
              | _ => ∅
  else
    if c.val < 63 then
      if c.val < 52 then
        if c.val < 47 then
          if c.val < 44 then
            match c.val with
            | 42 => {42,46,48,105,112,119}
            | 43 => {42,43,47,106,113,120}
            | _ => ∅
          else
            if c.val < 45 then
              match c.val with
              | 44 => {43,44,48,107,114,121}
              | _ => ∅
            else
              match c.val with
              | 45 => {42,44,45,108,115,122}
              | 46 => {43,45,46,109,116,123}
              | _ => ∅
        else
          if c.val < 49 then
            match c.val with
            | 47 => {44,46,47,110,117,124}
            | 48 => {45,47,48,111,118,125}
            | _ => ∅
          else
            if c.val < 50 then
              match c.val with
              | 49 => {49,53,55,105,126,133}
              | _ => ∅
            else
              match c.val with
              | 50 => {49,50,54,106,127,134}
              | 51 => {50,51,55,107,128,135}
              | _ => ∅
      else
        if c.val < 57 then
          if c.val < 54 then
            match c.val with
            | 52 => {49,51,52,108,129,136}
            | 53 => {50,52,53,109,130,137}
            | _ => ∅
          else
            if c.val < 55 then
              match c.val with
              | 54 => {51,53,54,110,131,138}
              | _ => ∅
            else
              match c.val with
              | 55 => {52,54,55,111,132,139}
              | 56 => {56,60,62,112,133,140}
              | _ => ∅
        else
          if c.val < 60 then
            if c.val < 58 then
              match c.val with
              | 57 => {56,57,61,113,134,141}
              | _ => ∅
            else
              match c.val with
              | 58 => {57,58,62,114,135,142}
              | 59 => {56,58,59,115,136,143}
              | _ => ∅
          else
            if c.val < 61 then
              match c.val with
              | 60 => {57,59,60,116,137,144}
              | _ => ∅
            else
              match c.val with
              | 61 => {58,60,61,117,138,145}
              | 62 => {59,61,62,118,139,146}
              | _ => ∅
    else
      if c.val < 73 then
        if c.val < 68 then
          if c.val < 65 then
            match c.val with
            | 63 => {63,67,69,119,133,161}
            | 64 => {63,64,68,120,134,162}
            | _ => ∅
          else
            if c.val < 66 then
              match c.val with
              | 65 => {64,65,69,121,135,163}
              | _ => ∅
            else
              match c.val with
              | 66 => {63,65,66,122,136,164}
              | 67 => {64,66,67,123,137,165}
              | _ => ∅
        else
          if c.val < 70 then
            match c.val with
            | 68 => {65,67,68,124,138,166}
            | 69 => {66,68,69,125,139,167}
            | _ => ∅
          else
            if c.val < 71 then
              match c.val with
              | 70 => {70,74,76,126,140,154}
              | _ => ∅
            else
              match c.val with
              | 71 => {70,71,75,127,141,155}
              | 72 => {71,72,76,128,142,156}
              | _ => ∅
      else
        if c.val < 78 then
          if c.val < 75 then
            match c.val with
            | 73 => {70,72,73,129,143,157}
            | 74 => {71,73,74,130,144,158}
            | _ => ∅
          else
            if c.val < 76 then
              match c.val with
              | 75 => {72,74,75,131,145,159}
              | _ => ∅
            else
              match c.val with
              | 76 => {73,75,76,132,146,160}
              | 77 => {77,81,83,140,147,161}
              | _ => ∅
        else
          if c.val < 81 then
            if c.val < 79 then
              match c.val with
              | 78 => {77,78,82,141,148,162}
              | _ => ∅
            else
              match c.val with
              | 79 => {78,79,83,142,149,163}
              | 80 => {77,79,80,143,150,164}
              | _ => ∅
          else
            if c.val < 82 then
              match c.val with
              | 81 => {78,80,81,144,151,165}
              | _ => ∅
            else
              match c.val with
              | 82 => {79,81,82,145,152,166}
              | 83 => {80,82,83,146,153,167}
              | _ => ∅

theorem rowZB_correct : ∀ c, rowZB c =

    Finset.univ.filter (fun v => c ∈ ZBfast v) := by decide

#print axioms rowZB_correct

theorem css_B : ∀ c d, ((rowXB c ∩ rowZB d).card % 2) = 0 := by decide

#print axioms css_B

theorem same_full_gram : ∀ c d,

    (rowXA c ∩ rowXA d).card = (rowXB c ∩ rowXB d).card := by decide

#print axioms same_full_gram

end SmallQuantum
