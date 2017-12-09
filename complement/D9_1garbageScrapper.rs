use std::io::{stdin, Read};

fn eat_garbage(input: &mut Iterator<Item=char>) {
    let mut prev_is_escape = false;
    loop {
        match input.next() {
            None => return,
            Some('>') if !prev_is_escape => return,
            Some('!') => prev_is_escape = !prev_is_escape,
            Some(_)   => prev_is_escape = false,
        }
    }
}

fn eat_block(depth: i32, input: &mut Iterator<Item=char>) -> i32 {
    let mut acc = 0;
    loop {
        match input.next() {
            None => return acc,
            Some('{') => acc += eat_block(depth + 1, input),
            Some('<') => eat_garbage(input),
            Some('}') => return depth + acc,
            Some(',') => {},
            Some(_)   => unreachable!(),
        }
    }
}

fn main() {
    let mut buffer = String::new();
    stdin().read_to_string(&mut buffer);
    println!("{}", eat_block(0, &mut buffer.chars()));
}
