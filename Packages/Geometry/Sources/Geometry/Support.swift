public func sort<T>(_ a: inout T, _ b: inout T, _ c: inout T, by areInIncreasingOrder: (T, T) -> Bool) {
    if areInIncreasingOrder(b, a) {
        swap(&a, &b)
    }
    if areInIncreasingOrder(c, b) {
        swap(&b, &c)
    }
    if areInIncreasingOrder(b, a) {
        swap(&a, &b)
    }
}
