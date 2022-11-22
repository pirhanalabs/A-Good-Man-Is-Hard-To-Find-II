class M
{

    /**
     * converts a value from a range of floats to another
     * @param val original value
     * @param omin original min range number
     * @param omax original max range number
     * @param nmin new min range number
     * @param nmax new max range number
     */
    public static function range(val:Float, omin:Float, omax:Float, nmin:Float, nmax:Float){
        return (((val-omin)*(nmax-nmin)) / (omax-omin)) + nmin;
    }

    /**
     * converts a value from a range of integers to another
     * @param val original value
     * @param omin original min range number
     * @param omax original max range number
     * @param nmin new min range number
     * @param nmax new max range number
     */
    public static function irange(val:Int, omin:Int, omax:Int, nmin:Int, nmax:Int){
        return Math.floor(range(val, omin, omax, nmin, nmax));
    }

	/**
	 * returns a random number between a min and max integer, inclusively.
	 * @param min 
	 * @param max 
	 * @return Int
	 */
	public static function irand(min:Int, max:Int):Int
	{
		return Math.floor(Math.random() * (max - min + 1)) + min;
	}

	/**
	 * Picks a random item from an array<T>
	 * @param a 
	 */
	public static function pick<T>(a:Array<T>)
	{
		return a[irand(0, a.length - 1)];
	}

	/**
	 * returns the distance between two points.
	 * @param x1 point1 x position
	 * @param y1 point1 y position
	 * @param x2 point2 x position
	 * @param y2 point2 y position
	 */
	public static function dist(x1, y1, x2, y2)
	{
		return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
	}

	/**
	 * puts a value within a range of numbers.
     * if val < min, returns min.
     * if val > max, returns max.
     * otherwise, returns val.
	 * @param val 
	 * @param min 
	 * @param max 
	 */
	public static function imid(val:Int, min:Int, max:Int)
	{
		return val < min ? min : val > max ? max : val;
	}

	/**
	 * returns the lowest of two values.
	 * @param val1 
	 * @param val2 
	 */
	public static function imin(val1:Int, val2:Int)
	{
		return val1 < val2 ? val1 : val2;
	}
}