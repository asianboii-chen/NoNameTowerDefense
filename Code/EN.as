package
{
	
	/**
	 * Encoded Number
	 *
	 * @author (C) 2017 - GTI Form1
	 */
	public final class EN
	{
		
		public function EN(x:Number = 0)
		{
			s(x);
		}
		
		protected var a:Number;
		protected var b:Boolean;
		protected var c:Number;
		protected var d:Number;
		protected var e:Number;
		protected var f:Number;
		
		public function g():Number
		{
			if (b)
				return a - c + d;
			
			return a - e + f;
		}
		
		public function s(x:Number):Number
		{
			b = !b;
			
			if (b)
			{
				c = Math.random() * 10000 - 5000;
				d = Math.random() * 10000 - 5000;
				a = x + c - d;
			}
			else
			{
				e = Math.random() * 10000 - 5000;
				f = Math.random() * 10000 - 5000;
				a = x + e - f;
			}
			
			return x;
		}
		
		public function toString():Number
		{
			return g();
		}
	
	}

}