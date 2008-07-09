
import java.io.IOException;

import org.jruby.Ruby;
import org.jruby.RubyClass;
import org.jruby.RubyHash;
import org.jruby.RubyModule;
import org.jruby.RubyNumeric;
import org.jruby.RubyString;
import org.jruby.runtime.Block;
import org.jruby.runtime.CallbackFactory;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.exceptions.RaiseException;
import org.jruby.runtime.load.BasicLibraryService;

public class HpricotScanService implements BasicLibraryService {
       public static String NO_WAY_SERIOUSLY="*** This should not happen, please send a bug report with the HTML you're parsing to why@whytheluckystiff.net.  So sorry!";

       public void ELE(IRubyObject N) {
         if (tokend > tokstart || text) {
           IRubyObject raw_string = runtime.getNil();
           ele_open = false; text = false;
           if (tokstart != -1 && N != cdata && N != sym_text && N != procins && N != comment) { 
             raw_string = runtime.newString(new String(buf,tokstart,tokend-tokstart));
           } 
           rb_yield_tokens(N, tag[0], attr, raw_string, taint);
         }
       }

       public void SET(IRubyObject[] N, int E) {
         int mark = 0;
         if(N == tag) { 
           if(mark_tag == -1 || E == mark_tag) {
             tag[0] = runtime.newString("");
           } else if(E > mark_tag) {
             tag[0] = runtime.newString(new String(buf,mark_tag, E-mark_tag));
           }
         } else if(N == akey) {
           if(mark_akey == -1 || E == mark_akey) {
             akey[0] = runtime.newString("");
           } else if(E > mark_akey) {
             akey[0] = runtime.newString(new String(buf,mark_akey, E-mark_akey));
           }
         } else if(N == aval) {
           if(mark_aval == -1 || E == mark_aval) {
             aval[0] = runtime.newString("");
           } else if(E > mark_aval) {
             aval[0] = runtime.newString(new String(buf,mark_aval, E-mark_aval));
           }
         }
       }

       public void CAT(IRubyObject[] N, int E) {
         if(N[0].isNil()) {
           SET(N,E);
         } else {
           int mark = 0;
           if(N == tag) {
             mark = mark_tag;
           } else if(N == akey) {
             mark = mark_akey;
           } else if(N == aval) {
             mark = mark_aval;
           }
           ((RubyString)(N[0])).append(runtime.newString(new String(buf, mark, E-mark)));
         }
       }

       public void SLIDE(Object N) {
           int mark = 0;
           if(N == tag) {
             mark = mark_tag;
           } else if(N == akey) {
             mark = mark_akey;
           } else if(N == aval) {
             mark = mark_aval;
           }
           if(mark > tokstart) {
             if(N == tag) {
               mark_tag  -= tokstart;
             } else if(N == akey) {
               mark_akey -= tokstart;
             } else if(N == aval) {
               mark_aval -= tokstart;
             }
           }
       }

       public void ATTR(IRubyObject K, IRubyObject V) {
         if(!K.isNil()) {
           if(attr.isNil()) {
             attr = RubyHash.newHash(runtime);
           }
           ((RubyHash)attr).aset(K,V);
         }
       }

       public void ATTR(IRubyObject[] K, IRubyObject V) {
         ATTR(K[0],V);
       }

       public void ATTR(IRubyObject K, IRubyObject[] V) {
         ATTR(K,V[0]);
       }

       public void ATTR(IRubyObject[] K, IRubyObject[] V) {
         ATTR(K[0],V[0]);
       }

       public void TEXT_PASS() {
         if(!text) { 
           if(ele_open) { 
             ele_open = false; 
             if(tokstart > -1) { 
               mark_tag = tokstart; 
             } 
           } else {
             mark_tag = p; 
           } 
           attr = runtime.getNil(); 
           tag[0] = runtime.getNil(); 
           text = true; 
         }
       }

       public void EBLK(IRubyObject N, int T) {
         CAT(tag, p - T + 1);
         ELE(N);
       }


       public void rb_raise(RubyClass error, String message) {
              throw new RaiseException(runtime, error, message, true);
       }

