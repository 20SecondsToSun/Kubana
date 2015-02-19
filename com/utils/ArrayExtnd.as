package com.utils
{
	
	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;


    use namespace flash_proxy;
	/**
	 * ...
	 * @author ypopov
	 */
	
	dynamic public class ArrayExtnd extends Proxy
	{
        private var _array:Array;
		private var _item:Array;

		public var DESCENDING:uint = 0;		
		public var NUMERIC:uint = 0;
		
		
       
		public function  ArrayExtnd(...arg) {
			
           _item = new Array();
        }
		
		public function getIt():Array
        {
            return _item ;
        }


         override flash_proxy function callProperty(methodName:*, ... args):* {
            var res:*;
            res = _item[methodName].apply(_item, args);
            return res;
        }

        override flash_proxy function getProperty(name:*):* {
            if(!isNaN(name)) {
                var index:int = name;
                while(index < 0) {
                    index +=  _item.length;

                }
                return _item[index %  _item.length];
            }


            return _item[name];
        }

        override flash_proxy function setProperty(name:*, value:*):void {
            _item[name] = value;
        }


        public function getSmallestElement():*
        {
            var helper:Array = _array.concat().sort();
            return helper[0];
        }
		public function assign(arr:Array):void
        {
            _item = arr;
        }
	
		
		public function printf(property:String = null):void 
		{
			
			trace("========	PRINTING ARRAY START =========");			
			if (property == null)
			{
				for (var i = 0 ;  i<  _item.length  ;  i++)
				{
					trace("name " +  _item[i]);
				}	
			}
			else
			{
				for (var j = 0 ;  j<  _item.length  ;  j++)
				{
					trace("name " +  _item[j][property]);
				}	
				
			}				
			trace("========	PRINTING ARRAY END ===========");		
			
		}
		
		//{ region 
		
		
		
		public function randomizeObjMass():void 
		{	
			
			for (var i:uint = 0; i <  _item.length; i++)			  
			{			  
				var rand:uint = int(Math.random() *  _item.length);
				
				 _item.push(  _item.splice( rand, 1 )[0] );
			   
			}
			
			
		}
		//} endregion
		
		public function sortObjMass(property:String , vars:Object):void 
		{
			var temp:Object = new Object;			
			var flag:Boolean = true;			
		
			DESCENDING = vars.DESCENDING ? vars.DESCENDING : 0;
			NUMERIC    = vars.NUMERIC    ? vars.NUMERIC    : 0;			
			
			while (flag)
			{				
				flag = false;
				
				for (var j:int = 0; j <  _item.length-1 ; j++) 
				{
					
					var a ;
					var b ;
					
					if (property == null)
					{
						a =  _item[j];
						b =  _item[j + 1];
					}
					else
					{
						a =  _item[j][property];
						b =  _item[j + 1][property];
					}
					
					
					if ( NUMERIC ) 					
					{
						a  = Number(a);
						b  = Number(b);
					}
					
					if ( DESCENDING )
					{
						if ( a < b)     
						{										
							temp =  _item[j]; 
							 _item[j]= _item[j+1];
							 _item[j + 1] = temp;						
							flag = true;
						}
					}
					else					
					if ( a > b)     
					{										
						temp =  _item[j]; 
						 _item[j]= _item[j+1];
						 _item[j + 1] = temp;						
						flag = true;
					}
				}
				
			}	
			
			
		}
		
		
		
		
		
		
		
		
		
	}

}