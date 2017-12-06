use std::collections::hash_map::DefaultHasher;
use std::hash::{Hash,Hasher};
use std::collections::HashSet;
use std::io::{stdin,BufReader};
use std::io::prelude::*;
use std::str::FromStr;

fn read_banks() -> Vec<i32> {
    BufReader::new(stdin())
        .lines().next().unwrap().unwrap()
        .split_whitespace()
        .flat_map( |x| i32::from_str(x.as_ref()) )
        .collect()
}

fn distribute(how_many: i32, from_bank: usize, mut banks: Vec<i32>)
    -> Vec<i32>
{
    if how_many != 0 {
        let next_bank = (from_bank + 1) % banks.len();
        banks[next_bank] += 1;
        distribute(how_many - 1, next_bank, banks)
    } else {
        banks
    }
}

fn find_highest(banks: &[i32]) -> usize {
    banks
        .iter()
        .enumerate()
        .fold((0,0), |(big_i, big_e), (i, &e)|
            if e > big_e {(i, e)} else {(big_i, big_e)}
        )
        .0
}

fn hash(banks: &[i32]) -> u64 {
    let mut hasher = DefaultHasher::new();
    banks.hash(&mut hasher);
    hasher.finish()
}

fn detect_loop(mut banks: Vec<i32>) -> i32 {
    let mut cur_step = 0;
    let mut states = HashSet::new();
    while states.insert(hash(&banks)) {
        let biggest_bank = find_highest(&banks);
        let bank_size = banks[biggest_bank];
        banks[biggest_bank] = 0;
        banks = distribute(bank_size, biggest_bank, banks);
        cur_step += 1;
    }
    cur_step
}

pub fn main() {
    println!("{}", detect_loop(read_banks()));
}