       public IRubyObject rb_str_new2(String s) {
              return runtime.newString(s);
       }




static final byte[] _hpricot_scan_actions = {
	0, 1, 1, 1, 2, 1, 4, 1, 
	5, 1, 6, 1, 7, 1, 8, 1, 
	9, 1, 10, 1, 11, 1, 12, 1, 
	14, 1, 16, 1, 20, 1, 21, 1, 
	22, 1, 24, 1, 25, 1, 26, 1, 
	28, 1, 29, 1, 30, 1, 32, 1, 
	33, 1, 38, 1, 39, 1, 40, 1, 
	41, 1, 42, 1, 43, 1, 44, 1, 
	45, 1, 46, 1, 47, 1, 48, 1, 
	49, 1, 50, 2, 2, 5, 2, 2, 
	6, 2, 2, 11, 2, 2, 12, 2, 
	2, 14, 2, 4, 39, 2, 4, 40, 
	2, 4, 41, 2, 5, 2, 2, 6, 
	14, 2, 7, 6, 2, 7, 14, 2, 
	11, 12, 2, 13, 3, 2, 14, 6, 
	2, 14, 40, 2, 15, 24, 2, 15, 
	28, 2, 15, 32, 2, 15, 45, 2, 
	17, 23, 2, 18, 27, 2, 19, 31, 
	2, 22, 34, 2, 22, 36, 3, 2, 
	6, 14, 3, 2, 14, 6, 3, 6, 
	7, 14, 3, 6, 14, 40, 3, 7, 
	14, 40, 3, 14, 6, 40, 3, 14, 
	13, 3, 3, 22, 0, 37, 3, 22, 
	2, 34, 3, 22, 14, 35, 4, 2, 
	14, 13, 3, 4, 6, 7, 14, 40, 
	4, 22, 2, 14, 35, 4, 22, 6, 
	14, 35, 4, 22, 7, 14, 35, 4, 
	22, 14, 6, 35, 5, 22, 2, 6, 
	14, 35, 5, 22, 2, 14, 6, 35, 
	5, 22, 6, 7, 14, 35
};

static final short[] _hpricot_scan_key_offsets = {
	0, 3, 4, 5, 6, 7, 8, 9, 
	10, 13, 22, 37, 44, 45, 46, 47, 
	48, 49, 52, 57, 69, 81, 86, 93, 
	94, 95, 100, 101, 105, 106, 107, 121, 
	135, 152, 169, 186, 203, 210, 212, 214, 
	220, 222, 227, 232, 238, 240, 245, 251, 
	265, 266, 267, 268, 269, 270, 271, 272, 
	273, 274, 275, 276, 282, 296, 300, 313, 
	326, 340, 354, 355, 366, 375, 388, 405, 
	423, 441, 450, 461, 480, 499, 510, 521, 
	536, 538, 540, 556, 572, 575, 587, 599, 
	619, 639, 658, 677, 697, 717, 728, 739, 
	751, 763, 775, 791, 794, 809, 811, 813, 
	829, 845, 848, 860, 871, 890, 910, 930, 
	941, 952, 964, 984, 1004, 1016, 1036, 1057, 
	1074, 1091, 1095, 1098, 1110, 1122, 1142, 1162, 
	1182, 1194, 1206, 1226, 1242, 1258, 1270, 1291, 
	1310, 1313, 1328, 1340, 1355, 1358, 1369, 1371, 
	1373, 1384, 1391, 1404, 1418, 1432, 1445, 1446, 
	1447, 1448, 1449, 1450, 1451, 1455, 1460, 1469, 
	1479, 1484, 1491, 1492, 1493, 1494, 1495, 1496, 
	1497, 1498, 1499, 1503, 1508, 1512, 1522, 1527, 
	1533, 1534, 1535, 1536, 1537, 1538, 1539, 1540, 
	1541, 1542, 1546, 1551, 1553, 1554, 1555, 1560, 
	1561, 1562, 1564, 1565, 1566, 1567, 1568, 1572, 
	1582, 1591, 1601, 1602, 1603, 1605, 1614, 1615, 
	1616, 1617, 1619, 1621, 1624, 1627, 1631, 1633, 
	1634, 1636, 1637, 1640
};

static final char[] _hpricot_scan_trans_keys = {
	45, 68, 91, 45, 79, 67, 84, 89, 
	80, 69, 32, 9, 13, 32, 58, 95, 
	9, 13, 65, 90, 97, 122, 32, 62, 
	63, 91, 95, 9, 13, 45, 46, 48, 
	58, 65, 90, 97, 122, 32, 62, 80, 
	83, 91, 9, 13, 85, 66, 76, 73, 
	67, 32, 9, 13, 32, 34, 39, 9, 
	13, 9, 34, 61, 95, 32, 37, 39, 
	59, 63, 90, 97, 122, 9, 34, 61, 
	95, 32, 37, 39, 59, 63, 90, 97, 
	122, 32, 62, 91, 9, 13, 32, 34, 
	39, 62, 91, 9, 13, 34, 34, 32, 
	62, 91, 9, 13, 93, 32, 62, 9, 
	13, 39, 39, 9, 39, 61, 95, 32, 
	33, 35, 37, 40, 59, 63, 90, 97, 
	122, 9, 39, 61, 95, 32, 33, 35, 
	37, 40, 59, 63, 90, 97, 122, 9, 
	32, 33, 39, 62, 91, 95, 10, 13, 
	35, 37, 40, 59, 61, 90, 97, 122, 
	9, 32, 34, 39, 62, 91, 95, 10, 
	13, 33, 37, 40, 59, 61, 90, 97, 
	122, 9, 32, 33, 39, 62, 91, 95, 
	10, 13, 35, 37, 40, 59, 61, 90, 
	97, 122, 9, 32, 34, 39, 62, 91, 
	95, 10, 13, 33, 37, 40, 59, 61, 
	90, 97, 122, 32, 34, 39, 62, 91, 
	9, 13, 34, 39, 34, 39, 32, 39, 
	62, 91, 9, 13, 39, 93, 32, 62, 
	93, 9, 13, 32, 39, 62, 9, 13, 
	32, 34, 62, 91, 9, 13, 34, 93, 
	32, 34, 62, 9, 13, 32, 39, 62, 
	91, 9, 13, 9, 39, 61, 95, 32, 
	33, 35, 37, 40, 59, 63, 90, 97, 
	122, 89, 83, 84, 69, 77, 67, 68, 
	65, 84, 65, 91, 58, 95, 65, 90, 
	97, 122, 32, 62, 63, 95, 9, 13, 
	45, 46, 48, 58, 65, 90, 97, 122, 
	32, 62, 9, 13, 32, 47, 62, 63, 
	95, 9, 13, 45, 58, 65, 90, 97, 
	122, 32, 47, 62, 63, 95, 9, 13, 
	45, 58, 65, 90, 97, 122, 32, 47, 
	61, 62, 63, 95, 9, 13, 45, 58, 
	65, 90, 97, 122, 32, 47, 61, 62, 
	63, 95, 9, 13, 45, 58, 65, 90, 
	97, 122, 62, 13, 32, 34, 39, 47, 
	60, 62, 9, 10, 11, 12, 13, 32, 
	47, 60, 62, 9, 10, 11, 12, 32, 
	47, 62, 63, 95, 9, 13, 45, 58, 
	65, 90, 97, 122, 13, 32, 47, 60, 
	62, 63, 95, 9, 10, 11, 12, 45, 
	58, 65, 90, 97, 122, 13, 32, 47, 
	60, 61, 62, 63, 95, 9, 10, 11, 
	12, 45, 58, 65, 90, 97, 122, 13, 
	32, 47, 60, 61, 62, 63, 95, 9, 
	10, 11, 12, 45, 58, 65, 90, 97, 
	122, 13, 32, 47, 60, 62, 9, 10, 
	11, 12, 13, 32, 34, 39, 47, 60, 
	62, 9, 10, 11, 12, 13, 32, 34, 
	39, 47, 60, 62, 63, 95, 9, 10, 
	11, 12, 45, 58, 65, 90, 97, 122, 
	13, 32, 34, 39, 47, 60, 62, 63, 
	95, 9, 10, 11, 12, 45, 58, 65, 
	90, 97, 122, 13, 32, 34, 47, 60, 
	62, 92, 9, 10, 11, 12, 13, 32, 
	34, 47, 60, 62, 92, 9, 10, 11, 
	12, 32, 34, 47, 62, 63, 92, 95, 
	9, 13, 45, 58, 65, 90, 97, 122, 
	34, 92, 34, 92, 32, 34, 47, 61, 
	62, 63, 92, 95, 9, 13, 45, 58, 
	65, 90, 97, 122, 32, 34, 47, 61, 
	62, 63, 92, 95, 9, 13, 45, 58, 
	65, 90, 97, 122, 34, 62, 92, 13, 
	32, 34, 39, 47, 60, 62, 92, 9, 
	10, 11, 12, 13, 32, 34, 39, 47, 
	60, 62, 92, 9, 10, 11, 12, 13, 
	32, 34, 39, 47, 60, 62, 63, 92, 
	95, 9, 10, 11, 12, 45, 58, 65, 
	90, 97, 122, 13, 32, 34, 39, 47, 
	60, 62, 63, 92, 95, 9, 10, 11, 
	12, 45, 58, 65, 90, 97, 122, 13, 
	32, 34, 47, 60, 62, 63, 92, 95, 
	9, 10, 11, 12, 45, 58, 65, 90, 
	97, 122, 13, 32, 34, 47, 60, 62, 
	63, 92, 95, 9, 10, 11, 12, 45, 
	58, 65, 90, 97, 122, 13, 32, 34, 
	47, 60, 61, 62, 63, 92, 95, 9, 
	10, 11, 12, 45, 58, 65, 90, 97, 
	122, 13, 32, 34, 47, 60, 61, 62, 
	63, 92, 95, 9, 10, 11, 12, 45, 
	58, 65, 90, 97, 122, 13, 32, 34, 
	47, 60, 62, 92, 9, 10, 11, 12, 
	13, 32, 34, 47, 60, 62, 92, 9, 
	10, 11, 12, 13, 32, 34, 39, 47, 
	60, 62, 92, 9, 10, 11, 12, 13, 
	32, 34, 39, 47, 60, 62, 92, 9, 
	10, 11, 12, 13, 32, 34, 39, 47, 
	60, 62, 92, 9, 10, 11, 12, 32, 
	34, 39, 47, 62, 63, 92, 95, 9, 
	13, 45, 58, 65, 90, 97, 122, 34, 
	39, 92, 32, 39, 47, 62, 63, 92, 
	95, 9, 13, 45, 58, 65, 90, 97, 
	122, 39, 92, 39, 92, 32, 39, 47, 
	61, 62, 63, 92, 95, 9, 13, 45, 
	58, 65, 90, 97, 122, 32, 39, 47, 
	61, 62, 63, 92, 95, 9, 13, 45, 
	58, 65, 90, 97, 122, 39, 62, 92, 
	13, 32, 34, 39, 47, 60, 62, 92, 
	9, 10, 11, 12, 13, 32, 39, 47, 
	60, 62, 92, 9, 10, 11, 12, 13, 
	32, 39, 47, 60, 62, 63, 92, 95, 
	9, 10, 11, 12, 45, 58, 65, 90, 
	97, 122, 13, 32, 39, 47, 60, 61, 
	62, 63, 92, 95, 9, 10, 11, 12, 
	45, 58, 65, 90, 97, 122, 13, 32, 
	39, 47, 60, 61, 62, 63, 92, 95, 
	9, 10, 11, 12, 45, 58, 65, 90, 
	97, 122, 13, 32, 39, 47, 60, 62, 
	92, 9, 10, 11, 12, 13, 32, 39, 
	47, 60, 62, 92, 9, 10, 11, 12, 
	13, 32, 34, 39, 47, 60, 62, 92, 
	9, 10, 11, 12, 13, 32, 34, 39, 
	47, 60, 62, 63, 92, 95, 9, 10, 
	11, 12, 45, 58, 65, 90, 97, 122, 
	13, 32, 34, 39, 47, 60, 62, 63, 
	92, 95, 9, 10, 11, 12, 45, 58, 
	65, 90, 97, 122, 13, 32, 34, 39, 
	47, 60, 62, 92, 9, 10, 11, 12, 
	13, 32, 34, 39, 47, 60, 62, 63, 
	92, 95, 9, 10, 11, 12, 45, 58, 
	65, 90, 97, 122, 13, 32, 34, 39, 
	47, 60, 61, 62, 63, 92, 95, 9, 
	10, 11, 12, 45, 58, 65, 90, 97, 
	122, 32, 34, 39, 47, 61, 62, 63, 
	92, 95, 9, 13, 45, 58, 65, 90, 
	97, 122, 32, 34, 39, 47, 61, 62, 
	63, 92, 95, 9, 13, 45, 58, 65, 
	90, 97, 122, 34, 39, 62, 92, 34, 
	39, 92, 13, 32, 34, 39, 47, 60, 
	62, 92, 9, 10, 11, 12, 13, 32, 
	34, 39, 47, 60, 62, 92, 9, 10, 
	11, 12, 13, 32, 34, 39, 47, 60, 
	62, 63, 92, 95, 9, 10, 11, 12, 
	45, 58, 65, 90, 97, 122, 13, 32, 
	34, 39, 47, 60, 62, 63, 92, 95, 
	9, 10, 11, 12, 45, 58, 65, 90, 
	97, 122, 13, 32, 34, 39, 47, 60, 
	62, 63, 92, 95, 9, 10, 11, 12, 
	45, 58, 65, 90, 97, 122, 13, 32, 
	34, 39, 47, 60, 62, 92, 9, 10, 
	11, 12, 13, 32, 34, 39, 47, 60, 
	62, 92, 9, 10, 11, 12, 13, 32, 
	34, 39, 47, 60, 62, 63, 92, 95, 
	9, 10, 11, 12, 45, 58, 65, 90, 
	97, 122, 32, 34, 39, 47, 62, 63, 
	92, 95, 9, 13, 45, 58, 65, 90, 
	97, 122, 32, 34, 39, 47, 62, 63, 
	92, 95, 9, 13, 45, 58, 65, 90, 
	97, 122, 13, 32, 34, 39, 47, 60, 
	62, 92, 9, 10, 11, 12, 13, 32, 
	34, 39, 47, 60, 61, 62, 63, 92, 
	95, 9, 10, 11, 12, 45, 58, 65, 
	90, 97, 122, 13, 32, 39, 47, 60, 
	62, 63, 92, 95, 9, 10, 11, 12, 
	45, 58, 65, 90, 97, 122, 34, 39, 
	92, 32, 39, 47, 62, 63, 92, 95, 
	9, 13, 45, 58, 65, 90, 97, 122, 
	13, 32, 34, 39, 47, 60, 62, 92, 
	9, 10, 11, 12, 32, 34, 47, 62, 
	63, 92, 95, 9, 13, 45, 58, 65, 
	90, 97, 122, 34, 39, 92, 13, 32, 
	39, 47, 60, 62, 92, 9, 10, 11, 
	12, 34, 92, 39, 92, 13, 32, 34, 
	39, 47, 60, 62, 9, 10, 11, 12, 
	58, 95, 120, 65, 90, 97, 122, 32, 
	63, 95, 9, 13, 45, 46, 48, 58, 
	65, 90, 97, 122, 32, 63, 95, 109, 
	9, 13, 45, 46, 48, 58, 65, 90, 
	97, 122, 32, 63, 95, 108, 9, 13, 
	45, 46, 48, 58, 65, 90, 97, 122, 
	32, 63, 95, 9, 13, 45, 46, 48, 
	58, 65, 90, 97, 122, 101, 114, 115, 
	105, 111, 110, 32, 61, 9, 13, 32, 
	34, 39, 9, 13, 95, 45, 46, 48, 
	58, 65, 90, 97, 122, 34, 95, 45, 
	46, 48, 58, 65, 90, 97, 122, 32, 
	62, 63, 9, 13, 32, 62, 63, 101, 
	115, 9, 13, 62, 110, 99, 111, 100, 
	105, 110, 103, 32, 61, 9, 13, 32, 
	34, 39, 9, 13, 65, 90, 97, 122, 
	34, 95, 45, 46, 48, 57, 65, 90, 
	97, 122, 32, 62, 63, 9, 13, 32, 
	62, 63, 115, 9, 13, 116, 97, 110, 
	100, 97, 108, 111, 110, 101, 32, 61, 
	9, 13, 32, 34, 39, 9, 13, 110, 
	121, 111, 34, 32, 62, 63, 9, 13, 
	101, 115, 110, 121, 111, 39, 101, 115, 
	65, 90, 97, 122, 39, 95, 45, 46, 
	48, 57, 65, 90, 97, 122, 95, 45, 
	46, 48, 58, 65, 90, 97, 122, 39, 
	95, 45, 46, 48, 58, 65, 90, 97, 
	122, 62, 62, 10, 60, 33, 47, 58, 
	63, 95, 65, 90, 97, 122, 39, 93, 
	34, 34, 92, 39, 92, 34, 39, 92, 
	32, 9, 13, 32, 118, 9, 13, 10, 
	45, 45, 10, 93, 93, 10, 62, 63, 
	62, 0
};

static final byte[] _hpricot_scan_single_lengths = {
	3, 1, 1, 1, 1, 1, 1, 1, 
	1, 3, 5, 5, 1, 1, 1, 1, 
	1, 1, 3, 4, 4, 3, 5, 1, 
	1, 3, 1, 2, 1, 1, 4, 4, 
	7, 7, 7, 7, 5, 2, 2, 4, 
	2, 3, 3, 4, 2, 3, 4, 4, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 2, 4, 2, 5, 5, 
	6, 6, 1, 7, 5, 5, 7, 8, 
	8, 5, 7, 9, 9, 7, 7, 7, 
	2, 2, 8, 8, 3, 8, 8, 10, 
	10, 9, 9, 10, 10, 7, 7, 8, 
	8, 8, 8, 3, 7, 2, 2, 8, 
	8, 3, 8, 7, 9, 10, 10, 7, 
	7, 8, 10, 10, 8, 10, 11, 9, 
	9, 4, 3, 8, 8, 10, 10, 10, 
	8, 8, 10, 8, 8, 8, 11, 9, 
	3, 7, 8, 7, 3, 7, 2, 2, 
	7, 3, 3, 4, 4, 3, 1, 1, 
	1, 1, 1, 1, 2, 3, 1, 2, 
	3, 5, 1, 1, 1, 1, 1, 1, 
	1, 1, 2, 3, 0, 2, 3, 4, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 2, 3, 2, 1, 1, 3, 1, 
	1, 2, 1, 1, 1, 1, 0, 2, 
	1, 2, 1, 1, 2, 5, 1, 1, 
	1, 2, 2, 3, 1, 2, 2, 1, 
	2, 1, 3, 1
};

static final byte[] _hpricot_scan_range_lengths = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	1, 3, 5, 1, 0, 0, 0, 0, 
	0, 1, 1, 4, 4, 1, 1, 0, 
	0, 1, 0, 1, 0, 0, 5, 5, 
	5, 5, 5, 5, 1, 0, 0, 1, 
	0, 1, 1, 1, 0, 1, 1, 5, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 2, 5, 1, 4, 4, 
	4, 4, 0, 2, 2, 4, 5, 5, 
	5, 2, 2, 5, 5, 2, 2, 4, 
	0, 0, 4, 4, 0, 2, 2, 5, 
	5, 5, 5, 5, 5, 2, 2, 2, 
	2, 2, 4, 0, 4, 0, 0, 4, 
	4, 0, 2, 2, 5, 5, 5, 2, 
	2, 2, 5, 5, 2, 5, 5, 4, 
	4, 0, 0, 2, 2, 5, 5, 5, 
	2, 2, 5, 4, 4, 2, 5, 5, 
	0, 4, 2, 4, 0, 2, 0, 0, 
	2, 2, 5, 5, 5, 5, 0, 0, 
	0, 0, 0, 0, 1, 1, 4, 4, 
	1, 1, 0, 0, 0, 0, 0, 0, 
	0, 0, 1, 1, 2, 4, 1, 1, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 1, 1, 0, 0, 0, 1, 0, 
	0, 0, 0, 0, 0, 0, 2, 4, 
	4, 4, 0, 0, 0, 2, 0, 0, 
	0, 0, 0, 0, 1, 1, 0, 0, 
	0, 0, 0, 0
};

