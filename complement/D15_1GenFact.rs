fn judge(start_a: usize, start_b: usize) -> usize {
    let gen_a = |a| (a * 16807) % 2147483647;
    let gen_b = |b| (b * 48271) % 2147483647;
    let mut a = gen_a(start_a);
    let mut b = gen_b(start_b);
    let mut sum = 0;
    for _ in 0..40_000_000 {
        if (a & 0xffff) == (b & 0xffff) { sum += 1 }
        a = gen_a(a); b = gen_b(b);
    }
    sum
}

fn main() { println!("{}", judge(65, 8921)) }
