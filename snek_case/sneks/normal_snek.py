from .snek import Snek


class NormalSnek(Snek):
    """
    A normal type of Snek.
    """

    snek_type = "normal"
    snek = """\
    --..,_                     _,.--.
       `'.'.                .'`__ o  `;__.
          '.'.            .'.'`  '---'`  `
            '.`'--....--'`.'
              `'--....--'`
              """
