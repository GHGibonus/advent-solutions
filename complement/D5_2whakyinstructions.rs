use std::io::{stdin,BufReader};
use std::io::prelude::*;
// use std::i32::FromStr;
use std::str::FromStr;

fn read_tape() -> Vec<i32> {
    BufReader::new(stdin())
        .lines()
        .filter_map(Result::ok)
        .map( |x| i32::from_str(x.as_ref()) )
        .filter_map(Result::ok)
        .collect()
}

fn exec_tape(mut tape: Vec<i32>) -> i32 {
    let mut cursor : i32 = 0;
    let mut step_count = 0;
    let len = tape.len() as i32;
    loop {
        let cursor_position = cursor as usize;
        let offset = tape[cursor_position];

        let new_cursor = offset + cursor;
        tape[cursor_position] += (offset < 3) as i32 * 2 - 1;
        step_count += 1;
        cursor = new_cursor;
        if cursor < 0 || cursor >= len { return step_count }
    }
}

pub fn main() {
    println!("{}", exec_tape(read_tape()));
}