static final short[] _hpricot_scan_index_offsets = {
	0, 4, 6, 8, 10, 12, 14, 16, 
	18, 21, 28, 39, 46, 48, 50, 52, 
	54, 56, 59, 64, 73, 82, 87, 94, 
	96, 98, 103, 105, 109, 111, 113, 123, 
	133, 146, 159, 172, 185, 192, 195, 198, 
	204, 207, 212, 217, 223, 226, 231, 237, 
	247, 249, 251, 253, 255, 257, 259, 261, 
	263, 265, 267, 269, 274, 284, 288, 298, 
	308, 319, 330, 332, 342, 350, 360, 373, 
	387, 401, 409, 419, 434, 449, 459, 469, 
	481, 484, 487, 500, 513, 517, 528, 539, 
	555, 571, 586, 601, 617, 633, 643, 653, 
	664, 675, 686, 699, 703, 715, 718, 721, 
	734, 747, 751, 762, 772, 787, 803, 819, 
	829, 839, 850, 866, 882, 893, 909, 926, 
	940, 954, 959, 963, 974, 985, 1001, 1017, 
	1033, 1044, 1055, 1071, 1084, 1097, 1108, 1125, 
	1140, 1144, 1156, 1167, 1179, 1183, 1193, 1196, 
	1199, 1209, 1215, 1224, 1234, 1244, 1253, 1255, 
	1257, 1259, 1261, 1263, 1265, 1269, 1274, 1280, 
	1287, 1292, 1299, 1301, 1303, 1305, 1307, 1309, 
	1311, 1313, 1315, 1319, 1324, 1327, 1334, 1339, 
	1345, 1347, 1349, 1351, 1353, 1355, 1357, 1359, 
	1361, 1363, 1367, 1372, 1375, 1377, 1379, 1384, 
	1386, 1388, 1391, 1393, 1395, 1397, 1399, 1402, 
	1409, 1415, 1422, 1424, 1426, 1429, 1437, 1439, 
	1441, 1443, 1446, 1449, 1453, 1456, 1460, 1463, 
	1465, 1468, 1470, 1474
};

