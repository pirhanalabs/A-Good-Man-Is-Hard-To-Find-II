package ui.window;

import data.ItemStack;


/** *************************************
 * NOTES
 * idea to be able to add more than text:
 * instead of having a specified h2d.Text,
 * we can set an interface handling a graphical element (text, bitmap, etc)
 * and process it through it.
 * this interface would do the following:
 * -allow to be added to row visual
 * -process the shown data through fn
 * -updates itself
 ***************************************/

typedef ItemListColData = {
    name :h2d.Text,
    qt : h2d.Text
};





/**
 * window displaying a list of items of any size and listing any information you want.
 */
class ItemList<T> extends h2d.Object implements IItemListBuilder<T>{

    public static function create<T>():IItemListBuilder<T>{
        return new ItemList();
    }

    public function setLines(size:Int){
        if (initialized) return this;
        this.lines = size;
        return this;
    }

    public function setWidth(size:Int){
        if (initialized) return this;
        this.width = size;
        return this;
    }

    public function setTitle(name:String){
        if (initialized) return this;
        this.title = name;
        return this;
    }

    public function setCol(name:String, posx:Int, fn:Callback<T>){
        if (initialized) return this;
        if (fn == null)
            throw '`fn` cannot be null';

        cols.push({
            label:name,
            posx:posx,
            fn: fn,
        });
        return this;
    }

    public function setData(data:Array<T>){
        if (initialized) return this;
        this.data = data;
        return this;
    }

    public function setHoverCallback(fn:(item:T)->Void){
        if (initialized) return this;
        this.hoverCallback = fn;
        return this;
    }

    public function setSelectCallback(fn:(item:T)->Void){
        if (initialized) return this;
        this.selectCallback = fn;
        return this;
    }

    public function setSort(fn:(a:T, b:T)->Int){
        if (initialized) return this;
        this.sort = fn;
        return this;
    }

    public function ready(){
        if (initialized) return this;
        init();
        initialized = true;
        return this;
    }

    // data stuff
    var initialized = false;
    var title : String = "untitled";
    var width : Int = 200;
    var data : Array<T> = [];
    var lines : Int = 10;
    var hoverCallback:(item:T)->Void;
    var selectCallback:(item:T)->Void;
    var prevDataLength : Int = 0;

    var cols : Array<ColData<T>> = [];
    var rows : Array<RowData> = [];

    var lineIndexSelected = 0;
    var dataIndexOffset = 0;
    var dataIndex (get, never):Int; inline function get_dataIndex() return lineIndexSelected - dataIndexOffset;

    var scrollbarHeight (get, never):Float; inline function get_scrollbarHeight() return zoneRowsHeight / (data.length - lines);

    // paddings
    var padl = 8;
    var padr = 8;
    var padt = 8;
    var padb = 8;
    var padh (get, never):Int; inline function get_padh() return padl + padr;
    var padv (get, never):Int; inline function get_padv() return padt + padb;

    var zoneScrollbarArea = 10; // area reserved for scrollbar
    var zoneScrollbarWidth = 6; // width of scrollbar
    var zoneRowHeight = 14;
    var zoneTitleHeight = 20;
    var zoneHeaderHeight = 16;
    var zoneTopHeight (get, never):Int; inline function get_zoneTopHeight() return zoneTitleHeight + zoneHeaderHeight + padt;
    var zoneRowsHeight (get, never):Int; inline function get_zoneRowsHeight() return lines * zoneRowHeight;
    var zoneFullHeight (get, never):Int; inline function get_zoneFullHeight() return zoneTopHeight + zoneRowsHeight + padb;

    // visual stuff
    var background : h2d.ScaleGrid;
    var selection : h2d.Object;
    var scrollbar : h2d.Graphics;
    var scrollbarBackground : h2d.Object;

    var focused = true;
    var sort : (a:T, b:T)->Int;

    var dirty = true;

    private function new(){
        super();
    }

    private function init(){
        initBackground();
        initTitle();
        initHeader();
        initRows();
        initSelection();
        initRowColumns();
        initScrollbar();
    }

    private function initBackground(){
        this.background = new h2d.ScaleGrid(Assets.getMisc('bg_menubox'), padl, padt, padr, padb, this);
        this.background.width = width;
        this.background.height = zoneFullHeight;
    }

    private function initTitle(){
        var label_title = new h2d.Text(Assets.font_reg, this);
        label_title.text = title;
        label_title.x = width * 0.5;
        label_title.textAlign = Center;
        label_title.textColor = 0x000000;
        label_title.y = zoneTitleHeight * 0.5 + padt - label_title.textHeight;
    }

    private function initHeader(){
        var w = width-zoneScrollbarArea-padh;
        var headerbar = new h2d.Bitmap(h2d.Tile.fromColor(0xaaaaaa, w, zoneHeaderHeight, 1),this);
        headerbar.x = padl;
        headerbar.y = padt + zoneTitleHeight;
        for (col in cols){
            var label_header = new h2d.Text(Assets.font_reg, headerbar);
            label_header.x = col.posx;
            label_header.text = col.label;
            label_header.textColor = 0x000000;
        }
    }

    private function initRows(){
        var rowbg = new h2d.Graphics(this);
        rowbg.x = padl;
        rowbg.y = zoneTopHeight;
        for (i in 0 ... lines){
            rowbg.beginFill(i % 2 == 0 ? 0xffffff : 0xeeeeee, 1);
            rowbg.drawRect(0, i * zoneRowHeight, width-zoneScrollbarArea-padh, zoneRowHeight);
        }
    }

