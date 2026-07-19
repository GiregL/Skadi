defmodule Skadi.Cldr do
  use Cldr,
    default_locale: "fr",
    locales: ["fr"],
    add_fallback_locales: false,
    gettext: Skadi.Gettext,
    providers: [Cldr.Number],
    data_dit: "/.priv/cldr",
    otp_app: :skadi,
    precompile_number_formats: ["¤¤#,##0.##"],
    precompile_transliterations: [{:latn, :arab}, {:thai, :latn}],
    providers: [Cldr.Number, Cldr.DateTime, Cldr.Calendar],
    generate_docs: true,
    force_locale_download: false

end