static final short[] _hpricot_scan_indicies = {
	335, 336, 337, 296, 356, 296, 349, 296, 
	399, 296, 401, 296, 354, 296, 350, 296, 
	400, 296, 308, 308, 296, 308, 309, 309, 
	308, 309, 309, 296, 328, 330, 329, 331, 
	329, 328, 329, 329, 329, 329, 296, 310, 
	302, 311, 312, 0, 310, 296, 353, 296, 
	342, 296, 347, 296, 346, 296, 343, 296, 
	304, 304, 296, 304, 305, 306, 304, 296, 
	321, 320, 321, 321, 321, 321, 321, 321, 
	296, 319, 320, 319, 319, 319, 319, 319, 
	319, 296, 298, 302, 0, 298, 296, 298, 
	300, 307, 302, 0, 298, 296, 6, 222, 
	6, 13, 358, 302, 0, 358, 69, 1, 
	0, 1, 302, 1, 69, 6, 182, 6, 
	5, 322, 323, 322, 322, 322, 322, 322, 
	322, 322, 296, 299, 303, 299, 299, 299, 
	299, 299, 299, 299, 296, 297, 297, 299, 
	303, 302, 0, 299, 298, 299, 299, 299, 
	299, 296, 297, 297, 300, 301, 302, 0, 
	299, 298, 299, 299, 299, 299, 296, 186, 
	186, 188, 42, 184, 185, 188, 187, 188, 
	188, 188, 188, 182, 43, 43, 38, 44, 
	40, 34, 41, 37, 41, 41, 41, 41, 
	5, 37, 38, 39, 40, 34, 37, 5, 
	63, 224, 223, 63, 64, 62, 371, 6, 
	40, 34, 371, 5, 35, 36, 34, 26, 
	27, 1, 26, 0, 36, 6, 40, 36, 
	5, 60, 6, 61, 58, 60, 13, 35, 
	59, 58, 59, 6, 61, 59, 13, 183, 
	6, 184, 185, 183, 182, 41, 42, 41, 
	41, 41, 41, 41, 41, 41, 5, 403, 
	296, 351, 296, 352, 296, 345, 296, 348, 
	296, 398, 296, 344, 296, 341, 296, 402, 
	296, 397, 296, 355, 296, 338, 338, 338, 
	338, 296, 332, 334, 333, 333, 332, 333, 
	333, 333, 333, 296, 313, 314, 313, 296, 
	324, 326, 327, 325, 325, 324, 325, 325, 
	325, 296, 315, 317, 318, 316, 316, 315, 
	316, 316, 316, 296, 364, 366, 367, 368, 
	365, 365, 364, 365, 365, 365, 69, 359, 
	361, 362, 162, 360, 360, 359, 360, 360, 
	360, 69, 369, 69, 157, 157, 159, 160, 
	161, 69, 162, 157, 158, 156, 66, 66, 
	68, 69, 70, 66, 67, 65, 363, 361, 
	162, 360, 360, 363, 360, 360, 360, 69, 
	66, 66, 74, 69, 76, 73, 73, 66, 
	67, 73, 73, 73, 65, 132, 132, 135, 
	69, 136, 137, 134, 134, 132, 133, 134, 
	134, 134, 65, 71, 71, 74, 69, 75, 
	76, 73, 73, 71, 72, 73, 73, 73, 
	65, 66, 66, 68, 69, 70, 66, 67, 
	65, 226, 226, 228, 229, 230, 69, 70, 
	226, 227, 156, 163, 163, 159, 160, 161, 
	69, 162, 165, 165, 163, 164, 165, 165, 
	165, 156, 226, 226, 228, 229, 231, 69, 
	76, 165, 165, 226, 227, 165, 165, 165, 
	156, 248, 248, 84, 246, 199, 250, 195, 
	248, 249, 189, 92, 92, 84, 95, 7, 
	96, 97, 92, 93, 91, 372, 3, 48, 
	50, 47, 8, 47, 372, 47, 47, 47, 
	7, 3, 8, 7, 11, 8, 7, 122, 
	3, 124, 125, 126, 123, 8, 123, 122, 
	123, 123, 123, 7, 46, 3, 48, 49, 
	50, 47, 8, 47, 46, 47, 47, 47, 
	7, 3, 45, 8, 7, 190, 190, 192, 
	193, 194, 7, 50, 195, 190, 191, 189, 
	196, 196, 192, 193, 194, 7, 50, 195, 
	196, 197, 189, 196, 196, 192, 193, 194, 
	7, 50, 198, 195, 198, 196, 197, 198, 
	198, 198, 189, 242, 242, 244, 245, 247, 
	7, 103, 198, 195, 198, 242, 243, 198, 
	198, 198, 189, 248, 248, 84, 247, 199, 
	251, 198, 195, 198, 248, 249, 198, 198, 
	198, 189, 92, 92, 84, 101, 7, 103, 
	100, 97, 100, 92, 93, 100, 100, 100, 
	91, 144, 144, 84, 147, 7, 148, 149, 
	146, 97, 146, 144, 145, 146, 146, 146, 
	91, 98, 98, 84, 101, 7, 102, 103, 
	100, 97, 100, 98, 99, 100, 100, 100, 
	91, 92, 92, 84, 95, 7, 96, 97, 
	92, 93, 91, 92, 92, 94, 95, 7, 
	96, 97, 92, 93, 91, 242, 242, 244, 
	245, 246, 7, 96, 195, 242, 243, 189, 
	258, 258, 263, 94, 256, 215, 261, 211, 
	258, 259, 205, 105, 105, 80, 94, 108, 
	9, 109, 110, 105, 106, 104, 373, 10, 
	11, 55, 57, 54, 12, 54, 373, 54, 
	54, 54, 9, 10, 11, 12, 9, 370, 
	3, 31, 33, 30, 4, 30, 370, 30, 
	30, 30, 2, 3, 4, 2, 10, 4, 
	2, 117, 3, 119, 120, 121, 118, 4, 
	118, 117, 118, 118, 118, 2, 29, 3, 
	31, 32, 33, 30, 4, 30, 29, 30, 
	30, 30, 2, 3, 28, 4, 2, 167, 
	167, 169, 170, 171, 2, 33, 172, 167, 
	168, 166, 78, 78, 84, 81, 2, 82, 
	83, 78, 79, 77, 78, 78, 84, 88, 
	2, 90, 87, 83, 87, 78, 79, 87, 
	87, 87, 77, 138, 138, 84, 141, 2, 
	142, 143, 140, 83, 140, 138, 139, 140, 
	140, 140, 77, 85, 85, 84, 88, 2, 
	89, 90, 87, 83, 87, 85, 86, 87, 
	87, 87, 77, 78, 78, 84, 81, 2, 
	82, 83, 78, 79, 77, 78, 78, 80, 
	81, 2, 82, 83, 78, 79, 77, 232, 
	232, 234, 235, 236, 2, 82, 172, 232, 
	233, 166, 173, 173, 169, 170, 171, 2, 
	33, 175, 172, 175, 173, 174, 175, 175, 
	175, 166, 232, 232, 234, 235, 237, 2, 
	90, 175, 172, 175, 232, 233, 175, 175, 
	175, 166, 258, 258, 80, 260, 256, 215, 
	261, 211, 258, 259, 205, 105, 105, 80, 
	94, 114, 9, 116, 113, 110, 113, 105, 
	106, 113, 113, 113, 104, 150, 150, 80, 
	94, 153, 9, 154, 155, 152, 110, 152, 
	150, 151, 152, 152, 152, 104, 53, 10, 
	11, 55, 56, 57, 54, 12, 54, 53, 
	54, 54, 54, 9, 127, 10, 11, 129, 
	130, 131, 128, 12, 128, 127, 128, 128, 
	128, 9, 10, 11, 52, 12, 9, 51, 
	51, 12, 9, 206, 206, 208, 209, 210, 
	9, 57, 211, 206, 207, 205, 212, 212, 
	208, 209, 210, 9, 57, 211, 212, 213, 
	205, 212, 212, 208, 209, 210, 9, 57, 
	214, 211, 214, 212, 213, 214, 214, 214, 
	205, 252, 252, 254, 255, 257, 9, 116, 
	214, 211, 214, 252, 253, 214, 214, 214, 
	205, 258, 258, 80, 260, 257, 215, 262, 
	214, 211, 214, 258, 259, 214, 214, 214, 
	205, 105, 105, 80, 94, 108, 9, 109, 
	110, 105, 106, 104, 105, 105, 107, 107, 
	108, 9, 109, 110, 105, 106, 104, 258, 
	258, 263, 94, 257, 215, 262, 214, 211, 
	214, 258, 259, 214, 214, 214, 205, 218, 
	10, 216, 220, 221, 219, 217, 219, 218, 
	219, 219, 219, 215, 218, 225, 11, 220, 
	221, 219, 217, 219, 218, 219, 219, 219, 
	215, 252, 252, 254, 255, 256, 9, 109, 
	211, 252, 253, 205, 111, 111, 80, 94, 
	114, 9, 115, 116, 113, 110, 113, 111, 
	112, 113, 113, 113, 104, 238, 238, 84, 
	237, 176, 241, 175, 172, 175, 238, 239, 
	175, 175, 175, 166, 10, 216, 217, 215, 
	178, 3, 180, 181, 179, 177, 179, 178, 
	179, 179, 179, 176, 173, 173, 169, 170, 
	171, 2, 33, 172, 173, 174, 166, 201, 
	3, 203, 204, 202, 200, 202, 201, 202, 
	202, 202, 199, 225, 11, 217, 215, 238, 
	238, 84, 236, 176, 240, 172, 238, 239, 
	166, 3, 200, 199, 3, 177, 176, 163, 
	163, 159, 160, 161, 69, 162, 163, 164, 
	156, 339, 339, 340, 339, 339, 296, 15, 
	357, 357, 15, 357, 357, 357, 357, 296, 
	15, 357, 357, 408, 15, 357, 357, 357, 
	357, 296, 15, 357, 357, 404, 15, 357, 
	357, 357, 357, 296, 16, 357, 357, 16, 
	357, 357, 357, 357, 296, 287, 264, 294, 
	264, 396, 264, 387, 264, 393, 264, 268, 
	264, 268, 265, 268, 264, 265, 266, 267, 
	265, 264, 282, 282, 282, 282, 282, 264, 
	275, 276, 276, 276, 276, 276, 264, 269, 
	270, 271, 269, 264, 269, 270, 271, 272, 
	273, 269, 264, 270, 264, 388, 264, 285, 
	264, 394, 264, 385, 264, 289, 264, 390, 
	264, 288, 264, 288, 374, 288, 264, 374, 
	375, 376, 374, 264, 283, 283, 264, 277, 
	278, 278, 278, 278, 278, 264, 274, 270, 
	271, 274, 264, 274, 270, 271, 273, 274, 
	264, 295, 264, 384, 264, 389, 264, 286, 
	264, 284, 264, 290, 264, 395, 264, 391, 
	264, 380, 264, 380, 377, 380, 264, 377, 
	378, 379, 377, 264, 291, 292, 264, 293, 
	264, 279, 264, 381, 270, 271, 381, 264, 
	386, 264, 293, 264, 405, 406, 264, 392, 
	264, 279, 264, 407, 264, 392, 264, 383, 
	383, 264, 277, 281, 281, 281, 281, 281, 
	264, 382, 382, 382, 382, 382, 264, 275, 
	280, 280, 280, 280, 280, 264, 415, 414, 
	422, 421, 24, 25, 23, 19, 20, 21, 
	22, 21, 21, 21, 18, 6, 5, 1, 
	0, 6, 13, 3, 8, 7, 3, 4, 
	2, 10, 11, 12, 9, 15, 15, 14, 
	16, 17, 16, 14, 412, 413, 411, 410, 
	409, 419, 420, 418, 417, 416, 426, 424, 
	427, 425, 424, 423, 0
};

