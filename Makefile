IMAGE_DEPS = gfx\image_000_323f.2bpp gfx\image_001_415f.2bpp gfx\image_001_4b5f.2bpp

all: game.gb

%.2bpp: %.png
	rgbgfx --colors embedded -o $@ $<

%.1bpp: %.png
	rgbgfx -d 1 -o $@ $<

game.o: game.asm bank_*.asm $(IMAGE_DEPS)
	rgbasm -o game.o game.asm

game.gb: game.o
	rgblink -n game.sym -m game.map -o $@ $<
	rgbfix -v -p 255 $@

	@if which md5sum &>/dev/null; then md5sum $@; else md5 $@; fi

clean:
	rm -f game.o game.gb game.sym game.map
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' \) -exec rm {} +