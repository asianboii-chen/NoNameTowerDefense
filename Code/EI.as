package
{
	
	/**
	 * Encoded int
	 *
	 * @author (C) 2017 - GTI Form1
	 */
	public final class EI
	{
		
		public function EI(x:int = 0)
		{
			s(x);
		}
		
		protected var a:int;
		protected var b:Boolean;
		protected var c:int;
		protected var d:int;
		protected var e:int;
		protected var f:int;
		
		public function g():int
		{
			if (b)
				return a - c + d;
			
			return a - e + f;
		}
		
		public function s(x:int):int
		{
			b = !b;
			
			if (b)
			{
				c = Math.random() * 10000000 - 500000;
				d = Math.random() * 10000000 - 500000;
				a = x + c - d;
			}
			else
			{
				e = Math.random() * 1000000 - 500000;
				f = Math.random() * 1000000 - 500000;
				a = x + e - f;
			}
			
			return x;
		}
		
		public function toString():int
		{
			return g();
		}
	
	}

}