static final short[] _hpricot_scan_trans_targs_wi = {
	26, 27, 101, 69, 102, 29, 25, 80, 
	81, 99, 100, 79, 122, 24, 204, 212, 
	213, 150, 204, 0, 59, 62, 145, 204, 
	204, 205, 41, 207, 210, 104, 103, 105, 
	106, 210, 40, 41, 42, 36, 37, 46, 
	206, 47, 32, 35, 34, 209, 83, 82, 
	84, 85, 209, 98, 211, 119, 120, 121, 
	123, 211, 44, 45, 43, 208, 38, 39, 
	43, 68, 69, 70, 73, 204, 204, 65, 
	72, 71, 73, 74, 204, 107, 100, 108, 
	108, 111, 210, 112, 70, 104, 110, 109, 
	111, 113, 210, 78, 79, 90, 90, 93, 
	209, 94, 83, 92, 91, 93, 95, 209, 
	97, 98, 117, 117, 128, 211, 129, 119, 
	134, 118, 128, 133, 211, 104, 103, 105, 
	106, 210, 83, 82, 84, 85, 209, 119, 
	120, 121, 123, 211, 65, 72, 71, 73, 
	74, 204, 104, 110, 109, 111, 113, 210, 
	83, 92, 91, 93, 95, 209, 119, 134, 
	118, 128, 133, 211, 68, 144, 74, 142, 
	143, 73, 204, 75, 76, 71, 107, 138, 
	113, 136, 137, 111, 112, 114, 115, 109, 
	101, 102, 100, 103, 105, 210, 29, 39, 
	206, 40, 35, 36, 47, 78, 86, 95, 
	139, 140, 93, 94, 87, 88, 91, 80, 
	81, 79, 82, 84, 209, 97, 124, 133, 
	131, 132, 128, 129, 125, 126, 118, 99, 
	79, 122, 98, 120, 121, 211, 24, 38, 
	43, 100, 75, 76, 77, 141, 73, 73, 
	114, 115, 116, 135, 111, 111, 100, 108, 
	210, 210, 87, 88, 89, 96, 93, 93, 
	79, 90, 209, 209, 125, 126, 127, 130, 
	128, 128, 98, 117, 90, 211, 211, 108, 
	204, 157, 158, 200, 156, 161, 204, 162, 
	163, 176, 175, 160, 159, 174, 173, 190, 
	201, 199, 159, 173, 181, 165, 180, 151, 
	170, 168, 182, 188, 191, 189, 152, 177, 
	204, 33, 22, 31, 23, 34, 204, 32, 
	18, 19, 30, 28, 9, 10, 11, 12, 
	48, 61, 204, 63, 64, 66, 204, 20, 
	21, 20, 31, 32, 63, 62, 66, 204, 
	11, 10, 204, 26, 61, 60, 204, 1, 
	2, 53, 60, 146, 147, 56, 14, 17, 
	55, 52, 16, 15, 21, 3, 7, 50, 
	51, 13, 6, 204, 204, 146, 25, 65, 
	64, 66, 67, 69, 65, 64, 66, 67, 
	204, 204, 100, 39, 79, 98, 171, 172, 
	198, 186, 187, 193, 185, 190, 201, 199, 
	178, 167, 192, 154, 164, 179, 169, 184, 
	195, 155, 166, 183, 153, 58, 54, 4, 
	8, 5, 57, 49, 149, 194, 196, 197, 
	148, 214, 202, 214, 214, 215, 214, 214, 
	216, 203, 216, 216, 217, 216, 216, 218, 
	218, 218, 218, 219
};

