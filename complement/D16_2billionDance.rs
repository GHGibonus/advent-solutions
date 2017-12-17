//! NOTE: please remove the trailing newline before feeding input
use std::ops::{Index,IndexMut};
use std::io;
use std::io::prelude::*;
use std::fmt;
use std::str::FromStr;

struct Dancers([u8;16]);

#[derive(Clone,Copy,Debug)]
struct Dancer(usize);

#[derive(Clone,Copy,Debug)]
enum Instruction {
    Spin(u8),
    Exchange(u8,u8),
    Partner(Dancer,Dancer),
}

const ROW : [u8;16] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];

impl Dancer {
    pub fn new(val: u8) -> Dancer {
        assert!(val >= b'a' && val <= b'p');
        Dancer((val - b'a') as usize)
    }
}

impl Instruction {
    pub fn parse_from(mut text_instr: Vec<u8>) -> Instruction {
        match text_instr.remove(0) {
            b's' => {
                let str_instr = String::from_utf8_lossy(&text_instr);
                let offset = u8::from_str(str_instr.as_ref()).unwrap();
                Instruction::Spin(offset)
            },
            b'x' => {
                let (l_pos, r_pos) = if text_instr.get(1) == Some(&b'/') {
                    let l_pos = String::from_utf8_lossy(&text_instr[..1]);
                    let r_pos = String::from_utf8_lossy(&text_instr[2..]);
                    (u8::from_str(l_pos.as_ref()).unwrap()
                    ,u8::from_str(r_pos.as_ref()).unwrap()
                    )
                } else {
                    let l_pos = String::from_utf8_lossy(&text_instr[..2]);
                    let r_pos = String::from_utf8_lossy(&text_instr[3..]);
                    (u8::from_str(l_pos.as_ref()).unwrap()
                    ,u8::from_str(r_pos.as_ref()).unwrap()
                    )
                };
                Instruction::Exchange(l_pos, r_pos)
            },
            b'p' => {
                let l_dancer = text_instr.remove(0);
                let r_dancer = text_instr.pop().unwrap();
                Instruction::Partner(
                    Dancer::new(l_dancer),
                    Dancer::new(r_dancer)
                )
            },
            _ => panic!("Invalid instruction"),
        }
    }
}

impl Dancers {
    pub fn new() -> Dancers { Dancers(ROW) }

    pub fn exec(&mut self, instr: Instruction) {
        match instr {
            Instruction::Spin(offset)   => self.spin(offset),
            Instruction::Exchange(x, y) => self.exchange(x,y),
            Instruction::Partner(a, b)  => self.partners(a,b),
        }
    }

    pub fn spin(&mut self, offset: u8) {
        self.0.iter_mut().for_each(|x| *x = (*x + offset) % 16);
    }

    pub fn exchange(&mut self, x:u8, y:u8) {
        self.0.iter_mut().for_each(|pos|
            if      *pos == x { *pos = y }
            else if *pos == y { *pos = x }
        );
    }

    pub fn partners(&mut self, a:Dancer, b:Dancer) {
        let old_a_pos = self[a];
        self[a] = self[b];
        self[b] = old_a_pos;
    }

    pub fn exec_coregraphy(&mut self, moves: &[Instruction]) {
        moves.iter().for_each(|&instr| self.exec(instr));
    }
}

impl fmt::Display for Dancers {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let mut alphabet_order : [u8;16] = [0;16];
        self.0.iter().enumerate().for_each(|(i, &new_pos)|
            alphabet_order[new_pos as usize] = i as u8 + b'a'
        );
        write!(f, "{}", String::from_utf8_lossy(&alphabet_order))
    }
}

impl Index<Dancer> for Dancers {
    type Output = u8;
    fn index(&self, dancer:Dancer) -> &u8 { &self.0[dancer.0] }
}
impl IndexMut<Dancer> for Dancers {
    fn index_mut(&mut self, dancer:Dancer) -> &mut u8 {&mut self.0[dancer.0]}
}

fn split_into_instr(input: Vec<u8>) -> Vec<Vec<u8>> {
    let mut acc = Vec::new();
    let mut iter_input = input.into_iter();
    loop {
        let cur_instr : Vec<u8>
            = iter_input
                .by_ref()
                .take_while(|c| *c != b',')
                .collect();
        if cur_instr.is_empty() { break acc }
        acc.push(cur_instr);
    }
}

fn dance_n(input: &[Instruction], n:usize) -> Dancers {
    let rounds_before_repeat = {
        let mut dancers = Dancers::new();
        let mut i = 0;
        loop {
            dancers.exec_coregraphy(input);
            i += 1;
            if dancers.0 == ROW { break i }
        }
    };
    let offset_from_init = n % rounds_before_repeat;
    let mut dancers = Dancers::new();
    for _ in 0..offset_from_init {
        dancers.exec_coregraphy(input);
    }
    dancers
}

fn main() {
    let mut input : Vec<u8> = Vec::new();
    io::stdin().read_to_end(&mut input).unwrap();
    let coregraphy : Vec<Instruction>
        = split_into_instr(input)
            .into_iter()
            .map(Instruction::parse_from)
            .collect();

    let dancers = dance_n(coregraphy.as_ref(), 1_000_000_000);
    println!("{}", dancers);
}
