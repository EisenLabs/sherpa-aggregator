#[macro_use]
use lazy_static::lazy_static;
use ethers::types::U256;

lazy_static! {
    pub static ref RESOL96: u8 = 96;
    pub static ref AMUL: U256 = U256::exp10(4);
    pub static ref Q48: U256 = U256::from("0x1000000000000");
    pub static ref Q96: U256 = U256::from("0x1000000000000000000000000");
    pub static ref Q128: U256 = U256::from("0x100000000000000000000000000000000");
    pub static ref Q144: U256 = U256::from("0x1000000000000000000000000000000000000");

    pub static ref MAX_64:U256=U256::from("0xFFFFFFFFFFFFFFFF");
    pub static ref MAX_96:U256=U256::from("0xFFFFFFFFFFFFFFFFFFFFFFFF");
    pub static ref MAX_U128:U256=U256::from("0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
    pub static ref MAX_U208:U256=U256::from("0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");


    pub static ref MAX_INT24:i32=0x7FFFFF;
    pub static ref MIN_INT24:i32=-0x800000;

    pub static ref AMBIENT_MIN_TICK: i32 = -665454;
    pub static ref AMBIENT_MAX_TICK: i32 = 831818;
    pub static ref AMBIENT_FEE_BP_MULT: U256 = U256::from(1000000);
    pub static ref AMBIENT_MIN_SQRT_RATIO: U256 = U256::from("0x10002"); // 65538
    pub static ref AMBIENT_MAX_SQRT_RATIO: U256 = U256::from("0xFFFF5433E2B3D8211706E6102AA9472"); // 21267430153580247136652501917186561138
    pub static ref MIN_SQRT_RATIO: U256 = U256::from("0x1000276A3"); //4295128739
    pub static ref MAX_SQRT_RATIO: U256 = U256::from("0xFFFD8963EFD1FC6A506488495D951D5263988D26"); //1461446703485210103287273052203988822378723970342
    pub static ref MAX_SYNC_LP: U256 = U256::from("0x3802571709128108338056982581425910818");
    pub static ref MIN_POINT: i32 = -800000;
    pub static ref MAX_POINT: i32 = 800000;
    pub static ref MIN_TICK: i64 = -887272;
    pub static ref MAX_TICK: i64 = 887272;
    pub static ref ONE18: U256 = U256::exp10(18);
    pub static ref ONE20: U256 = U256::exp10(20);
    pub static ref ONE36: U256 = U256::exp10(36);
    pub static ref RAY: U256 = U256::exp10(27);
    pub static ref HALFRAY: U256 = U256::from(5)*U256::exp10(26);
    // Joe
    pub static ref JOE_SCALE_OFFSET:u8 = 128;
    pub static ref JOE_SCALE:U256 = U256::one()<<U256::from(128);
    pub static ref JOE_PRECISION: U256= U256::exp10(18);
    pub static ref JOE_BASIS_POINT_MAX: U256 = U256::from(10000);
    pub static ref JOE_REAL_ID_SHIFT: U256 = U256::exp10(23);
    // ALGEBRA
    pub static ref ALGEBRA_WINDOW: u32 = 86400;
    pub static ref ALGEBRA_UINT16_MODULO:U256=U256::from(65536);
    pub static ref ALGEBRA_MAX_LIQUIDITY_PER_TICK: U256 = U256::from("23746E6A58DCB13D4AF821B93F062"); // max(uint128) / ( (MAX_TICK - MIN_TICK) / TICK_SPACING(=60) )
    pub static ref ALGEBRA_FEE_DOMINATOR:U256=U256::exp10(6);
    pub static ref ALGEBRA_SECOND_LAYER_OFFSET: i16 = 3466; // ceil(MAX_TICK / 256)
    pub static ref ALGEBRA_RESOLUTION: u8 = 96;
    pub static ref ALGEBRA_COMMUNITY_FEE_DENOMINATOR: U256 = U256::exp10(3);
    // KYBER
    pub static ref KYBER_TWO_FEE_UNITS: U256 = U256::from(200000);
    pub static ref KYBER_FEE_UNITS: U256 = U256::exp10(5);
    pub static ref KYBER_MAX_TICK_DISTANCE: i32 = 480_i32;
}
