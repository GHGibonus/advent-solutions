use std::io;
use std::io::Read;

pub fn main() {
    let num_vec : Vec<i32> =
        io::stdin()
            .bytes()
            .filter_map(|x| {
                let val = match x {Ok(val)=>val, Err(_)=> return None};
                if val>47 && val<58 {
                    Some((val - 48) as i32)
                } else {None}
            })
            .collect();
    let (half1, half2) = num_vec.split_at(num_vec.len() / 2);
    let sum =
        num_vec
            .iter()
            .zip(half2.iter().chain(half1))
            .fold(0, |acc, (&cur,&shifted)| acc + cur * (cur==shifted) as i32);
    println!("{}", sum);
}
