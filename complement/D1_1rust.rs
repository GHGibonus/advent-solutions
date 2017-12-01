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
    let first_number = num_vec[0];
    let (_last, sum) =
        num_vec
            .into_iter()
            .rev()
            .fold((first_number, 0), |(last, acc), cur|
                (cur, acc + cur * (cur == last) as i32)
            );
    print!("{}", sum);
}