static final short[] _hpricot_scan_trans_actions_wi = {
	0, 0, 0, 7, 0, 0, 21, 0, 
	0, 0, 7, 7, 0, 0, 65, 0, 
	31, 0, 67, 0, 0, 1, 0, 63, 
	132, 178, 0, 144, 147, 0, 174, 23, 
	0, 186, 0, 21, 0, 0, 0, 21, 
	144, 0, 111, 0, 111, 147, 0, 174, 
	23, 0, 186, 7, 147, 0, 174, 23, 
	0, 186, 0, 0, 0, 144, 0, 21, 
	21, 0, 9, 9, 102, 73, 162, 9, 
	9, 174, 117, 0, 170, 0, 9, 9, 
	7, 102, 205, 0, 7, 9, 9, 174, 
	117, 0, 215, 0, 9, 9, 7, 102, 
	205, 0, 9, 9, 174, 117, 0, 215, 
	0, 9, 9, 7, 102, 205, 0, 9, 
	9, 174, 117, 0, 215, 11, 0, 108, 
	11, 210, 11, 0, 108, 11, 210, 11, 
	0, 108, 11, 210, 105, 105, 0, 158, 
	11, 195, 105, 105, 0, 158, 11, 232, 
	105, 105, 0, 158, 11, 232, 105, 105, 
	0, 158, 11, 232, 3, 3, 3, 0, 
	0, 87, 120, 3, 3, 190, 3, 3, 
	3, 0, 7, 87, 3, 3, 3, 190, 
	3, 3, 3, 190, 87, 200, 3, 3, 
	182, 3, 3, 3, 3, 3, 3, 3, 
	7, 0, 87, 3, 3, 3, 190, 3, 
	3, 3, 190, 87, 200, 3, 3, 3, 
	7, 7, 87, 3, 3, 3, 190, 3, 
	75, 3, 3, 190, 87, 200, 3, 3, 
	84, 99, 78, 78, 0, 0, 150, 154, 
	78, 78, 0, 7, 150, 154, 78, 78, 
	220, 226, 78, 78, 7, 0, 150, 154, 
	78, 78, 220, 226, 78, 78, 7, 7, 
	150, 154, 78, 78, 75, 220, 226, 99, 
	69, 0, 0, 0, 0, 0, 49, 0, 
	0, 0, 0, 13, 0, 15, 0, 17, 
	0, 0, 3, 3, 0, 0, 0, 0, 
	0, 0, 0, 3, 3, 0, 0, 0, 
	71, 0, 0, 0, 0, 19, 51, 19, 
	0, 0, 0, 0, 0, 1, 0, 0, 
	0, 0, 55, 0, 114, 0, 53, 0, 
	19, 3, 3, 81, 5, 0, 5, 93, 
	5, 0, 90, 5, 5, 0, 96, 0, 
	0, 0, 1, 25, 25, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 61, 59, 0, 0, 0, 
	174, 23, 0, 0, 11, 0, 108, 11, 
	166, 57, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 3, 3, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 3, 3, 0, 
	0, 35, 0, 33, 123, 31, 37, 135, 
	41, 0, 39, 126, 31, 43, 138, 47, 
	141, 45, 129, 0
};

