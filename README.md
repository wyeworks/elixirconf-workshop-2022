# WorldCup

## Setup inicial

Para sumarte al workshop te pedimos por favor que previamente instales Erlang, Elixir y Phoenix.

Si aún no los tienes instalados, puedes hacerlo de la siguiente manera:

1. Instalar asdf: https://asdf-vm.com/guide/getting-started.html

2. Instalar el plugin de Erlang:

   `asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git`

   (más info en: https://github.com/asdf-vm/asdf-erlang)

3. Instalar el plugin de Elixir:

   `asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git`

   (más info en https://github.com/asdf-vm/asdf-elixir)

4. Instalar Erlang y setearlo como versión global:

   `asdf install erlang 24.3.4.6`

   `asdf global erlang 24.3.4.6`

5. Instalar Elixir y setearlo como versión global:

   `asdf install elixir 1.14.1-otp-24`

   `asdf global elixir 1.14.1-otp-24`

6. Instalar Phoenix:

   `mix archive.install hex phx_new`

   (más info en: https://hexdocs.pm/phoenix/installation.html)

7. Chequeo versiones instaladas:

   Al correr `asdf current` en la terminal deberías ver:

   ```
     elixir          1.14.1-otp-24   /Users/<tu_usuario>/.tool-versions
     erlang          24.3.4.6        /Users/<tu_usuario>/.tool-versions
   ```

   Al correr `elixir -v` deberías ver:

   ```
   Erlang/OTP 24 [erts-12.3.2.6] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1]

   Elixir 1.14.1 (compiled with Erlang/OTP 24)
   ```

   Al correr `mix phx -v` deberías ver:

   ```
   Phoenix v1.6.12
   ```

**Importante:** si tienes algún problema instalando Elixir o Erlang, puedes probar instalando una versión anterior, siempre teniendo en cuenta que la **versión OTP** de Elixir coincida con la de Erlang, es decir: `asdf install elixir x.x.x-otp-<version OTP>` y `asdf install erlang <version OTP>.x.x.x`
