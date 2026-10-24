import SmallQuantumData
set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace SmallQuantum

def XAfast (v : V) : Finset C :=
  if v.val < 84 then
    if v.val < 42 then
      if v.val < 21 then
        if v.val < 10 then
          if v.val < 5 then
            if v.val < 2 then
              match v.val with
              | 0 => {0,7,14}
              | 1 => {1,8,15}
              | _ => ∅
            else
              if v.val < 3 then
                match v.val with
                | 2 => {2,9,16}
                | _ => ∅
              else
                match v.val with
                | 3 => {3,10,17}
                | 4 => {4,11,18}
                | _ => ∅
          else
            if v.val < 7 then
              match v.val with
              | 5 => {5,12,19}
              | 6 => {6,13,20}
              | _ => ∅
            else
              if v.val < 8 then
                match v.val with
                | 7 => {0,21,28}
                | _ => ∅
              else
                match v.val with
                | 8 => {1,22,29}
                | 9 => {2,23,30}
                | _ => ∅
        else
          if v.val < 15 then
            if v.val < 12 then
              match v.val with
              | 10 => {3,24,31}
              | 11 => {4,25,32}
              | _ => ∅
            else
              if v.val < 13 then
                match v.val with
                | 12 => {5,26,33}
                | _ => ∅
              else
                match v.val with
                | 13 => {6,27,34}
                | 14 => {0,70,77}
                | _ => ∅
          else
            if v.val < 18 then
              if v.val < 16 then
                match v.val with
                | 15 => {1,71,78}
                | _ => ∅
              else
                match v.val with
                | 16 => {2,72,79}
                | 17 => {3,73,80}
                | _ => ∅
            else
              if v.val < 19 then
                match v.val with
                | 18 => {4,74,81}
                | _ => ∅
              else
                match v.val with
                | 19 => {5,75,82}
                | 20 => {6,76,83}
                | _ => ∅
      else
        if v.val < 31 then
          if v.val < 26 then
            if v.val < 23 then
              match v.val with
              | 21 => {7,21,35}
              | 22 => {8,22,36}
              | _ => ∅
            else
              if v.val < 24 then
                match v.val with
                | 23 => {9,23,37}
                | _ => ∅
              else
                match v.val with
                | 24 => {10,24,38}
                | 25 => {11,25,39}
                | _ => ∅
          else
            if v.val < 28 then
              match v.val with
              | 26 => {12,26,40}
              | 27 => {13,27,41}
              | _ => ∅
            else
              if v.val < 29 then
                match v.val with
                | 28 => {7,42,63}
                | _ => ∅
              else
                match v.val with
                | 29 => {8,43,64}
                | 30 => {9,44,65}
                | _ => ∅
        else
          if v.val < 36 then
            if v.val < 33 then
              match v.val with
              | 31 => {10,45,66}
              | 32 => {11,46,67}
              | _ => ∅
            else
              if v.val < 34 then
                match v.val with
                | 33 => {12,47,68}
                | _ => ∅
              else
                match v.val with
                | 34 => {13,48,69}
                | 35 => {14,28,35}
                | _ => ∅
          else
            if v.val < 39 then
              if v.val < 37 then
                match v.val with
                | 36 => {15,29,36}
                | _ => ∅
              else
                match v.val with
                | 37 => {16,30,37}
                | 38 => {17,31,38}
                | _ => ∅
            else
              if v.val < 40 then
                match v.val with
                | 39 => {18,32,39}
                | _ => ∅
              else
                match v.val with
                | 40 => {19,33,40}
                | 41 => {20,34,41}
                | _ => ∅
    else
      if v.val < 63 then
        if v.val < 52 then
          if v.val < 47 then
            if v.val < 44 then
              match v.val with
              | 42 => {14,63,70}
              | 43 => {15,64,71}
              | _ => ∅
            else
              if v.val < 45 then
                match v.val with
                | 44 => {16,65,72}
                | _ => ∅
              else
                match v.val with
                | 45 => {17,66,73}
                | 46 => {18,67,74}
                | _ => ∅
          else
            if v.val < 49 then
              match v.val with
              | 47 => {19,68,75}
              | 48 => {20,69,76}
              | _ => ∅
            else
              if v.val < 50 then
                match v.val with
                | 49 => {21,42,49}
                | _ => ∅
              else
                match v.val with
                | 50 => {22,43,50}
                | 51 => {23,44,51}
                | _ => ∅
        else
          if v.val < 57 then
            if v.val < 54 then
              match v.val with
              | 52 => {24,45,52}
              | 53 => {25,46,53}
              | _ => ∅
            else
              if v.val < 55 then
                match v.val with
                | 54 => {26,47,54}
                | _ => ∅
              else
                match v.val with
                | 55 => {27,48,55}
                | 56 => {28,49,56}
                | _ => ∅
          else
            if v.val < 60 then
              if v.val < 58 then
                match v.val with
                | 57 => {29,50,57}
                | _ => ∅
              else
                match v.val with
                | 58 => {30,51,58}
                | 59 => {31,52,59}
                | _ => ∅
            else
              if v.val < 61 then
                match v.val with
                | 60 => {32,53,60}
                | _ => ∅
              else
                match v.val with
                | 61 => {33,54,61}
                | 62 => {34,55,62}
                | _ => ∅
      else
        if v.val < 73 then
          if v.val < 68 then
            if v.val < 65 then
              match v.val with
              | 63 => {35,49,77}
              | 64 => {36,50,78}
              | _ => ∅
            else
              if v.val < 66 then
                match v.val with
                | 65 => {37,51,79}
                | _ => ∅
              else
                match v.val with
                | 66 => {38,52,80}
                | 67 => {39,53,81}
                | _ => ∅
          else
            if v.val < 70 then
              match v.val with
              | 68 => {40,54,82}
              | 69 => {41,55,83}
              | _ => ∅
            else
              if v.val < 71 then
                match v.val with
                | 70 => {42,56,70}
                | _ => ∅
              else
                match v.val with
                | 71 => {43,57,71}
                | 72 => {44,58,72}
                | _ => ∅
        else
          if v.val < 78 then
            if v.val < 75 then
              match v.val with
              | 73 => {45,59,73}
              | 74 => {46,60,74}
              | _ => ∅
            else
              if v.val < 76 then
                match v.val with
                | 75 => {47,61,75}
                | _ => ∅
              else
                match v.val with
                | 76 => {48,62,76}
                | 77 => {56,63,77}
                | _ => ∅
          else
            if v.val < 81 then
              if v.val < 79 then
                match v.val with
                | 78 => {57,64,78}
                | _ => ∅
              else
                match v.val with
                | 79 => {58,65,79}
                | 80 => {59,66,80}
                | _ => ∅
            else
              if v.val < 82 then
                match v.val with
                | 81 => {60,67,81}
                | _ => ∅
              else
                match v.val with
                | 82 => {61,68,82}
                | 83 => {62,69,83}
                | _ => ∅
  else
    if v.val < 126 then
      if v.val < 105 then
        if v.val < 94 then
          if v.val < 89 then
            if v.val < 86 then
              match v.val with
              | 84 => {0,4,6}
              | 85 => {0,1,5}
              | _ => ∅
            else
              if v.val < 87 then
                match v.val with
                | 86 => {1,2,6}
                | _ => ∅
              else
                match v.val with
                | 87 => {0,2,3}
                | 88 => {1,3,4}
                | _ => ∅
          else
            if v.val < 91 then
              match v.val with
              | 89 => {2,4,5}
              | 90 => {3,5,6}
              | _ => ∅
            else
              if v.val < 92 then
                match v.val with
                | 91 => {7,11,13}
                | _ => ∅
              else
                match v.val with
                | 92 => {7,8,12}
                | 93 => {8,9,13}
                | _ => ∅
        else
          if v.val < 99 then
            if v.val < 96 then
              match v.val with
              | 94 => {7,9,10}
              | 95 => {8,10,11}
              | _ => ∅
            else
              if v.val < 97 then
                match v.val with
                | 96 => {9,11,12}
                | _ => ∅
              else
                match v.val with
                | 97 => {10,12,13}
                | 98 => {14,18,20}
                | _ => ∅
          else
            if v.val < 102 then
              if v.val < 100 then
                match v.val with
                | 99 => {14,15,19}
                | _ => ∅
              else
                match v.val with
                | 100 => {15,16,20}
                | 101 => {14,16,17}
                | _ => ∅
            else
              if v.val < 103 then
                match v.val with
                | 102 => {15,17,18}
                | _ => ∅
              else
                match v.val with
                | 103 => {16,18,19}
                | 104 => {17,19,20}
                | _ => ∅
      else
        if v.val < 115 then
          if v.val < 110 then
            if v.val < 107 then
              match v.val with
              | 105 => {21,25,27}
              | 106 => {21,22,26}
              | _ => ∅
            else
              if v.val < 108 then
                match v.val with
                | 107 => {22,23,27}
                | _ => ∅
              else
                match v.val with
                | 108 => {21,23,24}
                | 109 => {22,24,25}
                | _ => ∅
          else
            if v.val < 112 then
              match v.val with
              | 110 => {23,25,26}
              | 111 => {24,26,27}
              | _ => ∅
            else
              if v.val < 113 then
                match v.val with
                | 112 => {28,32,34}
                | _ => ∅
              else
                match v.val with
                | 113 => {28,29,33}
                | 114 => {29,30,34}
                | _ => ∅
        else
          if v.val < 120 then
            if v.val < 117 then
              match v.val with
              | 115 => {28,30,31}
              | 116 => {29,31,32}
              | _ => ∅
            else
              if v.val < 118 then
                match v.val with
                | 117 => {30,32,33}
                | _ => ∅
              else
                match v.val with
                | 118 => {31,33,34}
                | 119 => {35,39,41}
                | _ => ∅
          else
            if v.val < 123 then
              if v.val < 121 then
                match v.val with
                | 120 => {35,36,40}
                | _ => ∅
              else
                match v.val with
                | 121 => {36,37,41}
                | 122 => {35,37,38}
                | _ => ∅
            else
              if v.val < 124 then
                match v.val with
                | 123 => {36,38,39}
                | _ => ∅
              else
                match v.val with
                | 124 => {37,39,40}
                | 125 => {38,40,41}
                | _ => ∅
    else
      if v.val < 147 then
        if v.val < 136 then
          if v.val < 131 then
            if v.val < 128 then
              match v.val with
              | 126 => {42,46,48}
              | 127 => {42,43,47}
              | _ => ∅
            else
              if v.val < 129 then
                match v.val with
                | 128 => {43,44,48}
                | _ => ∅
              else
                match v.val with
                | 129 => {42,44,45}
                | 130 => {43,45,46}
                | _ => ∅
          else
            if v.val < 133 then
              match v.val with
              | 131 => {44,46,47}
              | 132 => {45,47,48}
              | _ => ∅
            else
              if v.val < 134 then
                match v.val with
                | 133 => {49,53,55}
                | _ => ∅
              else
                match v.val with
                | 134 => {49,50,54}
                | 135 => {50,51,55}
                | _ => ∅
        else
          if v.val < 141 then
            if v.val < 138 then
              match v.val with
              | 136 => {49,51,52}
              | 137 => {50,52,53}
              | _ => ∅
            else
              if v.val < 139 then
                match v.val with
                | 138 => {51,53,54}
                | _ => ∅
              else
                match v.val with
                | 139 => {52,54,55}
                | 140 => {56,60,62}
                | _ => ∅
          else
            if v.val < 144 then
              if v.val < 142 then
                match v.val with
                | 141 => {56,57,61}
                | _ => ∅
              else
                match v.val with
                | 142 => {57,58,62}
                | 143 => {56,58,59}
                | _ => ∅
            else
              if v.val < 145 then
                match v.val with
                | 144 => {57,59,60}
                | _ => ∅
              else
                match v.val with
                | 145 => {58,60,61}
                | 146 => {59,61,62}
                | _ => ∅
      else
        if v.val < 157 then
          if v.val < 152 then
            if v.val < 149 then
              match v.val with
              | 147 => {63,67,69}
              | 148 => {63,64,68}
              | _ => ∅
            else
              if v.val < 150 then
                match v.val with
                | 149 => {64,65,69}
                | _ => ∅
              else
                match v.val with
                | 150 => {63,65,66}
                | 151 => {64,66,67}
                | _ => ∅
          else
            if v.val < 154 then
              match v.val with
              | 152 => {65,67,68}
              | 153 => {66,68,69}
              | _ => ∅
            else
              if v.val < 155 then
                match v.val with
                | 154 => {70,74,76}
                | _ => ∅
              else
                match v.val with
                | 155 => {70,71,75}
                | 156 => {71,72,76}
                | _ => ∅
        else
          if v.val < 162 then
            if v.val < 159 then
              match v.val with
              | 157 => {70,72,73}
              | 158 => {71,73,74}
              | _ => ∅
            else
              if v.val < 160 then
                match v.val with
                | 159 => {72,74,75}
                | _ => ∅
              else
                match v.val with
                | 160 => {73,75,76}
                | 161 => {77,81,83}
                | _ => ∅
          else
            if v.val < 165 then
              if v.val < 163 then
                match v.val with
                | 162 => {77,78,82}
                | _ => ∅
              else
                match v.val with
                | 163 => {78,79,83}
                | 164 => {77,79,80}
                | _ => ∅
            else
              if v.val < 166 then
                match v.val with
                | 165 => {78,80,81}
                | _ => ∅
              else
                match v.val with
                | 166 => {79,81,82}
                | 167 => {80,82,83}
                | _ => ∅