static final short[] _hpricot_scan_to_state_actions = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 27, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 27, 0, 
	27, 0, 27, 0
};

static final short[] _hpricot_scan_from_state_actions = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 29, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 29, 0, 
	29, 0, 29, 0
};

static final int hpricot_scan_start = 204;

static final int hpricot_scan_error = -1;


public final static int BUFSIZE=16384;

private void rb_yield_tokens(IRubyObject sym, IRubyObject tag, IRubyObject attr, IRubyObject raw, boolean taint) {
  IRubyObject ary;
  if (sym == runtime.newSymbol("text")) {
    raw = tag;
  }
  ary = runtime.newArray(new IRubyObject[]{sym, tag, attr, raw});
  if (taint) { 
    ary.setTaint(true);
    tag.setTaint(true);
    attr.setTaint(true);
    raw.setTaint(true);
  }
  block.yield(runtime.getCurrentContext(), ary, null, null, false);
}


int cs, act, have = 0, nread = 0, curline = 1, p=-1;
boolean text = false;
int tokstart=-1, tokend;
char[] buf;
Ruby runtime;
IRubyObject attr, bufsize;
IRubyObject[] tag, akey, aval;
int mark_tag, mark_akey, mark_aval;
boolean done = false, ele_open = false;
int buffer_size = 0;        
boolean taint = false;
Block block = null;


IRubyObject xmldecl, doctype, procins, stag, etag, emptytag, comment,
      cdata, sym_text;

