import time


def fun(p, q):
    n = p * q

    e = 2
    fi = (p - 1) * (q - 1)

    def inv(e, fi):
        k = 1
        t = time.time()
        while True:
            result = (1 + (k * fi)) / float(e)
            if (round(result, 5) % 1) == 0:
                return int(result)
            elif time.time() - t > 1:
                return 0
            else:
                k += 1

    while inv(e, fi) == 0:
        e += 1
        d = inv(e, fi)

    return n, e, d


def rsa_fun(p, q, en_text):
    n, e, d = fun(p, q)
    de_text = ""
    for x in en_text:
        de_num = ord(x) * d % n
        de_text += chr(de_num)
    return n, e, d, en_text, de_text


if __name__ == "__main__":
    n, e, d, en_text, de_text = rsa_fun(53, 59, "pormblaowd")
    print("n:", n)
    print("e:", e)
    print("d:", d)
    print("en_text:", en_text)
    print("de_text:", de_text)