theorem XAfast_eq : XAfast = XA := by
  funext v
  have h : ∀ v, XAfast v = XA v := by decide
  exact h v

def XBfast (v : V) : Finset C :=
  if v.val < 84 then
    if v.val < 42 then
      if v.val < 21 then
        if v.val < 10 then
          if v.val < 5 then
            if v.val < 2 then
              match v.val with
              | 0 => {0,7,21}
              | 1 => {1,8,22}
              | _ => ∅
            else
              if v.val < 3 then
                match v.val with
                | 2 => {2,9,23}
                | _ => ∅
              else
                match v.val with
                | 3 => {3,10,24}
                | 4 => {4,11,25}
                | _ => ∅
          else
            if v.val < 7 then
              match v.val with
              | 5 => {5,12,26}
              | 6 => {6,13,27}
              | _ => ∅
            else
              if v.val < 8 then
                match v.val with
                | 7 => {0,14,28}
                | _ => ∅
              else
                match v.val with
                | 8 => {1,15,29}
                | 9 => {2,16,30}
                | _ => ∅
        else
          if v.val < 15 then
            if v.val < 12 then
              match v.val with
              | 10 => {3,17,31}
              | 11 => {4,18,32}
              | _ => ∅
            else
              if v.val < 13 then
                match v.val with
                | 12 => {5,19,33}
                | _ => ∅
              else
                match v.val with
                | 13 => {6,20,34}
                | 14 => {0,70,77}
                | _ => ∅
          else
            if v.val < 18 then
              if v.val < 16 then
                match v.val with
                | 15 => {1,71,78}
                | _ => ∅
              else
                match v.val with
                | 16 => {2,72,79}
                | 17 => {3,73,80}
                | _ => ∅
            else
              if v.val < 19 then
                match v.val with
                | 18 => {4,74,81}
                | _ => ∅
              else
                match v.val with
                | 19 => {5,75,82}
                | 20 => {6,76,83}
                | _ => ∅
      else
        if v.val < 31 then
          if v.val < 26 then
            if v.val < 23 then
              match v.val with
              | 21 => {7,14,35}
              | 22 => {8,15,36}
              | _ => ∅
            else
              if v.val < 24 then
                match v.val with
                | 23 => {9,16,37}
                | _ => ∅
              else
                match v.val with
                | 24 => {10,17,38}
                | 25 => {11,18,39}
                | _ => ∅
          else
            if v.val < 28 then
              match v.val with
              | 26 => {12,19,40}
              | 27 => {13,20,41}
              | _ => ∅
            else
              if v.val < 29 then
                match v.val with
                | 28 => {7,42,63}
                | _ => ∅
              else
                match v.val with
                | 29 => {8,43,64}
                | 30 => {9,44,65}
                | _ => ∅
        else
          if v.val < 36 then
            if v.val < 33 then
              match v.val with
              | 31 => {10,45,66}
              | 32 => {11,46,67}
              | _ => ∅
            else
              if v.val < 34 then
                match v.val with
                | 33 => {12,47,68}
                | _ => ∅
              else
                match v.val with
                | 34 => {13,48,69}
                | 35 => {14,63,70}
                | _ => ∅
          else
            if v.val < 39 then
              if v.val < 37 then
                match v.val with
                | 36 => {15,64,71}
                | _ => ∅
              else
                match v.val with
                | 37 => {16,65,72}
                | 38 => {17,66,73}
                | _ => ∅
            else
              if v.val < 40 then
                match v.val with
                | 39 => {18,67,74}
                | _ => ∅
              else
                match v.val with
                | 40 => {19,68,75}
                | 41 => {20,69,76}
                | _ => ∅
    else
      if v.val < 63 then
        if v.val < 52 then
          if v.val < 47 then
            if v.val < 44 then
              match v.val with
              | 42 => {21,28,35}
              | 43 => {22,29,36}
              | _ => ∅
            else
              if v.val < 45 then
                match v.val with
                | 44 => {23,30,37}
                | _ => ∅
              else
                match v.val with
                | 45 => {24,31,38}
                | 46 => {25,32,39}
                | _ => ∅
          else
            if v.val < 49 then
              match v.val with
              | 47 => {26,33,40}
              | 48 => {27,34,41}
              | _ => ∅
            else
              if v.val < 50 then
                match v.val with
                | 49 => {21,42,49}
                | _ => ∅
              else
                match v.val with
                | 50 => {22,43,50}
                | 51 => {23,44,51}
                | _ => ∅
        else
          if v.val < 57 then
            if v.val < 54 then
              match v.val with
              | 52 => {24,45,52}
              | 53 => {25,46,53}
              | _ => ∅
            else
              if v.val < 55 then
                match v.val with
                | 54 => {26,47,54}
                | _ => ∅
              else
                match v.val with
                | 55 => {27,48,55}
                | 56 => {28,49,56}
                | _ => ∅
          else
            if v.val < 60 then
              if v.val < 58 then
                match v.val with
                | 57 => {29,50,57}
                | _ => ∅
              else
                match v.val with
                | 58 => {30,51,58}
                | 59 => {31,52,59}
                | _ => ∅
            else
              if v.val < 61 then
                match v.val with
                | 60 => {32,53,60}
                | _ => ∅
              else
                match v.val with
                | 61 => {33,54,61}
                | 62 => {34,55,62}
                | _ => ∅
      else
        if v.val < 73 then
          if v.val < 68 then
            if v.val < 65 then
              match v.val with
              | 63 => {35,49,77}
              | 64 => {36,50,78}
              | _ => ∅
            else
              if v.val < 66 then
                match v.val with
                | 65 => {37,51,79}
                | _ => ∅
              else
                match v.val with
                | 66 => {38,52,80}
                | 67 => {39,53,81}
                | _ => ∅
          else
            if v.val < 70 then
              match v.val with
              | 68 => {40,54,82}
              | 69 => {41,55,83}
              | _ => ∅
            else
              if v.val < 71 then
                match v.val with
                | 70 => {42,56,70}
                | _ => ∅
              else
                match v.val with
                | 71 => {43,57,71}
                | 72 => {44,58,72}
                | _ => ∅
        else
          if v.val < 78 then
            if v.val < 75 then
              match v.val with
              | 73 => {45,59,73}
              | 74 => {46,60,74}
              | _ => ∅
            else
              if v.val < 76 then
                match v.val with
                | 75 => {47,61,75}
                | _ => ∅
              else
                match v.val with
                | 76 => {48,62,76}
                | 77 => {56,63,77}
                | _ => ∅
          else
            if v.val < 81 then
              if v.val < 79 then
                match v.val with
                | 78 => {57,64,78}
                | _ => ∅
              else
                match v.val with
                | 79 => {58,65,79}
                | 80 => {59,66,80}
                | _ => ∅
            else
              if v.val < 82 then
                match v.val with
                | 81 => {60,67,81}
                | _ => ∅
              else
                match v.val with
                | 82 => {61,68,82}
                | 83 => {62,69,83}
                | _ => ∅
  else
    if v.val < 126 then
      if v.val < 105 then
        if v.val < 94 then
          if v.val < 89 then
            if v.val < 86 then
              match v.val with
              | 84 => {0,4,6}
              | 85 => {0,1,5}
              | _ => ∅
            else
              if v.val < 87 then
                match v.val with
                | 86 => {1,2,6}
                | _ => ∅
              else
                match v.val with
                | 87 => {0,2,3}
                | 88 => {1,3,4}
                | _ => ∅
          else
            if v.val < 91 then
              match v.val with
              | 89 => {2,4,5}
              | 90 => {3,5,6}
              | _ => ∅
            else
              if v.val < 92 then
                match v.val with
                | 91 => {7,11,13}
                | _ => ∅
              else
                match v.val with
                | 92 => {7,8,12}
                | 93 => {8,9,13}
                | _ => ∅
        else
          if v.val < 99 then
            if v.val < 96 then
              match v.val with
              | 94 => {7,9,10}
              | 95 => {8,10,11}
              | _ => ∅
            else
              if v.val < 97 then
                match v.val with
                | 96 => {9,11,12}
                | _ => ∅
              else
                match v.val with
                | 97 => {10,12,13}
                | 98 => {14,18,20}
                | _ => ∅
          else
            if v.val < 102 then
              if v.val < 100 then
                match v.val with
                | 99 => {14,15,19}
                | _ => ∅
              else
                match v.val with
                | 100 => {15,16,20}
                | 101 => {14,16,17}
                | _ => ∅
            else
              if v.val < 103 then
                match v.val with
                | 102 => {15,17,18}
                | _ => ∅
              else
                match v.val with
                | 103 => {16,18,19}
                | 104 => {17,19,20}
                | _ => ∅
      else
        if v.val < 115 then
          if v.val < 110 then
            if v.val < 107 then
              match v.val with
              | 105 => {21,25,27}
              | 106 => {21,22,26}
              | _ => ∅
            else
              if v.val < 108 then
                match v.val with
                | 107 => {22,23,27}
                | _ => ∅
              else
                match v.val with
                | 108 => {21,23,24}
                | 109 => {22,24,25}
                | _ => ∅
          else
            if v.val < 112 then
              match v.val with
              | 110 => {23,25,26}
              | 111 => {24,26,27}
              | _ => ∅
            else
              if v.val < 113 then
                match v.val with
                | 112 => {28,32,34}
                | _ => ∅
              else
                match v.val with
                | 113 => {28,29,33}
                | 114 => {29,30,34}
                | _ => ∅
        else
          if v.val < 120 then
            if v.val < 117 then
              match v.val with
              | 115 => {28,30,31}
              | 116 => {29,31,32}
              | _ => ∅
            else
              if v.val < 118 then
                match v.val with
                | 117 => {30,32,33}
                | _ => ∅
              else
                match v.val with
                | 118 => {31,33,34}
                | 119 => {35,39,41}
                | _ => ∅
          else
            if v.val < 123 then
              if v.val < 121 then
                match v.val with
                | 120 => {35,36,40}
                | _ => ∅
              else
                match v.val with
                | 121 => {36,37,41}
                | 122 => {35,37,38}
                | _ => ∅
            else
              if v.val < 124 then
                match v.val with
                | 123 => {36,38,39}
                | _ => ∅
              else
                match v.val with
                | 124 => {37,39,40}
                | 125 => {38,40,41}
                | _ => ∅
    else
      if v.val < 147 then
        if v.val < 136 then
          if v.val < 131 then
            if v.val < 128 then
              match v.val with
              | 126 => {42,46,48}
              | 127 => {42,43,47}
              | _ => ∅
            else
              if v.val < 129 then
                match v.val with
                | 128 => {43,44,48}
                | _ => ∅
              else
                match v.val with
                | 129 => {42,44,45}
                | 130 => {43,45,46}
                | _ => ∅
          else
            if v.val < 133 then
              match v.val with
              | 131 => {44,46,47}
              | 132 => {45,47,48}
              | _ => ∅
            else
              if v.val < 134 then
                match v.val with
                | 133 => {49,53,55}
                | _ => ∅
              else
                match v.val with
                | 134 => {49,50,54}
                | 135 => {50,51,55}
                | _ => ∅
        else
          if v.val < 141 then
            if v.val < 138 then
              match v.val with
              | 136 => {49,51,52}
              | 137 => {50,52,53}
              | _ => ∅
            else
              if v.val < 139 then
                match v.val with
                | 138 => {51,53,54}
                | _ => ∅
              else
                match v.val with
                | 139 => {52,54,55}
                | 140 => {56,60,62}
                | _ => ∅
          else
            if v.val < 144 then
              if v.val < 142 then
                match v.val with
                | 141 => {56,57,61}
                | _ => ∅
              else
                match v.val with
                | 142 => {57,58,62}
                | 143 => {56,58,59}
                | _ => ∅
            else
              if v.val < 145 then
                match v.val with
                | 144 => {57,59,60}
                | _ => ∅
              else
                match v.val with
                | 145 => {58,60,61}
                | 146 => {59,61,62}
                | _ => ∅
      else
        if v.val < 157 then
          if v.val < 152 then
            if v.val < 149 then
              match v.val with
              | 147 => {63,67,69}
              | 148 => {63,64,68}
              | _ => ∅
            else
              if v.val < 150 then
                match v.val with
                | 149 => {64,65,69}
                | _ => ∅
              else
                match v.val with
                | 150 => {63,65,66}
                | 151 => {64,66,67}
                | _ => ∅
          else
            if v.val < 154 then
              match v.val with
              | 152 => {65,67,68}
              | 153 => {66,68,69}
              | _ => ∅
            else
              if v.val < 155 then
                match v.val with
                | 154 => {70,74,76}
                | _ => ∅
              else
                match v.val with
                | 155 => {70,71,75}
                | 156 => {71,72,76}
                | _ => ∅
        else
          if v.val < 162 then
            if v.val < 159 then
              match v.val with
              | 157 => {70,72,73}
              | 158 => {71,73,74}
              | _ => ∅
            else
              if v.val < 160 then
                match v.val with
                | 159 => {72,74,75}
                | _ => ∅
              else
                match v.val with
                | 160 => {73,75,76}
                | 161 => {77,81,83}
                | _ => ∅
          else
            if v.val < 165 then
              if v.val < 163 then
                match v.val with
                | 162 => {77,78,82}
                | _ => ∅
              else
                match v.val with
                | 163 => {78,79,83}
                | 164 => {77,79,80}
                | _ => ∅
            else
              if v.val < 166 then
                match v.val with
                | 165 => {78,80,81}
                | _ => ∅
              else
                match v.val with
                | 166 => {79,81,82}
                | 167 => {80,82,83}
                | _ => ∅

theorem XBfast_eq : XBfast = XB := by
  funext v
  have h : ∀ v, XBfast v = XB v := by decide
  exact h v

end SmallQuantum