IRubyObject hpricot_scan(IRubyObject recv, IRubyObject port) {
  attr = bufsize = runtime.getNil();
  tag = new IRubyObject[]{runtime.getNil()};
  akey = new IRubyObject[]{runtime.getNil()};
  aval = new IRubyObject[]{runtime.getNil()};

  RubyClass rb_eHpricotParseError = runtime.getModule("Hpricot").getClass("ParseError");

  taint = port.isTaint();
  if ( !port.respondsTo("read")) {
    if ( port.respondsTo("to_str")) {
      port = port.callMethod(runtime.getCurrentContext(),"to_str");
    } else {
      throw runtime.newArgumentError("bad Hpricot argument, String or IO only please.");
    }
  }

  buffer_size = BUFSIZE;
  if (recv.getInstanceVariable("@buffer_size") != null) {
    bufsize = recv.getInstanceVariable("@buffer_size");
    if (!bufsize.isNil()) {
      buffer_size = RubyNumeric.fix2int(bufsize);
    }
  }
  buf = new char[buffer_size];

  
	{
	cs = hpricot_scan_start;
	tokstart = -1;
	tokend = -1;
	act = 0;
	}

  while( !done ) {
    IRubyObject str;
    p = have;
    int pe;
    int len, space = buffer_size - have;

    if ( space == 0 ) {
      /* We've used up the entire buffer storing an already-parsed token
       * prefix that must be preserved.  Likely caused by super-long attributes.
       * See ticket #13. */
      rb_raise(rb_eHpricotParseError, "ran out of buffer space on element <" + tag.toString() + ">, starting on line "+curline+".");
    }

    if (port.respondsTo("read")) {
      str = port.callMethod(runtime.getCurrentContext(),"read",runtime.newFixnum(space));
    } else {
      str = ((RubyString)port).substr(nread,space);
    }

    str = str.convertToString();
    String sss = str.toString();
    char[] chars = sss.toCharArray();
    System.arraycopy(chars,0,buf,p,chars.length);

    len = sss.length();
    nread += len;

    if ( len < space ) {
      len++;
      done = true;
    }

    pe = p + len;
    char[] data = buf;

    
	{
	int _klen;
	int _trans;
	int _acts;
	int _nacts;
	int _keys;

	if ( p != pe ) {
	_resume: while ( true ) {
	_again: do {
	_acts = _hpricot_scan_from_state_actions[cs];
	_nacts = (int) _hpricot_scan_actions[_acts++];
	while ( _nacts-- > 0 ) {
		switch ( _hpricot_scan_actions[_acts++] ) {
	case 21:
	{tokstart = p;}
	break;
		}
	}

	_match: do {
	_keys = _hpricot_scan_key_offsets[cs];
	_trans = _hpricot_scan_index_offsets[cs];
	_klen = _hpricot_scan_single_lengths[cs];
	if ( _klen > 0 ) {
		int _lower = _keys;
		int _mid;
		int _upper = _keys + _klen - 1;
		while (true) {
			if ( _upper < _lower )
				break;

			_mid = _lower + ((_upper-_lower) >> 1);
			if ( data[p] < _hpricot_scan_trans_keys[_mid] )
				_upper = _mid - 1;
			else if ( data[p] > _hpricot_scan_trans_keys[_mid] )
				_lower = _mid + 1;
			else {
				_trans += (_mid - _keys);
				break _match;
			}
		}
		_keys += _klen;
		_trans += _klen;
	}

	_klen = _hpricot_scan_range_lengths[cs];
	if ( _klen > 0 ) {
		int _lower = _keys;
		int _mid;
		int _upper = _keys + (_klen<<1) - 2;
		while (true) {
			if ( _upper < _lower )
				break;

			_mid = _lower + (((_upper-_lower) >> 1) & ~1);
			if ( data[p] < _hpricot_scan_trans_keys[_mid] )
				_upper = _mid - 2;
			else if ( data[p] > _hpricot_scan_trans_keys[_mid+1] )
				_lower = _mid + 2;
			else {
				_trans += ((_mid - _keys)>>1);
				break _match;
			}
		}
		_trans += _klen;
	}
	} while (false);

	_trans = _hpricot_scan_indicies[_trans];
	cs = _hpricot_scan_trans_targs_wi[_trans];

	if ( _hpricot_scan_trans_actions_wi[_trans] == 0 )
		break _again;

	_acts = _hpricot_scan_trans_actions_wi[_trans];
	_nacts = (int) _hpricot_scan_actions[_acts++];
	while ( _nacts-- > 0 )
	{
		switch ( _hpricot_scan_actions[_acts++] )
		{
	case 0:
	{
    if (text) {
      CAT(tag, p);
      ELE(sym_text);
      text = false;
    }
    attr = runtime.getNil();
    tag[0] = runtime.getNil();
    mark_tag = -1;
    ele_open = true;
  }
	break;
	case 1:
	{ mark_tag = p; }
	break;
	case 2:
	{ mark_aval = p; }
	break;
	case 3:
	{ mark_akey = p; }
	break;
	case 4:
	{ SET(tag, p); }
	break;
	case 5:
	{ SET(aval, p); }
	break;
	case 6:
	{ 
    if (buf[p-1] == '"' || buf[p-1] == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	break;
	case 7:
	{ SET(akey, p); }
	break;
	case 8:
	{ SET(aval, p); ATTR(rb_str_new2("version"), aval); }
	break;
	case 9:
	{ SET(aval, p); ATTR(rb_str_new2("encoding"), aval); }
	break;
	case 10:
	{ SET(aval, p); ATTR(rb_str_new2("standalone"), aval); }
	break;
	case 11:
	{ SET(aval, p); ATTR(rb_str_new2("public_id"), aval); }
	break;
	case 12:
	{ SET(aval, p); ATTR(rb_str_new2("system_id"), aval); }
	break;
	case 13:
	{ 
    akey[0] = runtime.getNil();
    aval[0] = runtime.getNil();
    mark_akey = -1;
    mark_aval = -1;
  }
	break;
	case 14:
	{ 
    ATTR(akey, aval);
  }
	break;
	case 15:
	{curline += 1;}
	break;
	case 16:
	{ TEXT_PASS(); }
	break;
	case 17:
	{ EBLK(comment, 3); {cs = 204; if (true) break _again;} }
	break;
	case 18:
	{ EBLK(cdata, 3); {cs = 204; if (true) break _again;} }
	break;
	case 19:
	{ EBLK(procins, 2); {cs = 204; if (true) break _again;} }
	break;
	case 22:
	{tokend = p+1;}
	break;
	case 23:
	{tokend = p+1;{p = ((tokend))-1;}}
	break;
	case 24:
	{tokend = p+1;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	break;
	case 25:
	{tokend = p;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	break;
	case 26:
	{{ TEXT_PASS(); }{p = ((tokend))-1;}}
	break;
	case 27:
	{tokend = p+1;{p = ((tokend))-1;}}
	break;
	case 28:
	{tokend = p+1;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	break;
	case 29:
	{tokend = p;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	break;
	case 30:
	{{ TEXT_PASS(); }{p = ((tokend))-1;}}
	break;
	case 31:
	{tokend = p+1;{p = ((tokend))-1;}}
	break;
	case 32:
	{tokend = p+1;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	break;
	case 33:
	{tokend = p;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	break;
	case 34:
	{act = 8;}
	break;
	case 35:
	{act = 10;}
	break;
	case 36:
	{act = 12;}
	break;
	case 37:
	{act = 15;}
	break;
	case 38:
	{tokend = p+1;{ ELE(xmldecl); }{p = ((tokend))-1;}}
	break;
	case 39:
	{tokend = p+1;{ ELE(doctype); }{p = ((tokend))-1;}}
	break;
	case 40:
	{tokend = p+1;{ ELE(stag); }{p = ((tokend))-1;}}
	break;
	case 41:
	{tokend = p+1;{ ELE(etag); }{p = ((tokend))-1;}}
	break;
	case 42:
	{tokend = p+1;{ ELE(emptytag); }{p = ((tokend))-1;}}
	break;
	case 43:
	{tokend = p+1;{ {{p = ((tokend))-1;}{cs = 214; if (true) break _again;}} }{p = ((tokend))-1;}}
	break;
	case 44:
	{tokend = p+1;{ {{p = ((tokend))-1;}{cs = 216; if (true) break _again;}} }{p = ((tokend))-1;}}
	break;
	case 45:
	{tokend = p+1;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	break;
	case 46:
	{tokend = p;{ {{p = ((tokend))-1;}{cs = 218; if (true) break _again;}} }{p = ((tokend))-1;}}
	break;
	case 47:
	{tokend = p;{ TEXT_PASS(); }{p = ((tokend))-1;}}
	break;
	case 48:
	{{ {{p = ((tokend))-1;}{cs = 218; if (true) break _again;}} }{p = ((tokend))-1;}}
	break;
	case 49:
	{{ TEXT_PASS(); }{p = ((tokend))-1;}}
	break;
	case 50:
	{	switch( act ) {
	case 8:
	{ ELE(doctype); }
	break;
	case 10:
	{ ELE(stag); }
	break;
	case 12:
	{ ELE(emptytag); }
	break;
	case 15:
	{ TEXT_PASS(); }
	break;
	default: break;
	}
	{p = ((tokend))-1;}}
	break;
		}
	}

	} while (false);
	_acts = _hpricot_scan_to_state_actions[cs];
	_nacts = (int) _hpricot_scan_actions[_acts++];
	while ( _nacts-- > 0 ) {
		switch ( _hpricot_scan_actions[_acts++] ) {
	case 20:
	{tokstart = -1;}
	break;
		}
	}

	if ( ++p == pe )
		break _resume;
	}
	}
	}
    
    if ( cs == hpricot_scan_error ) {
      if(!tag[0].isNil()) {
        rb_raise(rb_eHpricotParseError, "parse error on element <"+tag.toString()+">, starting on line "+curline+".\n" + NO_WAY_SERIOUSLY);
      } else {
        rb_raise(rb_eHpricotParseError, "parse error on line "+curline+".\n" + NO_WAY_SERIOUSLY);
      }
    }
    
    if ( done && ele_open ) {
      ele_open = false;
      if(tokstart > -1) {
        mark_tag = tokstart;
        tokstart = -1;
        text = true;
      }
    }

    if(tokstart == -1) {
      have = 0;
      /* text nodes have no tokstart because each byte is parsed alone */
      if(mark_tag != -1 && text) {
        if (done) {
          if(mark_tag < p-1) {
            CAT(tag, p-1);
            ELE(sym_text);
          }
        } else {
          CAT(tag, p);
        }
      }
      mark_tag = 0;
    } else {
      have = pe - tokstart;
      System.arraycopy(buf,tokstart,buf,0,have);
      SLIDE(tag);
      SLIDE(akey);
      SLIDE(aval);
      tokend = (tokend - tokstart);
      tokstart = 0;
    }
  }
  return runtime.getNil();
}

public static IRubyObject __hpricot_scan(IRubyObject recv, IRubyObject port, Block block) {
  Ruby runtime = recv.getRuntime();
  HpricotScanService service = new HpricotScanService();
  service.runtime = runtime;
  service.xmldecl = runtime.newSymbol("xmldecl");
  service.doctype = runtime.newSymbol("doctype");
  service.procins = runtime.newSymbol("procins");
  service.stag = runtime.newSymbol("stag");
  service.etag = runtime.newSymbol("etag");
  service.emptytag = runtime.newSymbol("emptytag");
  service.comment = runtime.newSymbol("comment");
  service.cdata = runtime.newSymbol("cdata");
  service.sym_text = runtime.newSymbol("text");
  service.block = block;
  return service.hpricot_scan(recv, port);
}


public boolean basicLoad(final Ruby runtime) throws IOException {
       Init_hpricot_scan(runtime);
       return true;
}

public static void Init_hpricot_scan(Ruby runtime) {
  RubyModule mHpricot = runtime.defineModule("Hpricot");
  mHpricot.getMetaClass().attr_accessor(new IRubyObject[]{runtime.newSymbol("buffer_size")});
  CallbackFactory fact = runtime.callbackFactory(HpricotScanService.class);
  mHpricot.getMetaClass().defineMethod("scan",fact.getSingletonMethod("__hpricot_scan",IRubyObject.class));
  mHpricot.defineClassUnder("ParseError",runtime.getClass("Exception"),runtime.getClass("Exception").getAllocator());
}
}
