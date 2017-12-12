use std::io::stdin;
use std::io::prelude::*;
use std::io::BufReader;
use std::str::FromStr;
use std::collections::BTreeSet;

type SparseAdjMat = Vec<Vec<u16>>;

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

fn count_connect(mat: SparseAdjMat) -> usize {
    let mut explore_queue : Vec<u16> = vec![0];
    let mut visited_nodes : BTreeSet<u16> = BTreeSet::new();
    while let Some(current_node) = explore_queue.pop() {
        visited_nodes.insert(current_node);
        explore_queue.extend(
            mat[current_node as usize]
                .iter()
                .filter(|node| !visited_nodes.contains(node))
        );
    }
    visited_nodes.len()
}

fn main() {
    let graph = read_graph();
    println!("{:?}",count_connect(graph));
}
