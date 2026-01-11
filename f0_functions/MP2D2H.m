function [x1, x2] = MP2D2H(in1, in2, M, P)

% 2DMP normal canal 1
x1 = contribuicaoHMP2D(in1, in1, in2, M, P);
% adicionar componente de segunda ordem para o canal 1
x1 = [x1, contribuicaoHMP2D(in2.*conj(in1), in1, in2, M, P)];
% adicionar componente de quarta ordem para o canal 1
x1 = [x1, contribuicaoHMP2D(in1.^3.*conj(in2), in1, in2, M, P)];

% 2DMP normal canal 2
x2 = contribuicaoHMP2D(in2, in1, in2, M, P);
% adicionar componente de segunda ordem para o canal 2
x2 = [x2, contribuicaoHMP2D(in1.^2, in1, in2, M, P)];
% adicionar componente de quarta ordem para o canal 2
x2 = [x2, contribuicaoHMP2D((in2.^2).*(conj(in1).^2), in1, in2, M, P)];

end

function [x] = contribuicaoHMP2D(in, in1, in2, M, P)

% vou modificar de (M-1) para M, para admitir valor zero.
x = [];
for m = 0:M
    for ak = 0:P
        for aj = 0:ak
            x = [x, [zeros(m,1); in(1:end-m)].*...
                abs([zeros(m,1); in1(1:end-m)]).^(ak-aj).*...
                abs([zeros(m,1); in2(1:end-m)]).^(aj)];
        end
    end
end

end
