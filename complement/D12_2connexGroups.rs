use std::io::stdin;
use std::io::prelude::*;
use std::io::BufReader;
use std::str::FromStr;

type SparseAdjMat = Vec<Vec<u16>>;
type SparseOptAdjMat = Vec<Option<Vec<u16>>>;

fn parse_line(line: String) -> Vec<u16> {
    line.split_whitespace()
        .skip(2)
        .flat_map(u16::from_str)
        .collect()
}

fn read_graph() -> SparseAdjMat {
    BufReader::new(stdin())
        .lines()
        .map(|x| parse_line(x.unwrap().replace(','," ")))
        .collect()
}

fn trim_connected(mat: &mut SparseOptAdjMat) {
    let (first_some, _)
        = mat.iter()
            .enumerate()
            .skip_while(|&(_,val)| val.is_none())
            .next().unwrap();

    let mut explore_queue: Vec<u16> = vec![first_some as u16];
    while let Some(current_node) = explore_queue.pop() {
        if let Some(to_visit) = mat[current_node as usize].take() {
            explore_queue.extend(to_visit);
        }
    }
}

fn count_separated(mat: SparseAdjMat) -> usize {
    let mut opt_mat = mat.into_iter().map(Some).collect();
    let mut i = 0;
    loop {
        i += 1;
        trim_connected(&mut opt_mat);
        if opt_mat.iter().all(Option::is_none) {break i};
    }
}

fn main() {
    let graph = read_graph();
    let sep_count = count_separated(graph);
    println!("{:?}",sep_count);
}
