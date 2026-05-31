{
    inputs = {
        sub_flake.url = "path:./sub";
    };

    outputs = {sub_flake, ...}: {
        sum_1_2 = sub_flake.add_a_b 1 2;
    };
}