    private function initSelection(){
        var g = new h2d.Graphics(this);
        g.beginFill(0xfee761, 1);
        g.drawRect(0, 0, width-zoneScrollbarArea-padh, zoneRowHeight);
        g.endFill();
        selection = g;
        selection.x = padl;
        selection.y = zoneTopHeight;
    }

    private function initRowColumns(){
        for (row in 0 ... lines){
            var rowdata = [];
            for (col in cols){
                var label = new h2d.Text(Assets.font_reg, this);
                label.textColor = 0x000000;
                label.text = row < data.length ? col.fn(data[row]) : '';
                label.x = padl + col.posx;
                label.y = row * zoneRowHeight + zoneTopHeight;
                label.visible = row < data.length;
                rowdata.push(label);
            }
            rows.push(rowdata);
        }
    }

    private function initScrollbar(){
        var bg = new h2d.Graphics(this);
        bg.beginFill(0xdddddd, 1);
        bg.drawRoundedRect(0, 0, zoneScrollbarWidth, zoneRowsHeight, 2, 5);
        bg.endFill();
        bg.x = width - zoneScrollbarArea - zoneScrollbarWidth * 0.5;
        bg.y = zoneTopHeight;
        scrollbarBackground = bg;
        drawScrollbar();
    }

    private function drawScrollbar(){
        if (scrollbar == null)
            scrollbar = new h2d.Graphics(scrollbarBackground);
        scrollbar.clear();
        scrollbar.beginFill(0xaaaaaa, 1);
        scrollbar.drawRoundedRect(0, 0, zoneScrollbarWidth, scrollbarHeight, 2, 5);
        scrollbar.endFill();
    }

    public function prev(){
        di(-1);
    }

    public function next(){
        di(1);
    }

    private function di(val:Int){
        var prev = dataIndexOffset + lineIndexSelected;
        lineIndexSelected+=val;
        if (lineIndexSelected < 0){
            if (dataIndexOffset > 0){
                dataIndexOffset--;
            }
            lineIndexSelected = 0;
        }
        if (lineIndexSelected >= lines){
            if (dataIndexOffset+lineIndexSelected < data.length-1){
                dataIndexOffset++;
            }
            lineIndexSelected = lines-1;
        }
        if (prev != dataIndexOffset + lineIndexSelected){
            callhover();
        }
        dirty = true;
    }

    private function updateRows(){
        for (i in 0 ... lines){
            var index = i + dataIndexOffset;
            var item = index < data.length ? data[index] : null;
            var row = rows[i];
            for (j in 0 ... row.length){
                var col = cols[j];
                var label = row[j];
                label.visible = true;
                if (item == null){
                    label.visible = false;
                }else{
                    label.text = col.fn(item);
                }
            }
        }
    }

    public function focus(){
        this.focused = true;
    }

    public function unfocus(){
        this.focused = false;
    }

    public function select(){
        if (selectCallback != null  && lineIndexSelected + dataIndexOffset < data.length){
            selectCallback(data[lineIndexSelected + dataIndexOffset]);
        }
    }

    private function callhover(){
        if (focused && hoverCallback != null && lineIndexSelected + dataIndexOffset < data.length){
            hoverCallback(data[lineIndexSelected + dataIndexOffset]);
        }
    }

    public function update(dt:Float){
        if (data.length != prevDataLength){
            selection.visible = true;
            if (dataIndexOffset != 0){
                dataIndexOffset += data.length - prevDataLength;
            }else if (lineIndexSelected != 0){
                lineIndexSelected--;
            }else if (data.length == 0){
                selection.visible = false;
            }
            if (sort != null){
                data.sort(sort);
            }
            callhover();
            prevDataLength = data.length;
            dirty = true;
        }
        if (dirty){
            dirty = false;
            updateRows();
            drawScrollbar();
        }

        selection.y = zoneTopHeight + lineIndexSelected * zoneRowHeight;
        selection.visible = focused;

        var targety = dataIndexOffset * scrollbarHeight;
        if (scrollbar.y != targety){
            scrollbar.y += (targety - scrollbar.y) * 0.2;
        }
    }
}

/**
 * used to force construction of ItemList before usage.
 * mainly used so I dont forget to do things properly.
 * call ready when all the information you want to set are correct.
 */
 interface IItemListBuilder<T>{
    public function setWidth(size:Int):IItemListBuilder<T>;
    public function setLines(size:Int):IItemListBuilder<T>;
    public function setTitle(name:String):IItemListBuilder<T>;
    public function setCol(name:String, posx:Int, fn:Callback<T>):IItemListBuilder<T>;
    public function setData(data:Array<T>):IItemListBuilder<T>;
    public function setHoverCallback(fn:(item:T)->Void):IItemListBuilder<T>;
    public function setSelectCallback(fn:(item:T)->Void):IItemListBuilder<T>;
    public function setSort(fn:(a:T, b:T)->Int):IItemListBuilder<T>;
    public function ready():ItemList<T>;
}

typedef Callback<T> = (item:T)->String;
typedef RowData = Array<h2d.Text>;

/**
 * information about a single column.
 */
typedef ColData<T> = {
    label : String,
    posx : Int,
    fn:Callback<T>,
}