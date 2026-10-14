-- Regras personalizadas da janela

-- Waydroid: interface estilo celular em RETRATO (9:20), na área de trabalho 2,
-- flutuante, centralizada e com tamanho proporcional ao monitor.
-- Resolução efetiva: 0.225 * largura do monitor x 0.8888 * altura (ex: 432x960 em 1920x1080).
hl.window_rule({
    name = "waydroid-phone-portrait",
    match = { class = "^(Waydroid)$" },
    workspace = "2",
    float = true,
    center = true,
    size = { "(monitor_w*0.225)", "(monitor_h*0.8888)" },
    keep_aspect_ratio = true, -- mantém 9:20 ao redimensionar (janela responsiva)
})