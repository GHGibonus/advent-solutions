use std::io::{stdin, Read};

fn eat_garbage(input: &mut Iterator<Item=char>) -> i32 {
    let mut prev_is_escape = false;
    let mut acc = 0;
    loop {
        match input.next() {
            None => return acc,
            Some('>') if !prev_is_escape => return acc,
            Some('!') => prev_is_escape = !prev_is_escape,
            Some(_) => {
                acc += !prev_is_escape as i32;
                prev_is_escape = false
            },
        }
    }
}

fn eat_block(input: &mut Iterator<Item=char>) -> i32 {
    let mut acc = 0;
    loop {
        match input.next() {
            None => return acc,
            Some('{') => acc += eat_block(input),
            Some('<') => acc += eat_garbage(input),
            Some('}') => return acc,
            Some(',') => {},
            Some(_)   => unreachable!(),
        }
    }
}

fn main() {
    let mut buffer = String::new();
    stdin().read_to_string(&mut buffer);
    println!("{}", eat_block(&mut buffer.chars()));
}
