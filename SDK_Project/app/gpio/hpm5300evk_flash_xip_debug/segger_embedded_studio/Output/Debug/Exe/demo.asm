
Output/Debug/Exe/demo.elf:     file format elf32-littleriscv


Disassembly of section .init._start:

80003000 <_start>:
#define L(label) .L_start_##label

START_FUNC _start
        .option push
        .option norelax
        lui     gp,     %hi(__global_pointer$)
80003000:	800041b7          	lui	gp,0x80004
        addi    gp, gp, %lo(__global_pointer$)
80003004:	89018193          	addi	gp,gp,-1904 # 80003890 <__global_pointer$>
        lui     tp,     %hi(__thread_pointer$)
80003008:	80009237          	lui	tp,0x80009
        addi    tp, tp, %lo(__thread_pointer$)
8000300c:	9a220213          	addi	tp,tp,-1630 # 800089a2 <__thread_pointer$>
        .option pop

        csrw    mstatus, zero
80003010:	30001073          	csrw	mstatus,zero
        csrw    mcause, zero
80003014:	34201073          	csrw	mcause,zero
    la t0, _stack_safe
    mv sp, t0
    call _init_ext_ram
#endif

        lui     t0,     %hi(__stack_end__)
80003018:	000a02b7          	lui	t0,0xa0
        addi    sp, t0, %lo(__stack_end__)
8000301c:	00028113          	mv	sp,t0

#ifdef CONFIG_NOT_ENABLE_ICACHE
        call    l1c_ic_disable
#else
        call    l1c_ic_enable
80003020:	030010ef          	jal	80004050 <l1c_ic_enable>
#endif
#ifdef CONFIG_NOT_ENABLE_DCACHE
        call    l1c_dc_invalidate_all
        call    l1c_dc_disable
#else
        call    l1c_dc_enable
80003024:	7f9000ef          	jal	8000401c <l1c_dc_enable>
        call    l1c_dc_invalidate_all
80003028:	792030ef          	jal	800067ba <l1c_dc_invalidate_all>

#ifndef __NO_SYSTEM_INIT
        //
        // Call _init
        //
        call    _init
8000302c:	21c030ef          	jal	80006248 <_init>

80003030 <.Lpcrel_hi0>:
        // Call linker init functions which in turn performs the following:
        // * Perform segment init
        // * Perform heap init (if used)
        // * Call constructors of global Objects (if any exist)
        //
        la      s0, __SEGGER_init_table__       // Set table pointer to start of initialization table
80003030:	80008437          	lui	s0,0x80008
80003034:	3a840413          	addi	s0,s0,936 # 800083a8 <__SEGGER_RTL_ascii_ctype_map+0x80>

80003038 <.L_start_RunInit>:
L(RunInit):
        lw      a0, (s0)                        // Get next initialization function from table
80003038:	4008                	lw	a0,0(s0)
        add     s0, s0, 4                       // Increment table pointer to point to function arguments
8000303a:	0411                	addi	s0,s0,4
        jalr    a0                              // Call initialization function
8000303c:	9502                	jalr	a0
        j       L(RunInit)
8000303e:	bfed                	j	80003038 <.L_start_RunInit>

80003040 <__SEGGER_init_done>:
        // Time to call main(), the application entry point.
        //

#ifndef NO_CLEANUP_AT_START
    /* clean up */
    call _clean_up
80003040:	221000ef          	jal	80003a60 <_clean_up>

80003044 <.Lpcrel_hi1>:
    #define HANDLER_S_TRAP irq_handler_s_trap
#endif

#if !defined(USE_NONVECTOR_MODE) || (USE_NONVECTOR_MODE == 0)
    /* Initial machine trap-vector Base */
    la t0, __vector_table
80003044:	000002b7          	lui	t0,0x0
80003048:	00028293          	mv	t0,t0
    csrw mtvec, t0
8000304c:	30529073          	csrw	mtvec,t0

    /* Enable vectored external PLIC interrupt */
    csrsi CSR_MMISC_CTL, 2
80003050:	7d016073          	csrsi	0x7d0,2

80003054 <start>:
        //
        // In a real embedded application ("Free-standing environment"),
        // main() does not get any arguments,
        // which means it is not necessary to init a0 and a1.
        //
        call    APP_ENTRY_POINT
80003054:	1dc030ef          	jal	80006230 <reset_handler>
        tail    exit
80003058:	a009                	j	8000305a <exit>

8000305a <exit>:
MARK_FUNC exit
        //
        // In a free-standing environment, if returned from application:
        // Loop forever.
        //
        j       .
8000305a:	a001                	j	8000305a <exit>
        la      a1, args
        call    debug_getargs
        li      a0, ARGSSPACE
        la      a1, args
#else
        li      a0, 0
8000305c:	4501                	li	a0,0
        li      a1, 0
8000305e:	4581                	li	a1,0
#endif

        call    APP_ENTRY_POINT
80003060:	1d0030ef          	jal	80006230 <reset_handler>
        tail    exit
80003064:	bfdd                	j	8000305a <exit>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_DFL:

80003066 <__SEGGER_RTL_SIGNAL_SIG_DFL>:
80003066:	8082                	ret

Disassembly of section .text.gpio_toggle_pin:

800038b2 <gpio_toggle_pin>:
 * @param ptr GPIO base address
 * @param port Port index
 * @param pin Pin index
 */
static inline void gpio_toggle_pin(GPIO_Type *ptr, uint32_t port, uint8_t pin)
{
800038b2:	1141                	addi	sp,sp,-16
800038b4:	c62a                	sw	a0,12(sp)
800038b6:	c42e                	sw	a1,8(sp)
800038b8:	87b2                	mv	a5,a2
800038ba:	00f103a3          	sb	a5,7(sp)
    ptr->DO[port].TOGGLE = 1 << pin;
800038be:	00714783          	lbu	a5,7(sp)
800038c2:	4705                	li	a4,1
800038c4:	00f717b3          	sll	a5,a4,a5
800038c8:	86be                	mv	a3,a5
800038ca:	4732                	lw	a4,12(sp)
800038cc:	47a2                	lw	a5,8(sp)
800038ce:	07c1                	addi	a5,a5,16
800038d0:	0792                	slli	a5,a5,0x4
800038d2:	97ba                	add	a5,a5,a4
800038d4:	c7d4                	sw	a3,12(a5)
}
800038d6:	0001                	nop
800038d8:	0141                	addi	sp,sp,16
800038da:	8082                	ret

Disassembly of section .text.gpio_write_pin:

800038de <gpio_write_pin>:
 * @param port Port index
 * @param pin Pin index
 * @param high Pin level set to high when it is set to true
 */
static inline void gpio_write_pin(GPIO_Type *ptr, uint32_t port, uint8_t pin, uint8_t high)
{
800038de:	1141                	addi	sp,sp,-16
800038e0:	c62a                	sw	a0,12(sp)
800038e2:	c42e                	sw	a1,8(sp)
800038e4:	87b2                	mv	a5,a2
800038e6:	8736                	mv	a4,a3
800038e8:	00f103a3          	sb	a5,7(sp)
800038ec:	87ba                	mv	a5,a4
800038ee:	00f10323          	sb	a5,6(sp)
    if (high) {
800038f2:	00614783          	lbu	a5,6(sp)
800038f6:	cf91                	beqz	a5,80003912 <.L3>
        ptr->DO[port].SET = 1 << pin;
800038f8:	00714783          	lbu	a5,7(sp)
800038fc:	4705                	li	a4,1
800038fe:	00f717b3          	sll	a5,a4,a5
80003902:	86be                	mv	a3,a5
80003904:	4732                	lw	a4,12(sp)
80003906:	47a2                	lw	a5,8(sp)
80003908:	07c1                	addi	a5,a5,16
8000390a:	0792                	slli	a5,a5,0x4
8000390c:	97ba                	add	a5,a5,a4
8000390e:	c3d4                	sw	a3,4(a5)
    } else {
        ptr->DO[port].CLEAR = 1 << pin;
    }
}
80003910:	a829                	j	8000392a <.L5>

80003912 <.L3>:
        ptr->DO[port].CLEAR = 1 << pin;
80003912:	00714783          	lbu	a5,7(sp)
80003916:	4705                	li	a4,1
80003918:	00f717b3          	sll	a5,a4,a5
8000391c:	86be                	mv	a3,a5
8000391e:	4732                	lw	a4,12(sp)
80003920:	47a2                	lw	a5,8(sp)
80003922:	07c1                	addi	a5,a5,16
80003924:	0792                	slli	a5,a5,0x4
80003926:	97ba                	add	a5,a5,a4
80003928:	c794                	sw	a3,8(a5)

8000392a <.L5>:
}
8000392a:	0001                	nop
8000392c:	0141                	addi	sp,sp,16
8000392e:	8082                	ret

Disassembly of section .text.test_gpio_toggle_output:

80003932 <test_gpio_toggle_output>:
    }
}

#ifdef BOARD_LED_GPIO_CTRL
void test_gpio_toggle_output(void)
{
80003932:	1101                	addi	sp,sp,-32
80003934:	ce06                	sw	ra,28(sp)
    printf("toggling led %u times in total\n", GPIO_TOGGLE_COUNT);
80003936:	4595                	li	a1,5
80003938:	fd818513          	addi	a0,gp,-40 # 80003868 <.LC3>
8000393c:	0cb010ef          	jal	80005206 <printf>
    gpio_set_pin_output(BOARD_LED_GPIO_CTRL, BOARD_LED_GPIO_INDEX,
80003940:	465d                	li	a2,23
80003942:	4581                	li	a1,0
80003944:	f00d0537          	lui	a0,0xf00d0
80003948:	796020ef          	jal	800060de <gpio_set_pin_output>
                           BOARD_LED_GPIO_PIN);
    gpio_write_pin(BOARD_LED_GPIO_CTRL, BOARD_LED_GPIO_INDEX,
8000394c:	221000ef          	jal	8000436c <board_get_led_gpio_off_level>
80003950:	87aa                	mv	a5,a0
80003952:	86be                	mv	a3,a5
80003954:	465d                	li	a2,23
80003956:	4581                	li	a1,0
80003958:	f00d0537          	lui	a0,0xf00d0
8000395c:	3749                	jal	800038de <gpio_write_pin>

8000395e <.LBB22>:
                        BOARD_LED_GPIO_PIN, board_get_led_gpio_off_level());

    for (uint32_t i = 0; i < GPIO_TOGGLE_COUNT; i++) {
8000395e:	c602                	sw	zero,12(sp)
80003960:	a835                	j	8000399c <.L15>

80003962 <.L16>:
        gpio_toggle_pin(BOARD_LED_GPIO_CTRL, BOARD_LED_GPIO_INDEX,
80003962:	465d                	li	a2,23
80003964:	4581                	li	a1,0
80003966:	f00d0537          	lui	a0,0xf00d0
8000396a:	37a1                	jal	800038b2 <gpio_toggle_pin>
                            BOARD_LED_GPIO_PIN);
        board_delay_ms(500);
8000396c:	1f400513          	li	a0,500
80003970:	11a030ef          	jal	80006a8a <board_delay_ms>
        gpio_toggle_pin(BOARD_LED_GPIO_CTRL, BOARD_LED_GPIO_INDEX,
80003974:	465d                	li	a2,23
80003976:	4581                	li	a1,0
80003978:	f00d0537          	lui	a0,0xf00d0
8000397c:	3f1d                	jal	800038b2 <gpio_toggle_pin>
                            BOARD_LED_GPIO_PIN);
        board_delay_ms(500);
8000397e:	1f400513          	li	a0,500
80003982:	108030ef          	jal	80006a8a <board_delay_ms>
        printf("toggling led %u/%u times\n", i + 1, GPIO_TOGGLE_COUNT);
80003986:	47b2                	lw	a5,12(sp)
80003988:	0785                	addi	a5,a5,1
8000398a:	4615                	li	a2,5
8000398c:	85be                	mv	a1,a5
8000398e:	ff818513          	addi	a0,gp,-8 # 80003888 <.LC4>
80003992:	075010ef          	jal	80005206 <printf>
    for (uint32_t i = 0; i < GPIO_TOGGLE_COUNT; i++) {
80003996:	47b2                	lw	a5,12(sp)
80003998:	0785                	addi	a5,a5,1
8000399a:	c63e                	sw	a5,12(sp)

8000399c <.L15>:
8000399c:	4732                	lw	a4,12(sp)
8000399e:	4791                	li	a5,4
800039a0:	fce7f1e3          	bgeu	a5,a4,80003962 <.L16>

800039a4 <.LBE22>:
    }
}
800039a4:	0001                	nop
800039a6:	0001                	nop
800039a8:	40f2                	lw	ra,28(sp)
800039aa:	6105                	addi	sp,sp,32
800039ac:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_ERR:

800039ae <__SEGGER_RTL_SIGNAL_SIG_ERR>:
800039ae:	8082                	ret

Disassembly of section .text.main:

80003a44 <main>:
#endif

int main(void)
{
80003a44:	1141                	addi	sp,sp,-16
80003a46:	c606                	sw	ra,12(sp)
    board_init();
80003a48:	705020ef          	jal	8000694c <board_init>
    board_init_gpio_pins();
80003a4c:	052030ef          	jal	80006a9e <board_init_gpio_pins>
    printf("gpio example\n");
80003a50:	01418513          	addi	a0,gp,20 # 800038a4 <.LC5>
80003a54:	7b2010ef          	jal	80005206 <printf>
    mchtmr_freq = clock_get_frequency(MCHTMR_CLK_NAME);
    debounce_threshold = DEBOUNCE_THRESHOLD_IN_MS * mchtmr_freq / 1000;
#endif

#ifdef BOARD_LED_GPIO_CTRL
    test_gpio_toggle_output();
80003a58:	3de9                	jal	80003932 <test_gpio_toggle_output>
#endif
    test_gpio_input_interrupt();
80003a5a:	708020ef          	jal	80006162 <test_gpio_input_interrupt>

80003a5e <.L18>:

    while (1);
80003a5e:	a001                	j	80003a5e <.L18>

Disassembly of section .text._clean_up:

80003a60 <_clean_up>:
#define MAIN_ENTRY main
#endif
extern int MAIN_ENTRY(void);

__attribute__((weak)) void _clean_up(void)
{
80003a60:	7139                	addi	sp,sp,-64

80003a62 <.LBB18>:
 * @brief   Disable IRQ from interrupt controller
 *
 */
ATTR_ALWAYS_INLINE static inline void disable_irq_from_intc(void)
{
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80003a62:	28b01793          	bseti	a5,zero,0xb
80003a66:	3047b073          	csrc	mie,a5
}
80003a6a:	0001                	nop
80003a6c:	da02                	sw	zero,52(sp)
80003a6e:	d802                	sw	zero,48(sp)
80003a70:	e40007b7          	lui	a5,0xe4000
80003a74:	d63e                	sw	a5,44(sp)
80003a76:	57d2                	lw	a5,52(sp)
80003a78:	d43e                	sw	a5,40(sp)
80003a7a:	57c2                	lw	a5,48(sp)
80003a7c:	d23e                	sw	a5,36(sp)

80003a7e <.LBB20>:
                                                           uint32_t target,
                                                           uint32_t threshold)
{
    volatile uint32_t *threshold_ptr = (volatile uint32_t *) (base +
                                                              HPM_PLIC_THRESHOLD_OFFSET +
                                                              (target << HPM_PLIC_THRESHOLD_SHIFT_PER_TARGET));
80003a7e:	57a2                	lw	a5,40(sp)
80003a80:	00c79713          	slli	a4,a5,0xc
                                                              HPM_PLIC_THRESHOLD_OFFSET +
80003a84:	57b2                	lw	a5,44(sp)
80003a86:	973e                	add	a4,a4,a5
80003a88:	002007b7          	lui	a5,0x200
80003a8c:	97ba                	add	a5,a5,a4
    volatile uint32_t *threshold_ptr = (volatile uint32_t *) (base +
80003a8e:	d03e                	sw	a5,32(sp)
    *threshold_ptr = threshold;
80003a90:	5782                	lw	a5,32(sp)
80003a92:	5712                	lw	a4,36(sp)
80003a94:	c398                	sw	a4,0(a5)
}
80003a96:	0001                	nop

80003a98 <.LBE22>:
 * @param[in] threshold Threshold of IRQ can be serviced
 */
ATTR_ALWAYS_INLINE static inline void intc_set_threshold(uint32_t target, uint32_t threshold)
{
    __plic_set_threshold(HPM_PLIC_BASE, target, threshold);
}
80003a98:	0001                	nop

80003a9a <.LBB24>:
    /* clean up plic, it will help while debugging */
    disable_irq_from_intc();
    intc_m_set_threshold(0);
    for (uint32_t irq = 0; irq < 128; irq++) {
80003a9a:	de02                	sw	zero,60(sp)
80003a9c:	a82d                	j	80003ad6 <.L2>

80003a9e <.L3>:
80003a9e:	ce02                	sw	zero,28(sp)
80003aa0:	57f2                	lw	a5,60(sp)
80003aa2:	cc3e                	sw	a5,24(sp)
80003aa4:	e40007b7          	lui	a5,0xe4000
80003aa8:	ca3e                	sw	a5,20(sp)
80003aaa:	47f2                	lw	a5,28(sp)
80003aac:	c83e                	sw	a5,16(sp)
80003aae:	47e2                	lw	a5,24(sp)
80003ab0:	c63e                	sw	a5,12(sp)

80003ab2 <.LBB25>:
                                                          uint32_t target,
                                                          uint32_t irq)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *) (base +
                                                           HPM_PLIC_CLAIM_OFFSET +
                                                           (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
80003ab2:	47c2                	lw	a5,16(sp)
80003ab4:	00c79713          	slli	a4,a5,0xc
                                                           HPM_PLIC_CLAIM_OFFSET +
80003ab8:	47d2                	lw	a5,20(sp)
80003aba:	973e                	add	a4,a4,a5
80003abc:	002007b7          	lui	a5,0x200
80003ac0:	0791                	addi	a5,a5,4 # 200004 <_flash_size+0x100004>
80003ac2:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *) (base +
80003ac4:	c43e                	sw	a5,8(sp)
    *claim_addr = irq;
80003ac6:	47a2                	lw	a5,8(sp)
80003ac8:	4732                	lw	a4,12(sp)
80003aca:	c398                	sw	a4,0(a5)
}
80003acc:	0001                	nop

80003ace <.LBE27>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_complete_irq(uint32_t target, uint32_t irq)
{
    __plic_complete_irq(HPM_PLIC_BASE, target, irq);
}
80003ace:	0001                	nop

80003ad0 <.LBE25>:
80003ad0:	57f2                	lw	a5,60(sp)
80003ad2:	0785                	addi	a5,a5,1
80003ad4:	de3e                	sw	a5,60(sp)

80003ad6 <.L2>:
80003ad6:	5772                	lw	a4,60(sp)
80003ad8:	07f00793          	li	a5,127
80003adc:	fce7f1e3          	bgeu	a5,a4,80003a9e <.L3>

80003ae0 <.LBB29>:
        intc_m_complete_irq(irq);
    }
    /* clear any bits left in plic enable register */
    for (uint32_t i = 0; i < 4; i++) {
80003ae0:	dc02                	sw	zero,56(sp)
80003ae2:	a821                	j	80003afa <.L4>

80003ae4 <.L5>:
        *(volatile uint32_t *)(HPM_PLIC_BASE + HPM_PLIC_ENABLE_OFFSET + (i << 2)) = 0;
80003ae4:	57e2                	lw	a5,56(sp)
80003ae6:	00279713          	slli	a4,a5,0x2
80003aea:	e40027b7          	lui	a5,0xe4002
80003aee:	97ba                	add	a5,a5,a4
80003af0:	0007a023          	sw	zero,0(a5) # e4002000 <__FLASH_segment_end__+0x63f02000>
    for (uint32_t i = 0; i < 4; i++) {
80003af4:	57e2                	lw	a5,56(sp)
80003af6:	0785                	addi	a5,a5,1
80003af8:	dc3e                	sw	a5,56(sp)

80003afa <.L4>:
80003afa:	5762                	lw	a4,56(sp)
80003afc:	478d                	li	a5,3
80003afe:	fee7f3e3          	bgeu	a5,a4,80003ae4 <.L5>

80003b02 <.LBE29>:
    }
}
80003b02:	0001                	nop
80003b04:	0001                	nop
80003b06:	6121                	addi	sp,sp,64
80003b08:	8082                	ret

Disassembly of section .text.syscall_handler:

80003b0a <syscall_handler>:
__attribute__((weak)) void swi_isr(void)
{
}

__attribute__((weak)) void syscall_handler(long n, long a0, long a1, long a2, long a3)
{
80003b0a:	1101                	addi	sp,sp,-32
80003b0c:	ce2a                	sw	a0,28(sp)
80003b0e:	cc2e                	sw	a1,24(sp)
80003b10:	ca32                	sw	a2,20(sp)
80003b12:	c836                	sw	a3,16(sp)
80003b14:	c63a                	sw	a4,12(sp)
    (void) n;
    (void) a0;
    (void) a1;
    (void) a2;
    (void) a3;
}
80003b16:	0001                	nop
80003b18:	6105                	addi	sp,sp,32
80003b1a:	8082                	ret

Disassembly of section .text.system_init:

80003b1c <system_init>:
#endif
    __plic_set_feature(HPM_PLIC_BASE, plic_feature);
}

__attribute__((weak)) void system_init(void)
{
80003b1c:	7179                	addi	sp,sp,-48
80003b1e:	d606                	sw	ra,44(sp)

80003b20 <.LBB16>:
#ifndef CONFIG_NOT_ENALBE_ACCESS_TO_CYCLE_CSR
    uint32_t mcounteren = read_csr(CSR_MCOUNTEREN);
80003b20:	306027f3          	csrr	a5,mcounteren
80003b24:	ce3e                	sw	a5,28(sp)
80003b26:	47f2                	lw	a5,28(sp)

80003b28 <.LBE16>:
80003b28:	cc3e                	sw	a5,24(sp)
    write_csr(CSR_MCOUNTEREN, mcounteren | 1); /* Enable MCYCLE */
80003b2a:	47e2                	lw	a5,24(sp)
80003b2c:	0017e793          	ori	a5,a5,1
80003b30:	30679073          	csrw	mcounteren,a5
80003b34:	47a1                	li	a5,8
80003b36:	c83e                	sw	a5,16(sp)

80003b38 <.LBB17>:
    return read_clear_csr(CSR_MSTATUS, mask);
80003b38:	c602                	sw	zero,12(sp)
80003b3a:	47c2                	lw	a5,16(sp)
80003b3c:	3007b7f3          	csrrc	a5,mstatus,a5
80003b40:	c63e                	sw	a5,12(sp)
80003b42:	47b2                	lw	a5,12(sp)

80003b44 <.LBE19>:
80003b44:	0001                	nop

80003b46 <.LBB20>:
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80003b46:	28b01793          	bseti	a5,zero,0xb
80003b4a:	3047b073          	csrc	mie,a5
}
80003b4e:	0001                	nop

80003b50 <.LBE20>:
#endif

    disable_global_irq(CSR_MSTATUS_MIE_MASK);
    disable_irq_from_intc();

    enable_plic_feature();
80003b50:	72c020ef          	jal	8000627c <enable_plic_feature>

80003b54 <.LBB22>:
    set_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80003b54:	28b01793          	bseti	a5,zero,0xb
80003b58:	3047a073          	csrs	mie,a5
}
80003b5c:	0001                	nop
80003b5e:	47a1                	li	a5,8
80003b60:	ca3e                	sw	a5,20(sp)

80003b62 <.LBB24>:
    set_csr(CSR_MSTATUS, mask);
80003b62:	47d2                	lw	a5,20(sp)
80003b64:	3007a073          	csrs	mstatus,a5
}
80003b68:	0001                	nop

80003b6a <.LBE24>:
    enable_irq_from_intc();

#if !CONFIG_DISABLE_GLOBAL_IRQ_ON_STARTUP
    enable_global_irq(CSR_MSTATUS_MIE_MASK);
#endif
}
80003b6a:	0001                	nop
80003b6c:	50b2                	lw	ra,44(sp)
80003b6e:	6145                	addi	sp,sp,48
80003b70:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

80003b72 <sysctl_resource_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] resource target resource index
 * @return true if target resource is busy
 */
static inline bool sysctl_resource_target_is_busy(SYSCTL_Type *ptr, sysctl_resource_t resource)
{
80003b72:	1141                	addi	sp,sp,-16
80003b74:	c62a                	sw	a0,12(sp)
80003b76:	87ae                	mv	a5,a1
80003b78:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
80003b7c:	00a15783          	lhu	a5,10(sp)
80003b80:	4732                	lw	a4,12(sp)
80003b82:	078a                	slli	a5,a5,0x2
80003b84:	97ba                	add	a5,a5,a4
80003b86:	4398                	lw	a4,0(a5)
80003b88:	400007b7          	lui	a5,0x40000
80003b8c:	8ff9                	and	a5,a5,a4
80003b8e:	00f037b3          	snez	a5,a5
80003b92:	0ff7f793          	zext.b	a5,a5
}
80003b96:	853e                	mv	a0,a5
80003b98:	0141                	addi	sp,sp,16
80003b9a:	8082                	ret

Disassembly of section .text.sysctl_cpu_clock_any_is_busy:

80003b9c <sysctl_cpu_clock_any_is_busy>:
 *
 * @param[in] ptr SYSCTL_Type base address
 * @return true if any clock is busy
 */
static inline bool sysctl_cpu_clock_any_is_busy(SYSCTL_Type *ptr)
{
80003b9c:	1141                	addi	sp,sp,-16
80003b9e:	c62a                	sw	a0,12(sp)
    return ptr->CLOCK_CPU[0] & SYSCTL_CLOCK_CPU_GLB_BUSY_MASK;
80003ba0:	4732                	lw	a4,12(sp)
80003ba2:	6789                	lui	a5,0x2
80003ba4:	97ba                	add	a5,a5,a4
80003ba6:	8007a703          	lw	a4,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
80003baa:	800007b7          	lui	a5,0x80000
80003bae:	8ff9                	and	a5,a5,a4
80003bb0:	00f037b3          	snez	a5,a5
80003bb4:	0ff7f793          	zext.b	a5,a5
}
80003bb8:	853e                	mv	a0,a5
80003bba:	0141                	addi	sp,sp,16
80003bbc:	8082                	ret

Disassembly of section .text.sysctl_clock_target_is_busy:

80003bbe <sysctl_clock_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] clock target clock
 * @return true if target clock is busy
 */
static inline bool sysctl_clock_target_is_busy(SYSCTL_Type *ptr, clock_node_t clock)
{
80003bbe:	1141                	addi	sp,sp,-16
80003bc0:	c62a                	sw	a0,12(sp)
80003bc2:	87ae                	mv	a5,a1
80003bc4:	00f105a3          	sb	a5,11(sp)
    return ptr->CLOCK[clock] & SYSCTL_CLOCK_LOC_BUSY_MASK;
80003bc8:	00b14783          	lbu	a5,11(sp)
80003bcc:	4732                	lw	a4,12(sp)
80003bce:	60078793          	addi	a5,a5,1536 # 80000600 <__NOR_CFG_OPTION_segment_used_end__+0x1f0>
80003bd2:	078a                	slli	a5,a5,0x2
80003bd4:	97ba                	add	a5,a5,a4
80003bd6:	43d8                	lw	a4,4(a5)
80003bd8:	400007b7          	lui	a5,0x40000
80003bdc:	8ff9                	and	a5,a5,a4
80003bde:	00f037b3          	snez	a5,a5
80003be2:	0ff7f793          	zext.b	a5,a5
}
80003be6:	853e                	mv	a0,a5
80003be8:	0141                	addi	sp,sp,16
80003bea:	8082                	ret

Disassembly of section .text.sysctl_config_clock:

80003bec <sysctl_config_clock>:
    }
    return status_success;
}

hpm_stat_t sysctl_config_clock(SYSCTL_Type *ptr, clock_node_t node, clock_source_t source, uint32_t divide_by)
{
80003bec:	1101                	addi	sp,sp,-32
80003bee:	ce06                	sw	ra,28(sp)
80003bf0:	c62a                	sw	a0,12(sp)
80003bf2:	87ae                	mv	a5,a1
80003bf4:	8732                	mv	a4,a2
80003bf6:	c236                	sw	a3,4(sp)
80003bf8:	00f105a3          	sb	a5,11(sp)
80003bfc:	87ba                	mv	a5,a4
80003bfe:	00f10523          	sb	a5,10(sp)
    if (node >= clock_node_adc_start) {
80003c02:	00b14703          	lbu	a4,11(sp)
80003c06:	02300793          	li	a5,35
80003c0a:	00e7f463          	bgeu	a5,a4,80003c12 <.L81>
        return status_invalid_argument;
80003c0e:	4789                	li	a5,2
80003c10:	a8b1                	j	80003c6c <.L82>

80003c12 <.L81>:
    }

    if (source >= clock_source_general_source_end) {
80003c12:	00a14703          	lbu	a4,10(sp)
80003c16:	479d                	li	a5,7
80003c18:	00e7f463          	bgeu	a5,a4,80003c20 <.L83>
        return status_invalid_argument;
80003c1c:	4789                	li	a5,2
80003c1e:	a0b9                	j	80003c6c <.L82>

80003c20 <.L83>:
    }
    ptr->CLOCK[node] = (ptr->CLOCK[node] & ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK)) |
80003c20:	00b14783          	lbu	a5,11(sp)
80003c24:	4732                	lw	a4,12(sp)
80003c26:	60078793          	addi	a5,a5,1536 # 40000600 <_flash_size+0x3ff00600>
80003c2a:	078a                	slli	a5,a5,0x2
80003c2c:	97ba                	add	a5,a5,a4
80003c2e:	43dc                	lw	a5,4(a5)
80003c30:	8007f693          	andi	a3,a5,-2048
        (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
80003c34:	00a14783          	lbu	a5,10(sp)
80003c38:	07a2                	slli	a5,a5,0x8
80003c3a:	7007f713          	andi	a4,a5,1792
80003c3e:	4792                	lw	a5,4(sp)
80003c40:	17fd                	addi	a5,a5,-1
80003c42:	0ff7f793          	zext.b	a5,a5
80003c46:	8f5d                	or	a4,a4,a5
    ptr->CLOCK[node] = (ptr->CLOCK[node] & ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK)) |
80003c48:	00b14783          	lbu	a5,11(sp)
80003c4c:	8f55                	or	a4,a4,a3
80003c4e:	46b2                	lw	a3,12(sp)
80003c50:	60078793          	addi	a5,a5,1536
80003c54:	078a                	slli	a5,a5,0x2
80003c56:	97b6                	add	a5,a5,a3
80003c58:	c3d8                	sw	a4,4(a5)
    while (sysctl_clock_target_is_busy(ptr, node)) {
80003c5a:	0001                	nop

80003c5c <.L84>:
80003c5c:	00b14783          	lbu	a5,11(sp)
80003c60:	85be                	mv	a1,a5
80003c62:	4532                	lw	a0,12(sp)
80003c64:	3fa9                	jal	80003bbe <sysctl_clock_target_is_busy>
80003c66:	87aa                	mv	a5,a0
80003c68:	fbf5                	bnez	a5,80003c5c <.L84>
    }
    return status_success;
80003c6a:	4781                	li	a5,0

80003c6c <.L82>:
}
80003c6c:	853e                	mv	a0,a5
80003c6e:	40f2                	lw	ra,28(sp)
80003c70:	6105                	addi	sp,sp,32
80003c72:	8082                	ret

Disassembly of section .text.hpm_csr_get_core_cycle:

80003c74 <hpm_csr_get_core_cycle>:
 *          - in user mode if the device supports M/U mode
 *
 * @return CSR cycle value in 64-bit
 */
static inline uint64_t hpm_csr_get_core_cycle(void)
{
80003c74:	7179                	addi	sp,sp,-48

80003c76 <.LBB2>:
    uint64_t result;
    uint32_t resultl_first = read_csr(CSR_CYCLE);
80003c76:	c0002f73          	rdcycle	t5
80003c7a:	d27a                	sw	t5,36(sp)
80003c7c:	5f12                	lw	t5,36(sp)

80003c7e <.LBE2>:
80003c7e:	d07a                	sw	t5,32(sp)

80003c80 <.LBB3>:
    uint32_t resulth = read_csr(CSR_CYCLEH);
80003c80:	c8002f73          	rdcycleh	t5
80003c84:	ce7a                	sw	t5,28(sp)
80003c86:	4f72                	lw	t5,28(sp)

80003c88 <.LBE3>:
80003c88:	cc7a                	sw	t5,24(sp)

80003c8a <.LBB4>:
    uint32_t resultl_second = read_csr(CSR_CYCLE);
80003c8a:	c0002f73          	rdcycle	t5
80003c8e:	ca7a                	sw	t5,20(sp)
80003c90:	4f52                	lw	t5,20(sp)

80003c92 <.LBE4>:
80003c92:	c87a                	sw	t5,16(sp)
    if (resultl_first < resultl_second) {
80003c94:	5f82                	lw	t6,32(sp)
80003c96:	4f42                	lw	t5,16(sp)
80003c98:	03eff263          	bgeu	t6,t5,80003cbc <.L2>
        result = ((uint64_t)resulth << 32) | resultl_first; /* if CYCLE didn't roll over, return the value directly */
80003c9c:	47e2                	lw	a5,24(sp)
80003c9e:	8e3e                	mv	t3,a5
80003ca0:	4e81                	li	t4,0
80003ca2:	000e1693          	slli	a3,t3,0x0
80003ca6:	4601                	li	a2,0
80003ca8:	5782                	lw	a5,32(sp)
80003caa:	883e                	mv	a6,a5
80003cac:	4881                	li	a7,0
80003cae:	010667b3          	or	a5,a2,a6
80003cb2:	d43e                	sw	a5,40(sp)
80003cb4:	0116e7b3          	or	a5,a3,a7
80003cb8:	d63e                	sw	a5,44(sp)
80003cba:	a025                	j	80003ce2 <.L3>

80003cbc <.L2>:
    } else {
        resulth = read_csr(CSR_CYCLEH);
80003cbc:	c80026f3          	rdcycleh	a3
80003cc0:	c636                	sw	a3,12(sp)
80003cc2:	46b2                	lw	a3,12(sp)

80003cc4 <.LBE5>:
80003cc4:	cc36                	sw	a3,24(sp)
        result = ((uint64_t)resulth << 32) | resultl_second; /* if CYCLE rolled over, need to get the CYCLEH again */
80003cc6:	46e2                	lw	a3,24(sp)
80003cc8:	8336                	mv	t1,a3
80003cca:	4381                	li	t2,0
80003ccc:	00031793          	slli	a5,t1,0x0
80003cd0:	4701                	li	a4,0
80003cd2:	46c2                	lw	a3,16(sp)
80003cd4:	8536                	mv	a0,a3
80003cd6:	4581                	li	a1,0
80003cd8:	00a766b3          	or	a3,a4,a0
80003cdc:	d436                	sw	a3,40(sp)
80003cde:	8fcd                	or	a5,a5,a1
80003ce0:	d63e                	sw	a5,44(sp)

80003ce2 <.L3>:
    }
    return result;
80003ce2:	5722                	lw	a4,40(sp)
80003ce4:	57b2                	lw	a5,44(sp)
 }
80003ce6:	853a                	mv	a0,a4
80003ce8:	85be                	mv	a1,a5
80003cea:	6145                	addi	sp,sp,48
80003cec:	8082                	ret

Disassembly of section .text.get_frequency_for_source:

80003cee <get_frequency_for_source>:
    }
    return clk_freq;
}

uint32_t get_frequency_for_source(clock_source_t source)
{
80003cee:	7179                	addi	sp,sp,-48
80003cf0:	d606                	sw	ra,44(sp)
80003cf2:	87aa                	mv	a5,a0
80003cf4:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80003cf8:	ce02                	sw	zero,28(sp)
    switch (source) {
80003cfa:	00f14783          	lbu	a5,15(sp)
80003cfe:	471d                	li	a4,7
80003d00:	08f76763          	bltu	a4,a5,80003d8e <.L30>
80003d04:	00279713          	slli	a4,a5,0x2
80003d08:	8f018793          	addi	a5,gp,-1808 # 80003180 <.L32>
80003d0c:	97ba                	add	a5,a5,a4
80003d0e:	439c                	lw	a5,0(a5)
80003d10:	8782                	jr	a5

80003d12 <.L39>:
    case clock_source_osc0_clk0:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
80003d12:	016e37b7          	lui	a5,0x16e3
80003d16:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80003d1a:	ce3e                	sw	a5,28(sp)
        break;
80003d1c:	a89d                	j	80003d92 <.L40>

80003d1e <.L38>:
    case clock_source_pll0_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk0);
80003d1e:	4601                	li	a2,0
80003d20:	4581                	li	a1,0
80003d22:	f40c0537          	lui	a0,0xf40c0
80003d26:	1a0030ef          	jal	80006ec6 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003d2a:	ce2a                	sw	a0,28(sp)
        break;
80003d2c:	a09d                	j	80003d92 <.L40>

80003d2e <.L37>:
    case clock_source_pll0_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk1);
80003d2e:	4605                	li	a2,1
80003d30:	4581                	li	a1,0
80003d32:	f40c0537          	lui	a0,0xf40c0
80003d36:	190030ef          	jal	80006ec6 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003d3a:	ce2a                	sw	a0,28(sp)
        break;
80003d3c:	a899                	j	80003d92 <.L40>

80003d3e <.L36>:
    case clock_source_pll0_clk2:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk2);
80003d3e:	4609                	li	a2,2
80003d40:	4581                	li	a1,0
80003d42:	f40c0537          	lui	a0,0xf40c0
80003d46:	180030ef          	jal	80006ec6 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003d4a:	ce2a                	sw	a0,28(sp)
        break;
80003d4c:	a099                	j	80003d92 <.L40>

80003d4e <.L35>:
    case clock_source_pll1_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk0);
80003d4e:	4601                	li	a2,0
80003d50:	4585                	li	a1,1
80003d52:	f40c0537          	lui	a0,0xf40c0
80003d56:	170030ef          	jal	80006ec6 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003d5a:	ce2a                	sw	a0,28(sp)
        break;
80003d5c:	a81d                	j	80003d92 <.L40>

80003d5e <.L34>:
    case clock_source_pll1_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk1);
80003d5e:	4605                	li	a2,1
80003d60:	4585                	li	a1,1
80003d62:	f40c0537          	lui	a0,0xf40c0
80003d66:	160030ef          	jal	80006ec6 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003d6a:	ce2a                	sw	a0,28(sp)
        break;
80003d6c:	a01d                	j	80003d92 <.L40>

80003d6e <.L33>:
    case clock_source_pll1_clk2:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk2);
80003d6e:	4609                	li	a2,2
80003d70:	4585                	li	a1,1
80003d72:	f40c0537          	lui	a0,0xf40c0
80003d76:	150030ef          	jal	80006ec6 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003d7a:	ce2a                	sw	a0,28(sp)
        break;
80003d7c:	a819                	j	80003d92 <.L40>

80003d7e <.L31>:
    case clock_source_pll1_clk3:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk3);
80003d7e:	460d                	li	a2,3
80003d80:	4585                	li	a1,1
80003d82:	f40c0537          	lui	a0,0xf40c0
80003d86:	140030ef          	jal	80006ec6 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003d8a:	ce2a                	sw	a0,28(sp)
        break;
80003d8c:	a019                	j	80003d92 <.L40>

80003d8e <.L30>:
    default:
        clk_freq = 0UL;
80003d8e:	ce02                	sw	zero,28(sp)
        break;
80003d90:	0001                	nop

80003d92 <.L40>:
    }

    return clk_freq;
80003d92:	47f2                	lw	a5,28(sp)
}
80003d94:	853e                	mv	a0,a5
80003d96:	50b2                	lw	ra,44(sp)
80003d98:	6145                	addi	sp,sp,48
80003d9a:	8082                	ret

Disassembly of section .text.get_frequency_for_ip_in_common_group:

80003d9c <get_frequency_for_ip_in_common_group>:

static uint32_t get_frequency_for_ip_in_common_group(clock_node_t node)
{
80003d9c:	7139                	addi	sp,sp,-64
80003d9e:	de06                	sw	ra,60(sp)
80003da0:	87aa                	mv	a5,a0
80003da2:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80003da6:	d602                	sw	zero,44(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(node);
80003da8:	00f14783          	lbu	a5,15(sp)
80003dac:	d43e                	sw	a5,40(sp)

    if (node_or_instance < clock_node_end) {
80003dae:	5722                	lw	a4,40(sp)
80003db0:	02700793          	li	a5,39
80003db4:	04e7e563          	bltu	a5,a4,80003dfe <.L43>

80003db8 <.LBB6>:
        uint32_t clk_node = (uint32_t) node_or_instance;
80003db8:	57a2                	lw	a5,40(sp)
80003dba:	d23e                	sw	a5,36(sp)

        uint32_t clk_div = 1UL + SYSCTL_CLOCK_DIV_GET(HPM_SYSCTL->CLOCK[clk_node]);
80003dbc:	f4000737          	lui	a4,0xf4000
80003dc0:	5792                	lw	a5,36(sp)
80003dc2:	60078793          	addi	a5,a5,1536
80003dc6:	078a                	slli	a5,a5,0x2
80003dc8:	97ba                	add	a5,a5,a4
80003dca:	43dc                	lw	a5,4(a5)
80003dcc:	0ff7f793          	zext.b	a5,a5
80003dd0:	0785                	addi	a5,a5,1
80003dd2:	d03e                	sw	a5,32(sp)
        clock_source_t clk_mux = (clock_source_t) SYSCTL_CLOCK_MUX_GET(HPM_SYSCTL->CLOCK[clk_node]);
80003dd4:	f4000737          	lui	a4,0xf4000
80003dd8:	5792                	lw	a5,36(sp)
80003dda:	60078793          	addi	a5,a5,1536
80003dde:	078a                	slli	a5,a5,0x2
80003de0:	97ba                	add	a5,a5,a4
80003de2:	43dc                	lw	a5,4(a5)
80003de4:	83a1                	srli	a5,a5,0x8
80003de6:	8b9d                	andi	a5,a5,7
80003de8:	00f10fa3          	sb	a5,31(sp)
        clk_freq = get_frequency_for_source(clk_mux) / clk_div;
80003dec:	01f14783          	lbu	a5,31(sp)
80003df0:	853e                	mv	a0,a5
80003df2:	3df5                	jal	80003cee <get_frequency_for_source>
80003df4:	872a                	mv	a4,a0
80003df6:	5782                	lw	a5,32(sp)
80003df8:	02f757b3          	divu	a5,a4,a5
80003dfc:	d63e                	sw	a5,44(sp)

80003dfe <.L43>:
    }
    return clk_freq;
80003dfe:	57b2                	lw	a5,44(sp)
}
80003e00:	853e                	mv	a0,a5
80003e02:	50f2                	lw	ra,60(sp)
80003e04:	6121                	addi	sp,sp,64
80003e06:	8082                	ret

Disassembly of section .text.get_frequency_for_adc:

80003e08 <get_frequency_for_adc>:

static uint32_t get_frequency_for_adc(uint32_t clk_src_type, uint32_t instance)
{
80003e08:	7179                	addi	sp,sp,-48
80003e0a:	d606                	sw	ra,44(sp)
80003e0c:	c62a                	sw	a0,12(sp)
80003e0e:	c42e                	sw	a1,8(sp)
    uint32_t clk_freq = 0UL;
80003e10:	ce02                	sw	zero,28(sp)
    bool is_mux_valid = false;
80003e12:	00010da3          	sb	zero,27(sp)
    clock_node_t node = clock_node_end;
80003e16:	02800793          	li	a5,40
80003e1a:	00f10d23          	sb	a5,26(sp)
    uint32_t adc_index = instance;
80003e1e:	47a2                	lw	a5,8(sp)
80003e20:	ca3e                	sw	a5,20(sp)

    (void) clk_src_type;

    if (adc_index < ADC_INSTANCE_NUM) {
80003e22:	4752                	lw	a4,20(sp)
80003e24:	4785                	li	a5,1
80003e26:	02e7ee63          	bltu	a5,a4,80003e62 <.L46>

80003e2a <.LBB7>:
        uint32_t mux_in_reg = SYSCTL_ADCCLK_MUX_GET(HPM_SYSCTL->ADCCLK[adc_index]);
80003e2a:	f4000737          	lui	a4,0xf4000
80003e2e:	47d2                	lw	a5,20(sp)
80003e30:	70078793          	addi	a5,a5,1792
80003e34:	078a                	slli	a5,a5,0x2
80003e36:	97ba                	add	a5,a5,a4
80003e38:	439c                	lw	a5,0(a5)
80003e3a:	83a1                	srli	a5,a5,0x8
80003e3c:	8b85                	andi	a5,a5,1
80003e3e:	c83e                	sw	a5,16(sp)
        if (mux_in_reg < ARRAY_SIZE(s_adc_clk_mux_node)) {
80003e40:	4742                	lw	a4,16(sp)
80003e42:	4785                	li	a5,1
80003e44:	00e7ef63          	bltu	a5,a4,80003e62 <.L46>
            node = s_adc_clk_mux_node[mux_in_reg];
80003e48:	800047b7          	lui	a5,0x80004
80003e4c:	8dc78713          	addi	a4,a5,-1828 # 800038dc <s_adc_clk_mux_node>
80003e50:	47c2                	lw	a5,16(sp)
80003e52:	97ba                	add	a5,a5,a4
80003e54:	0007c783          	lbu	a5,0(a5)
80003e58:	00f10d23          	sb	a5,26(sp)
            is_mux_valid = true;
80003e5c:	4785                	li	a5,1
80003e5e:	00f10da3          	sb	a5,27(sp)

80003e62 <.L46>:
        }
    }

    if (is_mux_valid) {
80003e62:	01b14783          	lbu	a5,27(sp)
80003e66:	cb85                	beqz	a5,80003e96 <.L47>
        if (node != clock_node_ahb) {
80003e68:	01a14703          	lbu	a4,26(sp)
80003e6c:	0fe00793          	li	a5,254
80003e70:	02f70063          	beq	a4,a5,80003e90 <.L48>
            node += instance;
80003e74:	47a2                	lw	a5,8(sp)
80003e76:	0ff7f793          	zext.b	a5,a5
80003e7a:	01a14703          	lbu	a4,26(sp)
80003e7e:	97ba                	add	a5,a5,a4
80003e80:	00f10d23          	sb	a5,26(sp)
            clk_freq = get_frequency_for_ip_in_common_group(node);
80003e84:	01a14783          	lbu	a5,26(sp)
80003e88:	853e                	mv	a0,a5
80003e8a:	3f09                	jal	80003d9c <get_frequency_for_ip_in_common_group>
80003e8c:	ce2a                	sw	a0,28(sp)
80003e8e:	a021                	j	80003e96 <.L47>

80003e90 <.L48>:
        } else {
            clk_freq = get_frequency_for_ahb();
80003e90:	75a020ef          	jal	800065ea <get_frequency_for_ahb>
80003e94:	ce2a                	sw	a0,28(sp)

80003e96 <.L47>:
        }
    }
    return clk_freq;
80003e96:	47f2                	lw	a5,28(sp)
}
80003e98:	853e                	mv	a0,a5
80003e9a:	50b2                	lw	ra,44(sp)
80003e9c:	6145                	addi	sp,sp,48
80003e9e:	8082                	ret

Disassembly of section .text.get_frequency_for_ewdg:

80003ea0 <get_frequency_for_ewdg>:

    return clk_freq;
}

static uint32_t get_frequency_for_ewdg(uint32_t instance)
{
80003ea0:	7179                	addi	sp,sp,-48
80003ea2:	d606                	sw	ra,44(sp)
80003ea4:	c62a                	sw	a0,12(sp)
    uint32_t freq_in_hz;
    if (EWDG_CTRL0_CLK_SEL_GET(s_wdgs[instance]->CTRL0) == 0) {
80003ea6:	8b818713          	addi	a4,gp,-1864 # 80003148 <s_wdgs>
80003eaa:	47b2                	lw	a5,12(sp)
80003eac:	078a                	slli	a5,a5,0x2
80003eae:	97ba                	add	a5,a5,a4
80003eb0:	439c                	lw	a5,0(a5)
80003eb2:	4398                	lw	a4,0(a5)
80003eb4:	200007b7          	lui	a5,0x20000
80003eb8:	8ff9                	and	a5,a5,a4
80003eba:	e789                	bnez	a5,80003ec4 <.L56>
        freq_in_hz = get_frequency_for_ahb();
80003ebc:	72e020ef          	jal	800065ea <get_frequency_for_ahb>
80003ec0:	ce2a                	sw	a0,28(sp)
80003ec2:	a019                	j	80003ec8 <.L57>

80003ec4 <.L56>:
    } else {
        freq_in_hz = FREQ_32KHz;
80003ec4:	67a1                	lui	a5,0x8
80003ec6:	ce3e                	sw	a5,28(sp)

80003ec8 <.L57>:
    }

    return freq_in_hz;
80003ec8:	47f2                	lw	a5,28(sp)
}
80003eca:	853e                	mv	a0,a5
80003ecc:	50b2                	lw	ra,44(sp)
80003ece:	6145                	addi	sp,sp,48
80003ed0:	8082                	ret

Disassembly of section .text.get_frequency_for_cpu:

80003ed2 <get_frequency_for_cpu>:

    return freq_in_hz;
}

static uint32_t get_frequency_for_cpu(void)
{
80003ed2:	1101                	addi	sp,sp,-32
80003ed4:	ce06                	sw	ra,28(sp)
    uint32_t mux = SYSCTL_CLOCK_CPU_MUX_GET(HPM_SYSCTL->CLOCK_CPU[0]);
80003ed6:	f4000737          	lui	a4,0xf4000
80003eda:	6789                	lui	a5,0x2
80003edc:	97ba                	add	a5,a5,a4
80003ede:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
80003ee2:	83a1                	srli	a5,a5,0x8
80003ee4:	8b9d                	andi	a5,a5,7
80003ee6:	c63e                	sw	a5,12(sp)
    uint32_t div = SYSCTL_CLOCK_CPU_DIV_GET(HPM_SYSCTL->CLOCK_CPU[0]) + 1U;
80003ee8:	f4000737          	lui	a4,0xf4000
80003eec:	6789                	lui	a5,0x2
80003eee:	97ba                	add	a5,a5,a4
80003ef0:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
80003ef4:	0ff7f793          	zext.b	a5,a5
80003ef8:	0785                	addi	a5,a5,1
80003efa:	c43e                	sw	a5,8(sp)
    return (get_frequency_for_source(mux) / div);
80003efc:	47b2                	lw	a5,12(sp)
80003efe:	0ff7f793          	zext.b	a5,a5
80003f02:	853e                	mv	a0,a5
80003f04:	33ed                	jal	80003cee <get_frequency_for_source>
80003f06:	872a                	mv	a4,a0
80003f08:	47a2                	lw	a5,8(sp)
80003f0a:	02f757b3          	divu	a5,a4,a5
}
80003f0e:	853e                	mv	a0,a5
80003f10:	40f2                	lw	ra,28(sp)
80003f12:	6105                	addi	sp,sp,32
80003f14:	8082                	ret

Disassembly of section .text.clock_add_to_group:

80003f16 <clock_add_to_group>:
{
    switch_ip_clock(clock_name, CLOCK_OFF);
}

void clock_add_to_group(clock_name_t clock_name, uint32_t group)
{
80003f16:	7179                	addi	sp,sp,-48
80003f18:	d606                	sw	ra,44(sp)
80003f1a:	c62a                	sw	a0,12(sp)
80003f1c:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80003f1e:	47b2                	lw	a5,12(sp)
80003f20:	83c1                	srli	a5,a5,0x10
80003f22:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
80003f24:	4772                	lw	a4,28(sp)
80003f26:	13600793          	li	a5,310
80003f2a:	00e7ef63          	bltu	a5,a4,80003f48 <.L155>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, true);
80003f2e:	47a2                	lw	a5,8(sp)
80003f30:	0ff7f793          	zext.b	a5,a5
80003f34:	4772                	lw	a4,28(sp)
80003f36:	08074733          	zext.h	a4,a4
80003f3a:	4685                	li	a3,1
80003f3c:	863a                	mv	a2,a4
80003f3e:	85be                	mv	a1,a5
80003f40:	f4000537          	lui	a0,0xf4000
80003f44:	364020ef          	jal	800062a8 <sysctl_enable_group_resource>

80003f48 <.L155>:
    }
}
80003f48:	0001                	nop
80003f4a:	50b2                	lw	ra,44(sp)
80003f4c:	6145                	addi	sp,sp,48
80003f4e:	8082                	ret

Disassembly of section .text.clock_remove_from_group:

80003f50 <clock_remove_from_group>:

void clock_remove_from_group(clock_name_t clock_name, uint32_t group)
{
80003f50:	7179                	addi	sp,sp,-48
80003f52:	d606                	sw	ra,44(sp)
80003f54:	c62a                	sw	a0,12(sp)
80003f56:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80003f58:	47b2                	lw	a5,12(sp)
80003f5a:	83c1                	srli	a5,a5,0x10
80003f5c:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
80003f5e:	4772                	lw	a4,28(sp)
80003f60:	13600793          	li	a5,310
80003f64:	00e7ef63          	bltu	a5,a4,80003f82 <.L158>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, false);
80003f68:	47a2                	lw	a5,8(sp)
80003f6a:	0ff7f793          	zext.b	a5,a5
80003f6e:	4772                	lw	a4,28(sp)
80003f70:	08074733          	zext.h	a4,a4
80003f74:	4681                	li	a3,0
80003f76:	863a                	mv	a2,a4
80003f78:	85be                	mv	a1,a5
80003f7a:	f4000537          	lui	a0,0xf4000
80003f7e:	32a020ef          	jal	800062a8 <sysctl_enable_group_resource>

80003f82 <.L158>:
    }
}
80003f82:	0001                	nop
80003f84:	50b2                	lw	ra,44(sp)
80003f86:	6145                	addi	sp,sp,48
80003f88:	8082                	ret

Disassembly of section .text.clock_cpu_delay_ms:

80003f8a <clock_cpu_delay_ms>:
    while (hpm_csr_get_core_cycle() < expected_ticks) {
    }
}

void clock_cpu_delay_ms(uint32_t ms)
{
80003f8a:	715d                	addi	sp,sp,-80
80003f8c:	c686                	sw	ra,76(sp)
80003f8e:	c4a2                	sw	s0,72(sp)
80003f90:	c2a6                	sw	s1,68(sp)
80003f92:	c0ca                	sw	s2,64(sp)
80003f94:	de4e                	sw	s3,60(sp)
80003f96:	dc52                	sw	s4,56(sp)
80003f98:	da56                	sw	s5,52(sp)
80003f9a:	d85a                	sw	s6,48(sp)
80003f9c:	d65e                	sw	s7,44(sp)
80003f9e:	c62a                	sw	a0,12(sp)
    uint64_t expected_ticks = hpm_csr_get_core_cycle() + (uint64_t)clock_get_core_clock_ticks_per_ms() * (uint64_t)ms;
80003fa0:	39d1                	jal	80003c74 <hpm_csr_get_core_cycle>
80003fa2:	8b2a                	mv	s6,a0
80003fa4:	8bae                	mv	s7,a1
80003fa6:	7c4020ef          	jal	8000676a <clock_get_core_clock_ticks_per_ms>
80003faa:	87aa                	mv	a5,a0
80003fac:	8a3e                	mv	s4,a5
80003fae:	4a81                	li	s5,0
80003fb0:	47b2                	lw	a5,12(sp)
80003fb2:	893e                	mv	s2,a5
80003fb4:	4981                	li	s3,0
80003fb6:	032a8733          	mul	a4,s5,s2
80003fba:	034987b3          	mul	a5,s3,s4
80003fbe:	97ba                	add	a5,a5,a4
80003fc0:	032a0733          	mul	a4,s4,s2
80003fc4:	032a34b3          	mulhu	s1,s4,s2
80003fc8:	843a                	mv	s0,a4
80003fca:	97a6                	add	a5,a5,s1
80003fcc:	84be                	mv	s1,a5
80003fce:	008b0733          	add	a4,s6,s0
80003fd2:	86ba                	mv	a3,a4
80003fd4:	0166b6b3          	sltu	a3,a3,s6
80003fd8:	009b87b3          	add	a5,s7,s1
80003fdc:	96be                	add	a3,a3,a5
80003fde:	87b6                	mv	a5,a3
80003fe0:	cc3a                	sw	a4,24(sp)
80003fe2:	ce3e                	sw	a5,28(sp)
    while (hpm_csr_get_core_cycle() < expected_ticks) {
80003fe4:	0001                	nop

80003fe6 <.L178>:
80003fe6:	3179                	jal	80003c74 <hpm_csr_get_core_cycle>
80003fe8:	872a                	mv	a4,a0
80003fea:	87ae                	mv	a5,a1
80003fec:	46f2                	lw	a3,28(sp)
80003fee:	863e                	mv	a2,a5
80003ff0:	fed66be3          	bltu	a2,a3,80003fe6 <.L178>
80003ff4:	46f2                	lw	a3,28(sp)
80003ff6:	863e                	mv	a2,a5
80003ff8:	00c69663          	bne	a3,a2,80004004 <.L180>
80003ffc:	46e2                	lw	a3,24(sp)
80003ffe:	87ba                	mv	a5,a4
80004000:	fed7e3e3          	bltu	a5,a3,80003fe6 <.L178>

80004004 <.L180>:
    }
}
80004004:	0001                	nop
80004006:	40b6                	lw	ra,76(sp)
80004008:	4426                	lw	s0,72(sp)
8000400a:	4496                	lw	s1,68(sp)
8000400c:	4906                	lw	s2,64(sp)
8000400e:	59f2                	lw	s3,60(sp)
80004010:	5a62                	lw	s4,56(sp)
80004012:	5ad2                	lw	s5,52(sp)
80004014:	5b42                	lw	s6,48(sp)
80004016:	5bb2                	lw	s7,44(sp)
80004018:	6161                	addi	sp,sp,80
8000401a:	8082                	ret

Disassembly of section .text.l1c_dc_enable:

8000401c <l1c_dc_enable>:
    }
#endif
}

void l1c_dc_enable(void)
{
8000401c:	1101                	addi	sp,sp,-32
8000401e:	ce06                	sw	ra,28(sp)

80004020 <.LBB48>:
#endif

/* get cache control register value */
ATTR_ALWAYS_INLINE static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
80004020:	7ca027f3          	csrr	a5,0x7ca
80004024:	c63e                	sw	a5,12(sp)
80004026:	47b2                	lw	a5,12(sp)

80004028 <.LBE52>:
80004028:	0001                	nop

8000402a <.LBE50>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_dc_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
8000402a:	8b89                	andi	a5,a5,2
8000402c:	00f037b3          	snez	a5,a5
80004030:	0ff7f793          	zext.b	a5,a5

80004034 <.LBE48>:
    if (!l1c_dc_is_enabled()) {
80004034:	0017c793          	xori	a5,a5,1
80004038:	0ff7f793          	zext.b	a5,a5
8000403c:	c791                	beqz	a5,80004048 <.L11>
#ifdef L1C_DC_DISABLE_WRITEAROUND_ON_ENABLE
        l1c_dc_disable_writearound();
#else
        l1c_dc_enable_writearound();
8000403e:	2081                	jal	8000407e <l1c_dc_enable_writearound>
#endif
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DPREF_EN_MASK | HPM_MCACHE_CTL_DC_EN_MASK);
80004040:	40200793          	li	a5,1026
80004044:	7ca7a073          	csrs	0x7ca,a5

80004048 <.L11>:
    }
}
80004048:	0001                	nop
8000404a:	40f2                	lw	ra,28(sp)
8000404c:	6105                	addi	sp,sp,32
8000404e:	8082                	ret

Disassembly of section .text.l1c_ic_enable:

80004050 <l1c_ic_enable>:
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    }
}

void l1c_ic_enable(void)
{
80004050:	1141                	addi	sp,sp,-16

80004052 <.LBB58>:
    return read_csr(CSR_MCACHE_CTL);
80004052:	7ca027f3          	csrr	a5,0x7ca
80004056:	c63e                	sw	a5,12(sp)
80004058:	47b2                	lw	a5,12(sp)

8000405a <.LBE62>:
8000405a:	0001                	nop

8000405c <.LBE60>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_ic_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
8000405c:	8b85                	andi	a5,a5,1
8000405e:	00f037b3          	snez	a5,a5
80004062:	0ff7f793          	zext.b	a5,a5

80004066 <.LBE58>:
    if (!l1c_ic_is_enabled()) {
80004066:	0017c793          	xori	a5,a5,1
8000406a:	0ff7f793          	zext.b	a5,a5
8000406e:	c789                	beqz	a5,80004078 <.L21>
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IPREF_EN_MASK
80004070:	30100793          	li	a5,769
80004074:	7ca7a073          	csrs	0x7ca,a5

80004078 <.L21>:
                              | HPM_MCACHE_CTL_CCTL_SUEN_MASK
                              | HPM_MCACHE_CTL_IC_EN_MASK);
    }
}
80004078:	0001                	nop
8000407a:	0141                	addi	sp,sp,16
8000407c:	8082                	ret

Disassembly of section .text.l1c_dc_enable_writearound:

8000407e <l1c_dc_enable_writearound>:
    l1c_op(HPM_L1C_CCTL_CMD_L1I_VA_UNLOCK, address, size);
}

void l1c_dc_enable_writearound(void)
{
    set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_WAROUND_MASK);
8000407e:	6799                	lui	a5,0x6
80004080:	7ca7a073          	csrs	0x7ca,a5
}
80004084:	0001                	nop
80004086:	8082                	ret

Disassembly of section .text.init_uart2_pins:

80004088 <init_uart2_pins>:
    HPM_IOC->PAD[IOC_PAD_PA01].FUNC_CTL = IOC_PA01_FUNC_CTL_UART0_RXD;
}

void init_uart2_pins(void)
{
    HPM_IOC->PAD[IOC_PAD_PB08].FUNC_CTL = IOC_PB08_FUNC_CTL_UART2_TXD;
80004088:	f40407b7          	lui	a5,0xf4040
8000408c:	4709                	li	a4,2
8000408e:	14e7a023          	sw	a4,320(a5) # f4040140 <__AHB_SRAM_segment_end__+0x3c38140>

    HPM_IOC->PAD[IOC_PAD_PB09].FUNC_CTL = IOC_PB09_FUNC_CTL_UART2_RXD;
80004092:	f40407b7          	lui	a5,0xf4040
80004096:	4709                	li	a4,2
80004098:	14e7a423          	sw	a4,328(a5) # f4040148 <__AHB_SRAM_segment_end__+0x3c38148>

    HPM_IOC->PAD[IOC_PAD_PB10].FUNC_CTL = IOC_PB10_FUNC_CTL_UART2_DE;
8000409c:	f40407b7          	lui	a5,0xf4040
800040a0:	4709                	li	a4,2
800040a2:	14e7a823          	sw	a4,336(a5) # f4040150 <__AHB_SRAM_segment_end__+0x3c38150>
}
800040a6:	0001                	nop
800040a8:	8082                	ret

Disassembly of section .text.init_gpio_pins:

800040aa <init_gpio_pins>:
 * enable schmitt trigger to eliminate jitter of pin used as button
 */
void init_gpio_pins(void)
{
    /* Button */
    HPM_IOC->PAD[IOC_PAD_PA09].FUNC_CTL = IOC_PA09_FUNC_CTL_GPIO_A_09;
800040aa:	f40407b7          	lui	a5,0xf4040
800040ae:	0407a423          	sw	zero,72(a5) # f4040048 <__AHB_SRAM_segment_end__+0x3c38048>
    HPM_IOC->PAD[IOC_PAD_PA09].PAD_CTL = IOC_PAD_PAD_CTL_PE_SET(1) | IOC_PAD_PAD_CTL_PS_SET(1) | IOC_PAD_PAD_CTL_HYS_SET(1);
800040b2:	f40407b7          	lui	a5,0xf4040
800040b6:	01060737          	lui	a4,0x1060
800040ba:	c7f8                	sw	a4,76(a5)
}
800040bc:	0001                	nop
800040be:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

800040c0 <sysctl_resource_target_is_busy>:
{
800040c0:	1141                	addi	sp,sp,-16
800040c2:	c62a                	sw	a0,12(sp)
800040c4:	87ae                	mv	a5,a1
800040c6:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
800040ca:	00a15783          	lhu	a5,10(sp)
800040ce:	4732                	lw	a4,12(sp)
800040d0:	078a                	slli	a5,a5,0x2
800040d2:	97ba                	add	a5,a5,a4
800040d4:	4398                	lw	a4,0(a5)
800040d6:	400007b7          	lui	a5,0x40000
800040da:	8ff9                	and	a5,a5,a4
800040dc:	00f037b3          	snez	a5,a5
800040e0:	0ff7f793          	zext.b	a5,a5
}
800040e4:	853e                	mv	a0,a5
800040e6:	0141                	addi	sp,sp,16
800040e8:	8082                	ret

Disassembly of section .text.sysctl_resource_target_set_mode:

800040ea <sysctl_resource_target_set_mode>:
{
800040ea:	1141                	addi	sp,sp,-16
800040ec:	c62a                	sw	a0,12(sp)
800040ee:	87ae                	mv	a5,a1
800040f0:	8732                	mv	a4,a2
800040f2:	00f11523          	sh	a5,10(sp)
800040f6:	87ba                	mv	a5,a4
800040f8:	00f104a3          	sb	a5,9(sp)
        (ptr->RESOURCE[resource] & ~SYSCTL_RESOURCE_MODE_MASK) |
800040fc:	00a15783          	lhu	a5,10(sp)
80004100:	4732                	lw	a4,12(sp)
80004102:	078a                	slli	a5,a5,0x2
80004104:	97ba                	add	a5,a5,a4
80004106:	439c                	lw	a5,0(a5)
80004108:	ffc7f693          	andi	a3,a5,-4
        SYSCTL_RESOURCE_MODE_SET(mode);
8000410c:	00914783          	lbu	a5,9(sp)
80004110:	0037f713          	andi	a4,a5,3
    ptr->RESOURCE[resource] =
80004114:	00a15783          	lhu	a5,10(sp)
        (ptr->RESOURCE[resource] & ~SYSCTL_RESOURCE_MODE_MASK) |
80004118:	8f55                	or	a4,a4,a3
    ptr->RESOURCE[resource] =
8000411a:	46b2                	lw	a3,12(sp)
8000411c:	078a                	slli	a5,a5,0x2
8000411e:	97b6                	add	a5,a5,a3
80004120:	c398                	sw	a4,0(a5)
}
80004122:	0001                	nop
80004124:	0141                	addi	sp,sp,16
80004126:	8082                	ret

Disassembly of section .text.sysctl_resource_target_get_mode:

80004128 <sysctl_resource_target_get_mode>:
{
80004128:	1141                	addi	sp,sp,-16
8000412a:	c62a                	sw	a0,12(sp)
8000412c:	87ae                	mv	a5,a1
8000412e:	00f11523          	sh	a5,10(sp)
    return SYSCTL_RESOURCE_MODE_GET(ptr->RESOURCE[resource]);
80004132:	00a15783          	lhu	a5,10(sp)
80004136:	4732                	lw	a4,12(sp)
80004138:	078a                	slli	a5,a5,0x2
8000413a:	97ba                	add	a5,a5,a4
8000413c:	439c                	lw	a5,0(a5)
8000413e:	0ff7f793          	zext.b	a5,a5
80004142:	8b8d                	andi	a5,a5,3
80004144:	0ff7f793          	zext.b	a5,a5
}
80004148:	853e                	mv	a0,a5
8000414a:	0141                	addi	sp,sp,16
8000414c:	8082                	ret

Disassembly of section .text.sysctl_clock_set_preset:

8000414e <sysctl_clock_set_preset>:
 *
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] preset preset
 */
static inline void sysctl_clock_set_preset(SYSCTL_Type *ptr, sysctl_preset_t preset)
{
8000414e:	1141                	addi	sp,sp,-16
80004150:	c62a                	sw	a0,12(sp)
80004152:	87ae                	mv	a5,a1
80004154:	00f105a3          	sb	a5,11(sp)
    ptr->GLOBAL00 = (ptr->GLOBAL00 & ~SYSCTL_GLOBAL00_MUX_MASK) | SYSCTL_GLOBAL00_MUX_SET(preset);
80004158:	4732                	lw	a4,12(sp)
8000415a:	6789                	lui	a5,0x2
8000415c:	97ba                	add	a5,a5,a4
8000415e:	439c                	lw	a5,0(a5)
80004160:	f007f713          	andi	a4,a5,-256
80004164:	00b14783          	lbu	a5,11(sp)
80004168:	8f5d                	or	a4,a4,a5
8000416a:	46b2                	lw	a3,12(sp)
8000416c:	6789                	lui	a5,0x2
8000416e:	97b6                	add	a5,a5,a3
80004170:	c398                	sw	a4,0(a5)
}
80004172:	0001                	nop
80004174:	0141                	addi	sp,sp,16
80004176:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_is_stable:

80004178 <pllctlv2_xtal_is_stable>:
 * @brief Checks the stability status of the external crystal oscillator
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @return true if the external crystal oscillator is stable and ready for use
 */
static inline bool pllctlv2_xtal_is_stable(PLLCTLV2_Type *ptr)
{
80004178:	1101                	addi	sp,sp,-32
8000417a:	c62a                	sw	a0,12(sp)
    uint32_t status = ptr->XTAL;
8000417c:	47b2                	lw	a5,12(sp)
8000417e:	439c                	lw	a5,0(a5)
80004180:	ce3e                	sw	a5,28(sp)
    return (IS_HPM_BITMASK_CLR(status, PLLCTLV2_XTAL_ENABLE_MASK)
80004182:	4772                	lw	a4,28(sp)
80004184:	100007b7          	lui	a5,0x10000
80004188:	8ff9                	and	a5,a5,a4
         || (IS_HPM_BITMASK_CLR(status, PLLCTLV2_XTAL_BUSY_MASK) && IS_HPM_BITMASK_SET(status, PLLCTLV2_XTAL_RESPONSE_MASK)));
8000418a:	cb89                	beqz	a5,8000419c <.L30>
8000418c:	47f2                	lw	a5,28(sp)
8000418e:	0007c963          	bltz	a5,800041a0 <.L31>
80004192:	4772                	lw	a4,28(sp)
80004194:	200007b7          	lui	a5,0x20000
80004198:	8ff9                	and	a5,a5,a4
8000419a:	c399                	beqz	a5,800041a0 <.L31>

8000419c <.L30>:
8000419c:	4785                	li	a5,1
8000419e:	a011                	j	800041a2 <.L32>

800041a0 <.L31>:
800041a0:	4781                	li	a5,0

800041a2 <.L32>:
800041a2:	8b85                	andi	a5,a5,1
800041a4:	0ff7f793          	zext.b	a5,a5
}
800041a8:	853e                	mv	a0,a5
800041aa:	6105                	addi	sp,sp,32
800041ac:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_set_rampup_time:

800041ae <pllctlv2_xtal_set_rampup_time>:
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @param [in] rc24m_cycles Number of RC24M clock cycles for the ramp-up period
 * @note The ramp-up time affects how quickly the crystal oscillator reaches stable operation
 */
static inline void pllctlv2_xtal_set_rampup_time(PLLCTLV2_Type *ptr, uint32_t rc24m_cycles)
{
800041ae:	1141                	addi	sp,sp,-16
800041b0:	c62a                	sw	a0,12(sp)
800041b2:	c42e                	sw	a1,8(sp)
    ptr->XTAL = (ptr->XTAL & ~PLLCTLV2_XTAL_RAMP_TIME_MASK) | PLLCTLV2_XTAL_RAMP_TIME_SET(rc24m_cycles);
800041b4:	47b2                	lw	a5,12(sp)
800041b6:	4398                	lw	a4,0(a5)
800041b8:	fff007b7          	lui	a5,0xfff00
800041bc:	8f7d                	and	a4,a4,a5
800041be:	46a2                	lw	a3,8(sp)
800041c0:	001007b7          	lui	a5,0x100
800041c4:	17fd                	addi	a5,a5,-1 # fffff <__FLASH_segment_size__+0x2fff>
800041c6:	8ff5                	and	a5,a5,a3
800041c8:	8f5d                	or	a4,a4,a5
800041ca:	47b2                	lw	a5,12(sp)
800041cc:	c398                	sw	a4,0(a5)
}
800041ce:	0001                	nop
800041d0:	0141                	addi	sp,sp,16
800041d2:	8082                	ret

Disassembly of section .text.board_print_banner:

800041d4 <board_print_banner>:
#endif
#endif
}

void board_print_banner(void)
{
800041d4:	d8010113          	addi	sp,sp,-640
800041d8:	26112e23          	sw	ra,636(sp)
    const uint8_t banner[] = "\n"
800041dc:	95c18713          	addi	a4,gp,-1700 # 800031ec <.LC0>
800041e0:	878a                	mv	a5,sp
800041e2:	86ba                	mv	a3,a4
800041e4:	26f00713          	li	a4,623
800041e8:	863a                	mv	a2,a4
800041ea:	85b6                	mv	a1,a3
800041ec:	853e                	mv	a0,a5
800041ee:	547000ef          	jal	80004f34 <memcpy>
"$$ |  $$ |$$ |      $$ |\\$  /$$ |$$ |$$ |      $$ |      $$ |  $$ |\n"
"$$ |  $$ |$$ |      $$ | \\_/ $$ |$$ |\\$$$$$$$\\ $$ |      \\$$$$$$  |\n"
"\\__|  \\__|\\__|      \\__|     \\__|\\__| \\_______|\\__|       \\______/\n"
"----------------------------------------------------------------------\n";
#ifdef SDK_VERSION_STRING
    printf("hpm_sdk: %s\n", SDK_VERSION_STRING);
800041f2:	94018593          	addi	a1,gp,-1728 # 800031d0 <.LC1>
800041f6:	94818513          	addi	a0,gp,-1720 # 800031d8 <.LC2>
800041fa:	00c010ef          	jal	80005206 <printf>
#endif
    printf("%s", banner);
800041fe:	878a                	mv	a5,sp
80004200:	85be                	mv	a1,a5
80004202:	95818513          	addi	a0,gp,-1704 # 800031e8 <.LC3>
80004206:	000010ef          	jal	80005206 <printf>
}
8000420a:	0001                	nop
8000420c:	27c12083          	lw	ra,636(sp)
80004210:	28010113          	addi	sp,sp,640
80004214:	8082                	ret

Disassembly of section .text.board_print_clock_freq:

80004216 <board_print_clock_freq>:

void board_print_clock_freq(void)
{
80004216:	1141                	addi	sp,sp,-16
80004218:	c606                	sw	ra,12(sp)
    printf("==============================\n");
8000421a:	bcc18513          	addi	a0,gp,-1076 # 8000345c <.LC4>
8000421e:	7e9000ef          	jal	80005206 <printf>
    printf(" %s clock summary\n", BOARD_NAME);
80004222:	bec18593          	addi	a1,gp,-1044 # 8000347c <.LC5>
80004226:	bf818513          	addi	a0,gp,-1032 # 80003488 <.LC6>
8000422a:	7dd000ef          	jal	80005206 <printf>
    printf("==============================\n");
8000422e:	bcc18513          	addi	a0,gp,-1076 # 8000345c <.LC4>
80004232:	7d5000ef          	jal	80005206 <printf>
    printf("cpu0:\t\t %luHz\n", clock_get_frequency(clock_cpu0));
80004236:	6785                	lui	a5,0x1
80004238:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x5ce>
8000423c:	25a020ef          	jal	80006496 <clock_get_frequency>
80004240:	87aa                	mv	a5,a0
80004242:	85be                	mv	a1,a5
80004244:	c0c18513          	addi	a0,gp,-1012 # 8000349c <.LC7>
80004248:	7bf000ef          	jal	80005206 <printf>
    printf("ahb:\t\t %luHz\n", clock_get_frequency(clock_ahb));
8000424c:	fffd07b7          	lui	a5,0xfffd0
80004250:	5fe78513          	addi	a0,a5,1534 # fffd05fe <__AHB_SRAM_segment_end__+0xfbc85fe>
80004254:	242020ef          	jal	80006496 <clock_get_frequency>
80004258:	87aa                	mv	a5,a0
8000425a:	85be                	mv	a1,a5
8000425c:	c1c18513          	addi	a0,gp,-996 # 800034ac <.LC8>
80004260:	7a7000ef          	jal	80005206 <printf>
    printf("mchtmr0:\t %luHz\n", clock_get_frequency(clock_mchtmr0));
80004264:	01020537          	lui	a0,0x1020
80004268:	22e020ef          	jal	80006496 <clock_get_frequency>
8000426c:	87aa                	mv	a5,a0
8000426e:	85be                	mv	a1,a5
80004270:	c2c18513          	addi	a0,gp,-980 # 800034bc <.LC9>
80004274:	793000ef          	jal	80005206 <printf>
    printf("xpi0:\t\t %luHz\n", clock_get_frequency(clock_xpi0));
80004278:	013307b7          	lui	a5,0x1330
8000427c:	01d78513          	addi	a0,a5,29 # 133001d <_flash_size+0x123001d>
80004280:	216020ef          	jal	80006496 <clock_get_frequency>
80004284:	87aa                	mv	a5,a0
80004286:	85be                	mv	a1,a5
80004288:	c4018513          	addi	a0,gp,-960 # 800034d0 <.LC10>
8000428c:	77b000ef          	jal	80005206 <printf>
    printf("==============================\n");
80004290:	bcc18513          	addi	a0,gp,-1076 # 8000345c <.LC4>
80004294:	773000ef          	jal	80005206 <printf>
}
80004298:	0001                	nop
8000429a:	40b2                	lw	ra,12(sp)
8000429c:	0141                	addi	sp,sp,16
8000429e:	8082                	ret

Disassembly of section .text.board_init_usb_dp_dm_pins:

800042a0 <board_init_usb_dp_dm_pins>:
    board_print_banner();
#endif
}

void board_init_usb_dp_dm_pins(void)
{
800042a0:	1101                	addi	sp,sp,-32
800042a2:	ce06                	sw	ra,28(sp)
    /* Disconnect usb dp/dm pins pull down 45ohm resistance */

    while (sysctl_resource_any_is_busy(HPM_SYSCTL)) {
800042a4:	0001                	nop

800042a6 <.L50>:
800042a6:	f4000537          	lui	a0,0xf4000
800042aa:	59c020ef          	jal	80006846 <sysctl_resource_any_is_busy>
800042ae:	87aa                	mv	a5,a0
800042b0:	fbfd                	bnez	a5,800042a6 <.L50>
        ;
    }
    if (pllctlv2_xtal_is_stable(HPM_PLLCTLV2) && pllctlv2_xtal_is_enabled(HPM_PLLCTLV2)) {
800042b2:	f40c0537          	lui	a0,0xf40c0
800042b6:	35c9                	jal	80004178 <pllctlv2_xtal_is_stable>
800042b8:	87aa                	mv	a5,a0
800042ba:	c7b1                	beqz	a5,80004306 <.L51>
800042bc:	f40c0537          	lui	a0,0xf40c0
800042c0:	626020ef          	jal	800068e6 <pllctlv2_xtal_is_enabled>
800042c4:	87aa                	mv	a5,a0
800042c6:	c3a1                	beqz	a5,80004306 <.L51>
        if (clock_check_in_group(clock_usb0, 0)) {
800042c8:	4581                	li	a1,0
800042ca:	013407b7          	lui	a5,0x1340
800042ce:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
800042d2:	442020ef          	jal	80006714 <clock_check_in_group>
800042d6:	87aa                	mv	a5,a0
800042d8:	c791                	beqz	a5,800042e4 <.L52>
            usb_phy_disable_dp_dm_pulldown(HPM_USB0);
800042da:	f300c537          	lui	a0,0xf300c
800042de:	5e8020ef          	jal	800068c6 <usb_phy_disable_dp_dm_pulldown>
        if (clock_check_in_group(clock_usb0, 0)) {
800042e2:	a049                	j	80004364 <.L54>

800042e4 <.L52>:
        } else {
            clock_add_to_group(clock_usb0, 0);
800042e4:	4581                	li	a1,0
800042e6:	013407b7          	lui	a5,0x1340
800042ea:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
800042ee:	3125                	jal	80003f16 <clock_add_to_group>
            usb_phy_disable_dp_dm_pulldown(HPM_USB0);
800042f0:	f300c537          	lui	a0,0xf300c
800042f4:	5d2020ef          	jal	800068c6 <usb_phy_disable_dp_dm_pulldown>
            clock_remove_from_group(clock_usb0, 0);
800042f8:	4581                	li	a1,0
800042fa:	013407b7          	lui	a5,0x1340
800042fe:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80004302:	31b9                	jal	80003f50 <clock_remove_from_group>
        if (clock_check_in_group(clock_usb0, 0)) {
80004304:	a085                	j	80004364 <.L54>

80004306 <.L51>:
        }
    } else {
        uint8_t tmp;
        tmp = sysctl_resource_target_get_mode(HPM_SYSCTL, sysctl_resource_xtal);
80004306:	02000593          	li	a1,32
8000430a:	f4000537          	lui	a0,0xf4000
8000430e:	3d29                	jal	80004128 <sysctl_resource_target_get_mode>
80004310:	87aa                	mv	a5,a0
80004312:	00f107a3          	sb	a5,15(sp)
        sysctl_resource_target_set_mode(HPM_SYSCTL, sysctl_resource_xtal, 0x03);    /* NOLINT */
80004316:	460d                	li	a2,3
80004318:	02000593          	li	a1,32
8000431c:	f4000537          	lui	a0,0xf4000
80004320:	33e9                	jal	800040ea <sysctl_resource_target_set_mode>
        clock_add_to_group(clock_usb0, 0);
80004322:	4581                	li	a1,0
80004324:	013407b7          	lui	a5,0x1340
80004328:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
8000432c:	36ed                	jal	80003f16 <clock_add_to_group>
        usb_phy_disable_dp_dm_pulldown(HPM_USB0);
8000432e:	f300c537          	lui	a0,0xf300c
80004332:	594020ef          	jal	800068c6 <usb_phy_disable_dp_dm_pulldown>
        clock_remove_from_group(clock_usb0, 0);
80004336:	4581                	li	a1,0
80004338:	013407b7          	lui	a5,0x1340
8000433c:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80004340:	3901                	jal	80003f50 <clock_remove_from_group>
        while (sysctl_resource_target_is_busy(HPM_SYSCTL, sysctl_resource_usb0)) {
80004342:	0001                	nop

80004344 <.L55>:
80004344:	13400593          	li	a1,308
80004348:	f4000537          	lui	a0,0xf4000
8000434c:	3b95                	jal	800040c0 <sysctl_resource_target_is_busy>
8000434e:	87aa                	mv	a5,a0
80004350:	fbf5                	bnez	a5,80004344 <.L55>
            ;
        }
        sysctl_resource_target_set_mode(HPM_SYSCTL, sysctl_resource_xtal, tmp);
80004352:	00f14783          	lbu	a5,15(sp)
80004356:	863e                	mv	a2,a5
80004358:	02000593          	li	a1,32
8000435c:	f4000537          	lui	a0,0xf4000
80004360:	3369                	jal	800040ea <sysctl_resource_target_set_mode>

80004362 <.LBE14>:
    }
}
80004362:	0001                	nop

80004364 <.L54>:
80004364:	0001                	nop
80004366:	40f2                	lw	ra,28(sp)
80004368:	6105                	addi	sp,sp,32
8000436a:	8082                	ret

Disassembly of section .text.board_get_led_gpio_off_level:

8000436c <board_get_led_gpio_off_level>:
    return BOARD_LED_OFF_LEVEL;
}

uint8_t board_get_led_gpio_off_level(void)
{
    return BOARD_LED_OFF_LEVEL;
8000436c:	4785                	li	a5,1
}
8000436e:	853e                	mv	a0,a5
80004370:	8082                	ret

Disassembly of section .text.uart_calculate_baudrate:

80004372 <uart_calculate_baudrate>:
    config->rx_enable = true;
#endif
}

static bool uart_calculate_baudrate(uint32_t freq, uint32_t baudrate, uint16_t *div_out, uint8_t *osc_out)
{
80004372:	711d                	addi	sp,sp,-96
80004374:	ce86                	sw	ra,92(sp)
80004376:	cca2                	sw	s0,88(sp)
80004378:	caa6                	sw	s1,84(sp)
8000437a:	c8ca                	sw	s2,80(sp)
8000437c:	c6ce                	sw	s3,76(sp)
8000437e:	c4d2                	sw	s4,72(sp)
80004380:	c2d6                	sw	s5,68(sp)
80004382:	c0da                	sw	s6,64(sp)
80004384:	de5e                	sw	s7,60(sp)
80004386:	dc62                	sw	s8,56(sp)
80004388:	da66                	sw	s9,52(sp)
8000438a:	c62a                	sw	a0,12(sp)
8000438c:	c42e                	sw	a1,8(sp)
8000438e:	c232                	sw	a2,4(sp)
80004390:	c036                	sw	a3,0(sp)
    uint32_t div, osc, delta;
    uint64_t tmp;
    if ((div_out == NULL) || (!freq) || (!baudrate)
80004392:	4692                	lw	a3,4(sp)
80004394:	ca9d                	beqz	a3,800043ca <.L6>
80004396:	46b2                	lw	a3,12(sp)
80004398:	ca8d                	beqz	a3,800043ca <.L6>
8000439a:	46a2                	lw	a3,8(sp)
8000439c:	c69d                	beqz	a3,800043ca <.L6>
            || (baudrate < HPM_UART_MINIMUM_BAUDRATE)
8000439e:	4622                	lw	a2,8(sp)
800043a0:	0c700693          	li	a3,199
800043a4:	02c6f363          	bgeu	a3,a2,800043ca <.L6>
            || (freq / HPM_UART_BAUDRATE_DIV_MIN < baudrate * HPM_UART_OSC_MIN)
800043a8:	46a2                	lw	a3,8(sp)
800043aa:	068e                	slli	a3,a3,0x3
800043ac:	4632                	lw	a2,12(sp)
800043ae:	00d66e63          	bltu	a2,a3,800043ca <.L6>
            || (freq / HPM_UART_BAUDRATE_DIV_MAX > (baudrate * HPM_UART_OSC_MAX))) {
800043b2:	4632                	lw	a2,12(sp)
800043b4:	800086b7          	lui	a3,0x80008
800043b8:	0685                	addi	a3,a3,1 # 80008001 <.Lmemset_fast_set+0x9>
800043ba:	02d636b3          	mulhu	a3,a2,a3
800043be:	00f6d613          	srli	a2,a3,0xf
800043c2:	46a2                	lw	a3,8(sp)
800043c4:	0696                	slli	a3,a3,0x5
800043c6:	00c6f463          	bgeu	a3,a2,800043ce <.L7>

800043ca <.L6>:
        return 0;
800043ca:	4781                	li	a5,0
800043cc:	a2f5                	j	800045b8 <.L8>

800043ce <.L7>:
    }

    tmp = ((uint64_t)freq * HPM_UART_BAUDRATE_SCALE) / baudrate;
800043ce:	46b2                	lw	a3,12(sp)
800043d0:	8736                	mv	a4,a3
800043d2:	4781                	li	a5,0
800043d4:	3e800693          	li	a3,1000
800043d8:	02d78633          	mul	a2,a5,a3
800043dc:	4681                	li	a3,0
800043de:	02d706b3          	mul	a3,a4,a3
800043e2:	9636                	add	a2,a2,a3
800043e4:	3e800693          	li	a3,1000
800043e8:	02d705b3          	mul	a1,a4,a3
800043ec:	02d738b3          	mulhu	a7,a4,a3
800043f0:	882e                	mv	a6,a1
800043f2:	011607b3          	add	a5,a2,a7
800043f6:	88be                	mv	a7,a5
800043f8:	47a2                	lw	a5,8(sp)
800043fa:	833e                	mv	t1,a5
800043fc:	4381                	li	t2,0
800043fe:	861a                	mv	a2,t1
80004400:	869e                	mv	a3,t2
80004402:	8542                	mv	a0,a6
80004404:	85c6                	mv	a1,a7
80004406:	2f0030ef          	jal	800076f6 <__udivdi3>
8000440a:	872a                	mv	a4,a0
8000440c:	87ae                	mv	a5,a1
8000440e:	d03a                	sw	a4,32(sp)
80004410:	d23e                	sw	a5,36(sp)

    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
80004412:	47a1                	li	a5,8
80004414:	d63e                	sw	a5,44(sp)
80004416:	aa61                	j	800045ae <.L9>

80004418 <.L21>:
        /* osc range: HPM_UART_OSC_MIN - UART_SOC_OVERSAMPLE_MAX, even number */
        delta = 0;
80004418:	d402                	sw	zero,40(sp)
        /* Calculate divider with rounding */
        div = (uint32_t)((tmp + osc * (HPM_UART_BAUDRATE_SCALE / 2)) / (osc * HPM_UART_BAUDRATE_SCALE));
8000441a:	5732                	lw	a4,44(sp)
8000441c:	87ba                	mv	a5,a4
8000441e:	078a                	slli	a5,a5,0x2
80004420:	97ba                	add	a5,a5,a4
80004422:	00279713          	slli	a4,a5,0x2
80004426:	97ba                	add	a5,a5,a4
80004428:	00279713          	slli	a4,a5,0x2
8000442c:	97ba                	add	a5,a5,a4
8000442e:	078a                	slli	a5,a5,0x2
80004430:	843e                	mv	s0,a5
80004432:	4481                	li	s1,0
80004434:	5602                	lw	a2,32(sp)
80004436:	5692                	lw	a3,36(sp)
80004438:	00c40733          	add	a4,s0,a2
8000443c:	85ba                	mv	a1,a4
8000443e:	0085b5b3          	sltu	a1,a1,s0
80004442:	00d487b3          	add	a5,s1,a3
80004446:	00f586b3          	add	a3,a1,a5
8000444a:	87b6                	mv	a5,a3
8000444c:	853a                	mv	a0,a4
8000444e:	85be                	mv	a1,a5
80004450:	5732                	lw	a4,44(sp)
80004452:	87ba                	mv	a5,a4
80004454:	078a                	slli	a5,a5,0x2
80004456:	97ba                	add	a5,a5,a4
80004458:	00279713          	slli	a4,a5,0x2
8000445c:	97ba                	add	a5,a5,a4
8000445e:	00279713          	slli	a4,a5,0x2
80004462:	97ba                	add	a5,a5,a4
80004464:	078e                	slli	a5,a5,0x3
80004466:	8b3e                	mv	s6,a5
80004468:	4b81                	li	s7,0
8000446a:	865a                	mv	a2,s6
8000446c:	86de                	mv	a3,s7
8000446e:	288030ef          	jal	800076f6 <__udivdi3>
80004472:	872a                	mv	a4,a0
80004474:	87ae                	mv	a5,a1
80004476:	ce3a                	sw	a4,28(sp)
        if (div < HPM_UART_BAUDRATE_DIV_MIN || div > HPM_UART_BAUDRATE_DIV_MAX) {
80004478:	47f2                	lw	a5,28(sp)
8000447a:	12078463          	beqz	a5,800045a2 <.L24>
8000447e:	4772                	lw	a4,28(sp)
80004480:	67c1                	lui	a5,0x10
80004482:	12f77063          	bgeu	a4,a5,800045a2 <.L24>
            /* invalid div */
            continue;
        }
        if ((div * osc * HPM_UART_BAUDRATE_SCALE) > tmp) {
80004486:	4772                	lw	a4,28(sp)
80004488:	57b2                	lw	a5,44(sp)
8000448a:	02f70733          	mul	a4,a4,a5
8000448e:	87ba                	mv	a5,a4
80004490:	078a                	slli	a5,a5,0x2
80004492:	97ba                	add	a5,a5,a4
80004494:	00279713          	slli	a4,a5,0x2
80004498:	97ba                	add	a5,a5,a4
8000449a:	00279713          	slli	a4,a5,0x2
8000449e:	97ba                	add	a5,a5,a4
800044a0:	078e                	slli	a5,a5,0x3
800044a2:	893e                	mv	s2,a5
800044a4:	4981                	li	s3,0
800044a6:	5792                	lw	a5,36(sp)
800044a8:	874e                	mv	a4,s3
800044aa:	00e7ea63          	bltu	a5,a4,800044be <.L22>
800044ae:	5792                	lw	a5,36(sp)
800044b0:	874e                	mv	a4,s3
800044b2:	02e79a63          	bne	a5,a4,800044e6 <.L13>
800044b6:	5782                	lw	a5,32(sp)
800044b8:	874a                	mv	a4,s2
800044ba:	02e7f663          	bgeu	a5,a4,800044e6 <.L13>

800044be <.L22>:
            delta = (uint32_t)((div * osc * HPM_UART_BAUDRATE_SCALE) - tmp);
800044be:	4772                	lw	a4,28(sp)
800044c0:	57b2                	lw	a5,44(sp)
800044c2:	02f70733          	mul	a4,a4,a5
800044c6:	87ba                	mv	a5,a4
800044c8:	078a                	slli	a5,a5,0x2
800044ca:	97ba                	add	a5,a5,a4
800044cc:	00279713          	slli	a4,a5,0x2
800044d0:	97ba                	add	a5,a5,a4
800044d2:	00279713          	slli	a4,a5,0x2
800044d6:	97ba                	add	a5,a5,a4
800044d8:	078e                	slli	a5,a5,0x3
800044da:	873e                	mv	a4,a5
800044dc:	5782                	lw	a5,32(sp)
800044de:	40f707b3          	sub	a5,a4,a5
800044e2:	d43e                	sw	a5,40(sp)
800044e4:	a8b9                	j	80004542 <.L15>

800044e6 <.L13>:
        } else if ((div * osc * HPM_UART_BAUDRATE_SCALE) < tmp) {
800044e6:	4772                	lw	a4,28(sp)
800044e8:	57b2                	lw	a5,44(sp)
800044ea:	02f70733          	mul	a4,a4,a5
800044ee:	87ba                	mv	a5,a4
800044f0:	078a                	slli	a5,a5,0x2
800044f2:	97ba                	add	a5,a5,a4
800044f4:	00279713          	slli	a4,a5,0x2
800044f8:	97ba                	add	a5,a5,a4
800044fa:	00279713          	slli	a4,a5,0x2
800044fe:	97ba                	add	a5,a5,a4
80004500:	078e                	slli	a5,a5,0x3
80004502:	8a3e                	mv	s4,a5
80004504:	4a81                	li	s5,0
80004506:	5792                	lw	a5,36(sp)
80004508:	8756                	mv	a4,s5
8000450a:	00f76a63          	bltu	a4,a5,8000451e <.L23>
8000450e:	5792                	lw	a5,36(sp)
80004510:	8756                	mv	a4,s5
80004512:	02e79863          	bne	a5,a4,80004542 <.L15>
80004516:	5782                	lw	a5,32(sp)
80004518:	8752                	mv	a4,s4
8000451a:	02f77463          	bgeu	a4,a5,80004542 <.L15>

8000451e <.L23>:
            delta = (uint32_t)(tmp - (div * osc * HPM_UART_BAUDRATE_SCALE));
8000451e:	5682                	lw	a3,32(sp)
80004520:	4772                	lw	a4,28(sp)
80004522:	57b2                	lw	a5,44(sp)
80004524:	02f70733          	mul	a4,a4,a5
80004528:	87ba                	mv	a5,a4
8000452a:	078a                	slli	a5,a5,0x2
8000452c:	97ba                	add	a5,a5,a4
8000452e:	00279713          	slli	a4,a5,0x2
80004532:	97ba                	add	a5,a5,a4
80004534:	00279713          	slli	a4,a5,0x2
80004538:	97ba                	add	a5,a5,a4
8000453a:	078e                	slli	a5,a5,0x3
8000453c:	40f687b3          	sub	a5,a3,a5
80004540:	d43e                	sw	a5,40(sp)

80004542 <.L15>:
        }
        if (delta && (((delta * 100) / tmp) > HPM_UART_BAUDRATE_TOLERANCE)) {
80004542:	57a2                	lw	a5,40(sp)
80004544:	cb95                	beqz	a5,80004578 <.L17>
80004546:	5722                	lw	a4,40(sp)
80004548:	87ba                	mv	a5,a4
8000454a:	078a                	slli	a5,a5,0x2
8000454c:	97ba                	add	a5,a5,a4
8000454e:	00279713          	slli	a4,a5,0x2
80004552:	97ba                	add	a5,a5,a4
80004554:	078a                	slli	a5,a5,0x2
80004556:	8c3e                	mv	s8,a5
80004558:	4c81                	li	s9,0
8000455a:	5602                	lw	a2,32(sp)
8000455c:	5692                	lw	a3,36(sp)
8000455e:	8562                	mv	a0,s8
80004560:	85e6                	mv	a1,s9
80004562:	194030ef          	jal	800076f6 <__udivdi3>
80004566:	872a                	mv	a4,a0
80004568:	87ae                	mv	a5,a1
8000456a:	86be                	mv	a3,a5
8000456c:	ee8d                	bnez	a3,800045a6 <.L25>
8000456e:	86be                	mv	a3,a5
80004570:	e681                	bnez	a3,80004578 <.L17>
80004572:	478d                	li	a5,3
80004574:	02e7e963          	bltu	a5,a4,800045a6 <.L25>

80004578 <.L17>:
            continue;
        } else {
            *div_out = div;
80004578:	47f2                	lw	a5,28(sp)
8000457a:	0807c733          	zext.h	a4,a5
8000457e:	4792                	lw	a5,4(sp)
80004580:	00e79023          	sh	a4,0(a5) # 10000 <__AHB_SRAM_segment_size__+0x8000>
            *osc_out = (osc == HPM_UART_OSC_MAX) ? 0 : osc; /* osc == 0 in bitfield, oversample rate is 32 */
80004584:	5732                	lw	a4,44(sp)
80004586:	02000793          	li	a5,32
8000458a:	00f70663          	beq	a4,a5,80004596 <.L19>
8000458e:	57b2                	lw	a5,44(sp)
80004590:	0ff7f793          	zext.b	a5,a5
80004594:	a011                	j	80004598 <.L20>

80004596 <.L19>:
80004596:	4781                	li	a5,0

80004598 <.L20>:
80004598:	4702                	lw	a4,0(sp)
8000459a:	00f70023          	sb	a5,0(a4) # 1060000 <_flash_size+0xf60000>
            return true;
8000459e:	4785                	li	a5,1
800045a0:	a821                	j	800045b8 <.L8>

800045a2 <.L24>:
            continue;
800045a2:	0001                	nop
800045a4:	a011                	j	800045a8 <.L12>

800045a6 <.L25>:
            continue;
800045a6:	0001                	nop

800045a8 <.L12>:
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
800045a8:	57b2                	lw	a5,44(sp)
800045aa:	0789                	addi	a5,a5,2
800045ac:	d63e                	sw	a5,44(sp)

800045ae <.L9>:
800045ae:	5732                	lw	a4,44(sp)
800045b0:	47f9                	li	a5,30
800045b2:	e6e7f3e3          	bgeu	a5,a4,80004418 <.L21>
        }
    }
    return false;
800045b6:	4781                	li	a5,0

800045b8 <.L8>:
}
800045b8:	853e                	mv	a0,a5
800045ba:	40f6                	lw	ra,92(sp)
800045bc:	4466                	lw	s0,88(sp)
800045be:	44d6                	lw	s1,84(sp)
800045c0:	4946                	lw	s2,80(sp)
800045c2:	49b6                	lw	s3,76(sp)
800045c4:	4a26                	lw	s4,72(sp)
800045c6:	4a96                	lw	s5,68(sp)
800045c8:	4b06                	lw	s6,64(sp)
800045ca:	5bf2                	lw	s7,60(sp)
800045cc:	5c62                	lw	s8,56(sp)
800045ce:	5cd2                	lw	s9,52(sp)
800045d0:	6125                	addi	sp,sp,96
800045d2:	8082                	ret

Disassembly of section .text.uart_init:

800045d4 <uart_init>:

hpm_stat_t uart_init(UART_Type *ptr, uart_config_t *config)
{
800045d4:	7179                	addi	sp,sp,-48
800045d6:	d606                	sw	ra,44(sp)
800045d8:	c62a                	sw	a0,12(sp)
800045da:	c42e                	sw	a1,8(sp)
    uint32_t tmp;
    uint8_t osc;
    uint16_t div;

    /* disable all interrupts */
    ptr->IER = 0;
800045dc:	47b2                	lw	a5,12(sp)
800045de:	0207a223          	sw	zero,36(a5)
    /* Set DLAB to 1 */
    ptr->LCR |= UART_LCR_DLAB_MASK;
800045e2:	47b2                	lw	a5,12(sp)
800045e4:	57dc                	lw	a5,44(a5)
800045e6:	0807e713          	ori	a4,a5,128
800045ea:	47b2                	lw	a5,12(sp)
800045ec:	d7d8                	sw	a4,44(a5)

    if (!uart_calculate_baudrate(config->src_freq_in_hz, config->baudrate, &div, &osc)) {
800045ee:	47a2                	lw	a5,8(sp)
800045f0:	4398                	lw	a4,0(a5)
800045f2:	47a2                	lw	a5,8(sp)
800045f4:	43dc                	lw	a5,4(a5)
800045f6:	01b10693          	addi	a3,sp,27
800045fa:	0830                	addi	a2,sp,24
800045fc:	85be                	mv	a1,a5
800045fe:	853a                	mv	a0,a4
80004600:	3b8d                	jal	80004372 <uart_calculate_baudrate>
80004602:	87aa                	mv	a5,a0
80004604:	0017c793          	xori	a5,a5,1
80004608:	0ff7f793          	zext.b	a5,a5
8000460c:	c781                	beqz	a5,80004614 <.L27>
        return status_uart_no_suitable_baudrate_parameter_found;
8000460e:	3e900793          	li	a5,1001
80004612:	a251                	j	80004796 <.L44>

80004614 <.L27>:
    }
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
80004614:	47b2                	lw	a5,12(sp)
80004616:	4bdc                	lw	a5,20(a5)
80004618:	fe07f713          	andi	a4,a5,-32
        | UART_OSCR_OSC_SET(osc);
8000461c:	01b14783          	lbu	a5,27(sp)
80004620:	8bfd                	andi	a5,a5,31
80004622:	8f5d                	or	a4,a4,a5
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
80004624:	47b2                	lw	a5,12(sp)
80004626:	cbd8                	sw	a4,20(a5)
    ptr->DLL = UART_DLL_DLL_SET(div >> 0);
80004628:	01815783          	lhu	a5,24(sp)
8000462c:	0ff7f713          	zext.b	a4,a5
80004630:	47b2                	lw	a5,12(sp)
80004632:	d398                	sw	a4,32(a5)
    ptr->DLM = UART_DLM_DLM_SET(div >> 8);
80004634:	01815783          	lhu	a5,24(sp)
80004638:	83a1                	srli	a5,a5,0x8
8000463a:	0807c7b3          	zext.h	a5,a5
8000463e:	0ff7f713          	zext.b	a4,a5
80004642:	47b2                	lw	a5,12(sp)
80004644:	d3d8                	sw	a4,36(a5)

    /* DLAB bit needs to be cleared once baudrate is configured */
    tmp = ptr->LCR & (~UART_LCR_DLAB_MASK);
80004646:	47b2                	lw	a5,12(sp)
80004648:	57dc                	lw	a5,44(a5)
8000464a:	f7f7f793          	andi	a5,a5,-129
8000464e:	ce3e                	sw	a5,28(sp)

    tmp &= ~(UART_LCR_SPS_MASK | UART_LCR_EPS_MASK | UART_LCR_PEN_MASK);
80004650:	47f2                	lw	a5,28(sp)
80004652:	fc77f793          	andi	a5,a5,-57
80004656:	ce3e                	sw	a5,28(sp)
    switch (config->parity) {
80004658:	47a2                	lw	a5,8(sp)
8000465a:	00a7c783          	lbu	a5,10(a5)
8000465e:	4711                	li	a4,4
80004660:	02f76d63          	bltu	a4,a5,8000469a <.L29>
80004664:	00279713          	slli	a4,a5,0x2
80004668:	cec18793          	addi	a5,gp,-788 # 8000357c <.L31>
8000466c:	97ba                	add	a5,a5,a4
8000466e:	439c                	lw	a5,0(a5)
80004670:	8782                	jr	a5

80004672 <.L34>:
    case parity_none:
        break;
    case parity_odd:
        tmp |= UART_LCR_PEN_MASK;
80004672:	47f2                	lw	a5,28(sp)
80004674:	0087e793          	ori	a5,a5,8
80004678:	ce3e                	sw	a5,28(sp)
        break;
8000467a:	a01d                	j	800046a0 <.L36>

8000467c <.L33>:
    case parity_even:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_EPS_MASK;
8000467c:	47f2                	lw	a5,28(sp)
8000467e:	0187e793          	ori	a5,a5,24
80004682:	ce3e                	sw	a5,28(sp)
        break;
80004684:	a831                	j	800046a0 <.L36>

80004686 <.L32>:
    case parity_always_1:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_SPS_MASK;
80004686:	47f2                	lw	a5,28(sp)
80004688:	0287e793          	ori	a5,a5,40
8000468c:	ce3e                	sw	a5,28(sp)
        break;
8000468e:	a809                	j	800046a0 <.L36>

80004690 <.L30>:
    case parity_always_0:
        tmp |= UART_LCR_EPS_MASK | UART_LCR_PEN_MASK
80004690:	47f2                	lw	a5,28(sp)
80004692:	0387e793          	ori	a5,a5,56
80004696:	ce3e                	sw	a5,28(sp)
            | UART_LCR_SPS_MASK;
        break;
80004698:	a021                	j	800046a0 <.L36>

8000469a <.L29>:
    default:
        /* invalid configuration */
        return status_invalid_argument;
8000469a:	4789                	li	a5,2
8000469c:	a8ed                	j	80004796 <.L44>

8000469e <.L45>:
        break;
8000469e:	0001                	nop

800046a0 <.L36>:
    }

    tmp &= ~(UART_LCR_STB_MASK | UART_LCR_WLS_MASK);
800046a0:	47f2                	lw	a5,28(sp)
800046a2:	9be1                	andi	a5,a5,-8
800046a4:	ce3e                	sw	a5,28(sp)
    switch (config->num_of_stop_bits) {
800046a6:	47a2                	lw	a5,8(sp)
800046a8:	0087c783          	lbu	a5,8(a5)
800046ac:	4709                	li	a4,2
800046ae:	00e78e63          	beq	a5,a4,800046ca <.L37>
800046b2:	4709                	li	a4,2
800046b4:	02f74663          	blt	a4,a5,800046e0 <.L38>
800046b8:	c795                	beqz	a5,800046e4 <.L46>
800046ba:	4705                	li	a4,1
800046bc:	02e79263          	bne	a5,a4,800046e0 <.L38>
    case stop_bits_1:
        break;
    case stop_bits_1_5:
        tmp |= UART_LCR_STB_MASK;
800046c0:	47f2                	lw	a5,28(sp)
800046c2:	0047e793          	ori	a5,a5,4
800046c6:	ce3e                	sw	a5,28(sp)
        break;
800046c8:	a839                	j	800046e6 <.L41>

800046ca <.L37>:
    case stop_bits_2:
        if (config->word_length < word_length_6_bits) {
800046ca:	47a2                	lw	a5,8(sp)
800046cc:	0097c783          	lbu	a5,9(a5)
800046d0:	e399                	bnez	a5,800046d6 <.L42>
            /* invalid configuration */
            return status_invalid_argument;
800046d2:	4789                	li	a5,2
800046d4:	a0c9                	j	80004796 <.L44>

800046d6 <.L42>:
        }
        tmp |= UART_LCR_STB_MASK;
800046d6:	47f2                	lw	a5,28(sp)
800046d8:	0047e793          	ori	a5,a5,4
800046dc:	ce3e                	sw	a5,28(sp)
        break;
800046de:	a021                	j	800046e6 <.L41>

800046e0 <.L38>:
    default:
        /* invalid configuration */
        return status_invalid_argument;
800046e0:	4789                	li	a5,2
800046e2:	a855                	j	80004796 <.L44>

800046e4 <.L46>:
        break;
800046e4:	0001                	nop

800046e6 <.L41>:
    }

    ptr->LCR = tmp | UART_LCR_WLS_SET(config->word_length);
800046e6:	47a2                	lw	a5,8(sp)
800046e8:	0097c783          	lbu	a5,9(a5)
800046ec:	0037f713          	andi	a4,a5,3
800046f0:	47f2                	lw	a5,28(sp)
800046f2:	8f5d                	or	a4,a4,a5
800046f4:	47b2                	lw	a5,12(sp)
800046f6:	d7d8                	sw	a4,44(a5)

#if defined(HPM_IP_FEATURE_UART_FINE_FIFO_THRLD) && (HPM_IP_FEATURE_UART_FINE_FIFO_THRLD == 1)
    /* reset TX and RX fifo */
    ptr->FCRR = UART_FCRR_TFIFORST_MASK | UART_FCRR_RFIFORST_MASK;
800046f8:	47b2                	lw	a5,12(sp)
800046fa:	4719                	li	a4,6
800046fc:	cf98                	sw	a4,24(a5)
    /* Enable FIFO */
    ptr->FCRR = UART_FCRR_FIFOT4EN_MASK
        | UART_FCRR_FIFOE_SET(config->fifo_enable)
800046fe:	47a2                	lw	a5,8(sp)
80004700:	00e7c783          	lbu	a5,14(a5)
80004704:	86be                	mv	a3,a5
        | UART_FCRR_TFIFOT4_SET(config->tx_fifo_level)
80004706:	47a2                	lw	a5,8(sp)
80004708:	00b7c783          	lbu	a5,11(a5)
8000470c:	01079713          	slli	a4,a5,0x10
80004710:	001f07b7          	lui	a5,0x1f0
80004714:	8ff9                	and	a5,a5,a4
80004716:	00f6e733          	or	a4,a3,a5
        | UART_FCRR_RFIFOT4_SET(config->rx_fifo_level)
8000471a:	47a2                	lw	a5,8(sp)
8000471c:	00c7c783          	lbu	a5,12(a5) # 1f000c <_flash_size+0xf000c>
80004720:	00879693          	slli	a3,a5,0x8
80004724:	6789                	lui	a5,0x2
80004726:	f0078793          	addi	a5,a5,-256 # 1f00 <__NOR_CFG_OPTION_segment_size__+0x1300>
8000472a:	8ff5                	and	a5,a5,a3
8000472c:	8f5d                	or	a4,a4,a5
#if defined(HPM_IP_FEATURE_UART_DISABLE_DMA_TIMEOUT) && (HPM_IP_FEATURE_UART_DISABLE_DMA_TIMEOUT == 1)
        | UART_FCRR_TMOUT_RXDMA_DIS_MASK /**< disable RX timeout trigger dma */
#endif
        | UART_FCRR_DMAE_SET(config->dma_enable);
8000472e:	47a2                	lw	a5,8(sp)
80004730:	00d7c783          	lbu	a5,13(a5)
80004734:	078e                	slli	a5,a5,0x3
80004736:	8ba1                	andi	a5,a5,8
80004738:	8f5d                	or	a4,a4,a5
8000473a:	008007b7          	lui	a5,0x800
8000473e:	8f5d                	or	a4,a4,a5
    ptr->FCRR = UART_FCRR_FIFOT4EN_MASK
80004740:	47b2                	lw	a5,12(sp)
80004742:	cf98                	sw	a4,24(a5)
    ptr->FCR = tmp;
    /* store FCR register value */
    ptr->GPR = tmp;
#endif

    uart_modem_config(ptr, &config->modem_config);
80004744:	47a2                	lw	a5,8(sp)
80004746:	07bd                	addi	a5,a5,15 # 80000f <_flash_size+0x70000f>
80004748:	85be                	mv	a1,a5
8000474a:	4532                	lw	a0,12(sp)
8000474c:	3a8020ef          	jal	80006af4 <uart_modem_config>

#if defined(HPM_IP_FEATURE_UART_RX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_RX_IDLE_DETECT == 1)
    uart_init_rxline_idle_detection(ptr, config->rxidle_config);
80004750:	47a2                	lw	a5,8(sp)
80004752:	0127d703          	lhu	a4,18(a5)
80004756:	0147d783          	lhu	a5,20(a5)
8000475a:	07c2                	slli	a5,a5,0x10
8000475c:	8fd9                	or	a5,a5,a4
8000475e:	873e                	mv	a4,a5
80004760:	85ba                	mv	a1,a4
80004762:	4532                	lw	a0,12(sp)
80004764:	4d4020ef          	jal	80006c38 <uart_init_rxline_idle_detection>
#endif

#if defined(HPM_IP_FEATURE_UART_TX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_TX_IDLE_DETECT == 1)
    uart_init_txline_idle_detection(ptr, config->txidle_config);
80004768:	47a2                	lw	a5,8(sp)
8000476a:	0167d703          	lhu	a4,22(a5)
8000476e:	0187d783          	lhu	a5,24(a5)
80004772:	07c2                	slli	a5,a5,0x10
80004774:	8fd9                	or	a5,a5,a4
80004776:	873e                	mv	a4,a5
80004778:	85ba                	mv	a1,a4
8000477a:	4532                	lw	a0,12(sp)
8000477c:	2885                	jal	800047ec <uart_init_txline_idle_detection>
#endif

#if defined(HPM_IP_FEATURE_UART_RX_EN) && (HPM_IP_FEATURE_UART_RX_EN == 1)
    if (config->rx_enable) {
8000477e:	47a2                	lw	a5,8(sp)
80004780:	01a7c783          	lbu	a5,26(a5)
80004784:	cb81                	beqz	a5,80004794 <.L43>
        ptr->IDLE_CFG |= UART_IDLE_CFG_RXEN_MASK;
80004786:	47b2                	lw	a5,12(sp)
80004788:	43d8                	lw	a4,4(a5)
8000478a:	28b01793          	bseti	a5,zero,0xb
8000478e:	8f5d                	or	a4,a4,a5
80004790:	47b2                	lw	a5,12(sp)
80004792:	c3d8                	sw	a4,4(a5)

80004794 <.L43>:
    }
#endif
    return status_success;
80004794:	4781                	li	a5,0

80004796 <.L44>:
}
80004796:	853e                	mv	a0,a5
80004798:	50b2                	lw	ra,44(sp)
8000479a:	6145                	addi	sp,sp,48
8000479c:	8082                	ret

Disassembly of section .text.uart_send_byte:

8000479e <uart_send_byte>:

    return status_success;
}

hpm_stat_t uart_send_byte(UART_Type *ptr, uint8_t c)
{
8000479e:	1101                	addi	sp,sp,-32
800047a0:	c62a                	sw	a0,12(sp)
800047a2:	87ae                	mv	a5,a1
800047a4:	00f105a3          	sb	a5,11(sp)
    uint32_t retry = 0;
800047a8:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
800047aa:	a811                	j	800047be <.L52>

800047ac <.L55>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
800047ac:	4772                	lw	a4,28(sp)
800047ae:	6785                	lui	a5,0x1
800047b0:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
800047b4:	00e7eb63          	bltu	a5,a4,800047ca <.L58>
            break;
        }
        retry++;
800047b8:	47f2                	lw	a5,28(sp)
800047ba:	0785                	addi	a5,a5,1
800047bc:	ce3e                	sw	a5,28(sp)

800047be <.L52>:
    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
800047be:	47b2                	lw	a5,12(sp)
800047c0:	5bdc                	lw	a5,52(a5)
800047c2:	0207f793          	andi	a5,a5,32
800047c6:	d3fd                	beqz	a5,800047ac <.L55>
800047c8:	a011                	j	800047cc <.L54>

800047ca <.L58>:
            break;
800047ca:	0001                	nop

800047cc <.L54>:
    }

    if (retry > HPM_UART_DRV_RETRY_COUNT) {
800047cc:	4772                	lw	a4,28(sp)
800047ce:	6785                	lui	a5,0x1
800047d0:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
800047d4:	00e7f463          	bgeu	a5,a4,800047dc <.L56>
        return status_timeout;
800047d8:	478d                	li	a5,3
800047da:	a031                	j	800047e6 <.L57>

800047dc <.L56>:
    }

    ptr->THR = UART_THR_THR_SET(c);
800047dc:	00b14703          	lbu	a4,11(sp)
800047e0:	47b2                	lw	a5,12(sp)
800047e2:	d398                	sw	a4,32(a5)
    return status_success;
800047e4:	4781                	li	a5,0

800047e6 <.L57>:
}
800047e6:	853e                	mv	a0,a5
800047e8:	6105                	addi	sp,sp,32
800047ea:	8082                	ret

Disassembly of section .text.uart_init_txline_idle_detection:

800047ec <uart_init_txline_idle_detection>:
}
#endif

#if defined(HPM_IP_FEATURE_UART_TX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_TX_IDLE_DETECT == 1)
hpm_stat_t uart_init_txline_idle_detection(UART_Type *ptr, uart_rxline_idle_config_t txidle_config)
{
800047ec:	1101                	addi	sp,sp,-32
800047ee:	ce06                	sw	ra,28(sp)
800047f0:	c62a                	sw	a0,12(sp)
800047f2:	c42e                	sw	a1,8(sp)
    ptr->IDLE_CFG &= ~(UART_IDLE_CFG_TX_IDLE_EN_MASK
800047f4:	47b2                	lw	a5,12(sp)
800047f6:	43d8                	lw	a4,4(a5)
800047f8:	fc0107b7          	lui	a5,0xfc010
800047fc:	17fd                	addi	a5,a5,-1 # fc00ffff <__AHB_SRAM_segment_end__+0xbc07fff>
800047fe:	8f7d                	and	a4,a4,a5
80004800:	47b2                	lw	a5,12(sp)
80004802:	c3d8                	sw	a4,4(a5)
                    | UART_IDLE_CFG_TX_IDLE_THR_MASK
                    | UART_IDLE_CFG_TX_IDLE_COND_MASK);
    ptr->IDLE_CFG |= UART_IDLE_CFG_TX_IDLE_EN_SET(txidle_config.detect_enable)
80004804:	47b2                	lw	a5,12(sp)
80004806:	43d8                	lw	a4,4(a5)
80004808:	00814783          	lbu	a5,8(sp)
8000480c:	01879693          	slli	a3,a5,0x18
80004810:	010007b7          	lui	a5,0x1000
80004814:	8efd                	and	a3,a3,a5
                    | UART_IDLE_CFG_TX_IDLE_THR_SET(txidle_config.threshold)
80004816:	00b14783          	lbu	a5,11(sp)
8000481a:	01079613          	slli	a2,a5,0x10
8000481e:	00ff07b7          	lui	a5,0xff0
80004822:	8ff1                	and	a5,a5,a2
80004824:	8edd                	or	a3,a3,a5
                    | UART_IDLE_CFG_TX_IDLE_COND_SET(txidle_config.idle_cond);
80004826:	00a14783          	lbu	a5,10(sp)
8000482a:	01979613          	slli	a2,a5,0x19
8000482e:	020007b7          	lui	a5,0x2000
80004832:	8ff1                	and	a5,a5,a2
80004834:	8fd5                	or	a5,a5,a3
    ptr->IDLE_CFG |= UART_IDLE_CFG_TX_IDLE_EN_SET(txidle_config.detect_enable)
80004836:	8f5d                	or	a4,a4,a5
80004838:	47b2                	lw	a5,12(sp)
8000483a:	c3d8                	sw	a4,4(a5)

    if (txidle_config.detect_irq_enable) {
8000483c:	00914783          	lbu	a5,9(sp)
80004840:	c799                	beqz	a5,8000484e <.L97>
        uart_enable_irq(ptr, uart_intr_tx_line_idle);
80004842:	400005b7          	lui	a1,0x40000
80004846:	4532                	lw	a0,12(sp)
80004848:	304020ef          	jal	80006b4c <uart_enable_irq>
8000484c:	a031                	j	80004858 <.L98>

8000484e <.L97>:
    } else {
        uart_disable_irq(ptr, uart_intr_tx_line_idle);
8000484e:	400005b7          	lui	a1,0x40000
80004852:	4532                	lw	a0,12(sp)
80004854:	2dc020ef          	jal	80006b30 <uart_disable_irq>

80004858 <.L98>:
    }

    return status_success;
80004858:	4781                	li	a5,0
}
8000485a:	853e                	mv	a0,a5
8000485c:	40f2                	lw	ra,28(sp)
8000485e:	6105                	addi	sp,sp,32
80004860:	8082                	ret

Disassembly of section .text.gpio_config_pin_interrupt:

80004862 <gpio_config_pin_interrupt>:
    }
}


void gpio_config_pin_interrupt(GPIO_Type *ptr, uint32_t gpio_index, uint8_t pin_index, gpio_interrupt_trigger_t trigger)
{
80004862:	1141                	addi	sp,sp,-16
80004864:	c62a                	sw	a0,12(sp)
80004866:	c42e                	sw	a1,8(sp)
80004868:	87b2                	mv	a5,a2
8000486a:	8736                	mv	a4,a3
8000486c:	00f103a3          	sb	a5,7(sp)
80004870:	87ba                	mv	a5,a4
80004872:	00f10323          	sb	a5,6(sp)
    switch (trigger) {
80004876:	00614783          	lbu	a5,6(sp)
8000487a:	4711                	li	a4,4
8000487c:	0ee78863          	beq	a5,a4,8000496c <.L12>
80004880:	4711                	li	a4,4
80004882:	12f74063          	blt	a4,a5,800049a2 <.L23>
80004886:	4705                	li	a4,1
80004888:	00f74563          	blt	a4,a5,80004892 <.L14>
8000488c:	0007d963          	bgez	a5,8000489e <.L15>
        ptr->TP[gpio_index].SET = 1 << pin_index;
        ptr->PD[gpio_index].SET = 1 << pin_index;
        break;
#endif
    default:
        return;
80004890:	aa09                	j	800049a2 <.L23>

80004892 <.L14>:
80004892:	ffe78713          	addi	a4,a5,-2 # 1fffffe <_flash_size+0x1effffe>
    switch (trigger) {
80004896:	4785                	li	a5,1
80004898:	10e7e563          	bltu	a5,a4,800049a2 <.L23>
8000489c:	a8a9                	j	800048f6 <.L22>

8000489e <.L15>:
        ptr->TP[gpio_index].CLEAR = 1 << pin_index;
8000489e:	00714783          	lbu	a5,7(sp)
800048a2:	4705                	li	a4,1
800048a4:	00f717b3          	sll	a5,a4,a5
800048a8:	86be                	mv	a3,a5
800048aa:	4732                	lw	a4,12(sp)
800048ac:	47a2                	lw	a5,8(sp)
800048ae:	06078793          	addi	a5,a5,96
800048b2:	0792                	slli	a5,a5,0x4
800048b4:	97ba                	add	a5,a5,a4
800048b6:	c794                	sw	a3,8(a5)
        if (trigger == gpio_interrupt_trigger_level_high) {
800048b8:	00614783          	lbu	a5,6(sp)
800048bc:	ef99                	bnez	a5,800048da <.L17>
            ptr->PL[gpio_index].CLEAR = 1 << pin_index;
800048be:	00714783          	lbu	a5,7(sp)
800048c2:	4705                	li	a4,1
800048c4:	00f717b3          	sll	a5,a4,a5
800048c8:	86be                	mv	a3,a5
800048ca:	4732                	lw	a4,12(sp)
800048cc:	47a2                	lw	a5,8(sp)
800048ce:	05078793          	addi	a5,a5,80
800048d2:	0792                	slli	a5,a5,0x4
800048d4:	97ba                	add	a5,a5,a4
800048d6:	c794                	sw	a3,8(a5)
        break;
800048d8:	a0f1                	j	800049a4 <.L11>

800048da <.L17>:
            ptr->PL[gpio_index].SET = 1 << pin_index;
800048da:	00714783          	lbu	a5,7(sp)
800048de:	4705                	li	a4,1
800048e0:	00f717b3          	sll	a5,a4,a5
800048e4:	86be                	mv	a3,a5
800048e6:	4732                	lw	a4,12(sp)
800048e8:	47a2                	lw	a5,8(sp)
800048ea:	05078793          	addi	a5,a5,80
800048ee:	0792                	slli	a5,a5,0x4
800048f0:	97ba                	add	a5,a5,a4
800048f2:	c3d4                	sw	a3,4(a5)
        break;
800048f4:	a845                	j	800049a4 <.L11>

800048f6 <.L22>:
        ptr->PD[gpio_index].CLEAR = 1 << pin_index;
800048f6:	00714783          	lbu	a5,7(sp)
800048fa:	4705                	li	a4,1
800048fc:	00f717b3          	sll	a5,a4,a5
80004900:	86be                	mv	a3,a5
80004902:	4732                	lw	a4,12(sp)
80004904:	47a2                	lw	a5,8(sp)
80004906:	08078793          	addi	a5,a5,128
8000490a:	0792                	slli	a5,a5,0x4
8000490c:	97ba                	add	a5,a5,a4
8000490e:	c794                	sw	a3,8(a5)
        ptr->TP[gpio_index].SET = 1 << pin_index;
80004910:	00714783          	lbu	a5,7(sp)
80004914:	4705                	li	a4,1
80004916:	00f717b3          	sll	a5,a4,a5
8000491a:	86be                	mv	a3,a5
8000491c:	4732                	lw	a4,12(sp)
8000491e:	47a2                	lw	a5,8(sp)
80004920:	06078793          	addi	a5,a5,96
80004924:	0792                	slli	a5,a5,0x4
80004926:	97ba                	add	a5,a5,a4
80004928:	c3d4                	sw	a3,4(a5)
        if (trigger == gpio_interrupt_trigger_edge_rising) {
8000492a:	00614703          	lbu	a4,6(sp)
8000492e:	4789                	li	a5,2
80004930:	02f71063          	bne	a4,a5,80004950 <.L20>
            ptr->PL[gpio_index].CLEAR = 1 << pin_index;
80004934:	00714783          	lbu	a5,7(sp)
80004938:	4705                	li	a4,1
8000493a:	00f717b3          	sll	a5,a4,a5
8000493e:	86be                	mv	a3,a5
80004940:	4732                	lw	a4,12(sp)
80004942:	47a2                	lw	a5,8(sp)
80004944:	05078793          	addi	a5,a5,80
80004948:	0792                	slli	a5,a5,0x4
8000494a:	97ba                	add	a5,a5,a4
8000494c:	c794                	sw	a3,8(a5)
        break;
8000494e:	a899                	j	800049a4 <.L11>

80004950 <.L20>:
            ptr->PL[gpio_index].SET = 1 << pin_index;
80004950:	00714783          	lbu	a5,7(sp)
80004954:	4705                	li	a4,1
80004956:	00f717b3          	sll	a5,a4,a5
8000495a:	86be                	mv	a3,a5
8000495c:	4732                	lw	a4,12(sp)
8000495e:	47a2                	lw	a5,8(sp)
80004960:	05078793          	addi	a5,a5,80
80004964:	0792                	slli	a5,a5,0x4
80004966:	97ba                	add	a5,a5,a4
80004968:	c3d4                	sw	a3,4(a5)
        break;
8000496a:	a82d                	j	800049a4 <.L11>

8000496c <.L12>:
        ptr->TP[gpio_index].SET = 1 << pin_index;
8000496c:	00714783          	lbu	a5,7(sp)
80004970:	4705                	li	a4,1
80004972:	00f717b3          	sll	a5,a4,a5
80004976:	86be                	mv	a3,a5
80004978:	4732                	lw	a4,12(sp)
8000497a:	47a2                	lw	a5,8(sp)
8000497c:	06078793          	addi	a5,a5,96
80004980:	0792                	slli	a5,a5,0x4
80004982:	97ba                	add	a5,a5,a4
80004984:	c3d4                	sw	a3,4(a5)
        ptr->PD[gpio_index].SET = 1 << pin_index;
80004986:	00714783          	lbu	a5,7(sp)
8000498a:	4705                	li	a4,1
8000498c:	00f717b3          	sll	a5,a4,a5
80004990:	86be                	mv	a3,a5
80004992:	4732                	lw	a4,12(sp)
80004994:	47a2                	lw	a5,8(sp)
80004996:	08078793          	addi	a5,a5,128
8000499a:	0792                	slli	a5,a5,0x4
8000499c:	97ba                	add	a5,a5,a4
8000499e:	c3d4                	sw	a3,4(a5)
        break;
800049a0:	a011                	j	800049a4 <.L11>

800049a2 <.L23>:
        return;
800049a2:	0001                	nop

800049a4 <.L11>:
    }
}
800049a4:	0141                	addi	sp,sp,16
800049a6:	8082                	ret

Disassembly of section .text.pllctlv2_pll_is_stable:

800049a8 <pllctlv2_pll_is_stable>:
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @param [in] pll Index of the PLL to check (pllctlv2_pll0 through pllctlv2_pll6)
 * @return true if the PLL is stable and locked, false otherwise
 */
static inline bool pllctlv2_pll_is_stable(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll)
{
800049a8:	1101                	addi	sp,sp,-32
800049aa:	c62a                	sw	a0,12(sp)
800049ac:	87ae                	mv	a5,a1
800049ae:	00f105a3          	sb	a5,11(sp)
    uint32_t status = ptr->PLL[pll].MFI;
800049b2:	00b14783          	lbu	a5,11(sp)
800049b6:	4732                	lw	a4,12(sp)
800049b8:	0785                	addi	a5,a5,1
800049ba:	079e                	slli	a5,a5,0x7
800049bc:	97ba                	add	a5,a5,a4
800049be:	439c                	lw	a5,0(a5)
800049c0:	ce3e                	sw	a5,28(sp)
    return (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_MFI_ENABLE_MASK)
800049c2:	4772                	lw	a4,28(sp)
800049c4:	100007b7          	lui	a5,0x10000
800049c8:	8ff9                	and	a5,a5,a4
         || (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_MFI_BUSY_MASK) && IS_HPM_BITMASK_SET(status, PLLCTLV2_PLL_MFI_RESPONSE_MASK)));
800049ca:	cb89                	beqz	a5,800049dc <.L2>
800049cc:	47f2                	lw	a5,28(sp)
800049ce:	0007c963          	bltz	a5,800049e0 <.L3>
800049d2:	4772                	lw	a4,28(sp)
800049d4:	200007b7          	lui	a5,0x20000
800049d8:	8ff9                	and	a5,a5,a4
800049da:	c399                	beqz	a5,800049e0 <.L3>

800049dc <.L2>:
800049dc:	4785                	li	a5,1
800049de:	a011                	j	800049e2 <.L4>

800049e0 <.L3>:
800049e0:	4781                	li	a5,0

800049e2 <.L4>:
800049e2:	8b85                	andi	a5,a5,1
800049e4:	0ff7f793          	zext.b	a5,a5
}
800049e8:	853e                	mv	a0,a5
800049ea:	6105                	addi	sp,sp,32
800049ec:	8082                	ret

Disassembly of section .text.pllctlv2_init_pll_with_freq:

800049ee <pllctlv2_init_pll_with_freq>:
    }
    return status;
}

hpm_stat_t pllctlv2_init_pll_with_freq(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, uint32_t freq_in_hz)
{
800049ee:	7179                	addi	sp,sp,-48
800049f0:	d606                	sw	ra,44(sp)
800049f2:	c62a                	sw	a0,12(sp)
800049f4:	87ae                	mv	a5,a1
800049f6:	c232                	sw	a2,4(sp)
800049f8:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status;
    if ((ptr == NULL) || (freq_in_hz < PLLCTLV2_PLL_FREQ_MIN) || (freq_in_hz > PLLCTLV2_PLL_FREQ_MAX) ||
800049fc:	47b2                	lw	a5,12(sp)
800049fe:	c395                	beqz	a5,80004a22 <.L19>
80004a00:	4712                	lw	a4,4(sp)
80004a02:	16e367b7          	lui	a5,0x16e36
80004a06:	00f76e63          	bltu	a4,a5,80004a22 <.L19>
80004a0a:	4712                	lw	a4,4(sp)
80004a0c:	3d8317b7          	lui	a5,0x3d831
80004a10:	20078793          	addi	a5,a5,512 # 3d831200 <_flash_size+0x3d731200>
80004a14:	00e7e763          	bltu	a5,a4,80004a22 <.L19>
80004a18:	00b14703          	lbu	a4,11(sp)
80004a1c:	4785                	li	a5,1
80004a1e:	00e7f563          	bgeu	a5,a4,80004a28 <.L20>

80004a22 <.L19>:
        (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
        status = status_invalid_argument;
80004a22:	4789                	li	a5,2
80004a24:	ce3e                	sw	a5,28(sp)
80004a26:	a8bd                	j	80004aa4 <.L21>

80004a28 <.L20>:
    } else {
        uint32_t mfn = freq_in_hz % PLLCTLV2_PLL_XTAL_FREQ;
80004a28:	4792                	lw	a5,4(sp)
80004a2a:	165ea737          	lui	a4,0x165ea
80004a2e:	f8170713          	addi	a4,a4,-127 # 165e9f81 <_flash_size+0x164e9f81>
80004a32:	02e7b733          	mulhu	a4,a5,a4
80004a36:	01575693          	srli	a3,a4,0x15
80004a3a:	016e3737          	lui	a4,0x16e3
80004a3e:	60070713          	addi	a4,a4,1536 # 16e3600 <_flash_size+0x15e3600>
80004a42:	02e68733          	mul	a4,a3,a4
80004a46:	8f99                	sub	a5,a5,a4
80004a48:	cc3e                	sw	a5,24(sp)
        uint32_t mfi = freq_in_hz / PLLCTLV2_PLL_XTAL_FREQ;
80004a4a:	4712                	lw	a4,4(sp)
80004a4c:	165ea7b7          	lui	a5,0x165ea
80004a50:	f8178793          	addi	a5,a5,-127 # 165e9f81 <_flash_size+0x164e9f81>
80004a54:	02f737b3          	mulhu	a5,a4,a5
80004a58:	83d5                	srli	a5,a5,0x15
80004a5a:	ca3e                	sw	a5,20(sp)

        /*
         * NOTE: Default MFD value is 240M
         */
        ptr->PLL[pll].MFN = mfn * PLLCTLV2_PLL_MFN_FACTOR;
80004a5c:	00b14683          	lbu	a3,11(sp)
80004a60:	4762                	lw	a4,24(sp)
80004a62:	87ba                	mv	a5,a4
80004a64:	078a                	slli	a5,a5,0x2
80004a66:	97ba                	add	a5,a5,a4
80004a68:	0786                	slli	a5,a5,0x1
80004a6a:	863e                	mv	a2,a5
80004a6c:	4732                	lw	a4,12(sp)
80004a6e:	00168793          	addi	a5,a3,1
80004a72:	079e                	slli	a5,a5,0x7
80004a74:	97ba                	add	a5,a5,a4
80004a76:	c3d0                	sw	a2,4(a5)
        ptr->PLL[pll].MFI = mfi;
80004a78:	00b14783          	lbu	a5,11(sp)
80004a7c:	4732                	lw	a4,12(sp)
80004a7e:	0785                	addi	a5,a5,1
80004a80:	079e                	slli	a5,a5,0x7
80004a82:	97ba                	add	a5,a5,a4
80004a84:	4752                	lw	a4,20(sp)
80004a86:	c398                	sw	a4,0(a5)


        while (!pllctlv2_pll_is_stable(ptr, pll)) {
80004a88:	a011                	j	80004a8c <.L22>

80004a8a <.L23>:
            NOP();
80004a8a:	0001                	nop

80004a8c <.L22>:
        while (!pllctlv2_pll_is_stable(ptr, pll)) {
80004a8c:	00b14783          	lbu	a5,11(sp)
80004a90:	85be                	mv	a1,a5
80004a92:	4532                	lw	a0,12(sp)
80004a94:	3f11                	jal	800049a8 <pllctlv2_pll_is_stable>
80004a96:	87aa                	mv	a5,a0
80004a98:	0017c793          	xori	a5,a5,1
80004a9c:	0ff7f793          	zext.b	a5,a5
80004aa0:	f7ed                	bnez	a5,80004a8a <.L23>
        }

        status = status_success;
80004aa2:	ce02                	sw	zero,28(sp)

80004aa4 <.L21>:
    }
    return status;
80004aa4:	47f2                	lw	a5,28(sp)
}
80004aa6:	853e                	mv	a0,a5
80004aa8:	50b2                	lw	ra,44(sp)
80004aaa:	6145                	addi	sp,sp,48
80004aac:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_xtoa:

80004aae <__SEGGER_RTL_xtoa>:
80004aae:	882e                	mv	a6,a1
80004ab0:	ca91                	beqz	a3,80004ac4 <__SEGGER_RTL_xtoa+0x16>
80004ab2:	00180693          	addi	a3,a6,1
80004ab6:	02d00593          	li	a1,45
80004aba:	00b80023          	sb	a1,0(a6)
80004abe:	40a00533          	neg	a0,a0
80004ac2:	a011                	j	80004ac6 <__SEGGER_RTL_xtoa+0x18>
80004ac4:	86c2                	mv	a3,a6
80004ac6:	ffe68713          	addi	a4,a3,-2
80004aca:	48a5                	li	a7,9
80004acc:	85aa                	mv	a1,a0
80004ace:	02c55533          	divu	a0,a0,a2
80004ad2:	02c507b3          	mul	a5,a0,a2
80004ad6:	40f587b3          	sub	a5,a1,a5
80004ada:	00f8e563          	bltu	a7,a5,80004ae4 <__SEGGER_RTL_xtoa+0x36>
80004ade:	03078793          	addi	a5,a5,48
80004ae2:	a019                	j	80004ae8 <__SEGGER_RTL_xtoa+0x3a>
80004ae4:	05778793          	addi	a5,a5,87
80004ae8:	00f70123          	sb	a5,2(a4)
80004aec:	0705                	addi	a4,a4,1
80004aee:	fcc5ffe3          	bgeu	a1,a2,80004acc <__SEGGER_RTL_xtoa+0x1e>
80004af2:	00070123          	sb	zero,2(a4)
80004af6:	0006c503          	lbu	a0,0(a3)
80004afa:	85ba                	mv	a1,a4
80004afc:	00174603          	lbu	a2,1(a4)
80004b00:	00a700a3          	sb	a0,1(a4)
80004b04:	00168513          	addi	a0,a3,1
80004b08:	00c68023          	sb	a2,0(a3)
80004b0c:	177d                	addi	a4,a4,-1
80004b0e:	86aa                	mv	a3,a0
80004b10:	feb563e3          	bltu	a0,a1,80004af6 <__SEGGER_RTL_xtoa+0x48>
80004b14:	8542                	mv	a0,a6
80004b16:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_X_assert:

80004b18 <__SEGGER_RTL_X_assert>:
80004b18:	1101                	addi	sp,sp,-32
80004b1a:	ce06                	sw	ra,28(sp)
80004b1c:	cc22                	sw	s0,24(sp)
80004b1e:	ca26                	sw	s1,20(sp)
80004b20:	86b2                	mv	a3,a2
80004b22:	842e                	mv	s0,a1
80004b24:	84aa                	mv	s1,a0
80004b26:	004c                	addi	a1,sp,4
80004b28:	4629                	li	a2,10
80004b2a:	8536                	mv	a0,a3
80004b2c:	5e8020ef          	jal	80007114 <itoa>
80004b30:	8522                	mv	a0,s0
80004b32:	66c020ef          	jal	8000719e <__SEGGER_RTL_puts_no_nl>
80004b36:	80008537          	lui	a0,0x80008
80004b3a:	22750513          	addi	a0,a0,551 # 80008227 <.L.str>
80004b3e:	660020ef          	jal	8000719e <__SEGGER_RTL_puts_no_nl>
80004b42:	0048                	addi	a0,sp,4
80004b44:	65a020ef          	jal	8000719e <__SEGGER_RTL_puts_no_nl>
80004b48:	80008537          	lui	a0,0x80008
80004b4c:	26950513          	addi	a0,a0,617 # 80008269 <.L.str.1>
80004b50:	64e020ef          	jal	8000719e <__SEGGER_RTL_puts_no_nl>
80004b54:	8526                	mv	a0,s1
80004b56:	648020ef          	jal	8000719e <__SEGGER_RTL_puts_no_nl>
80004b5a:	80008537          	lui	a0,0x80008
80004b5e:	22950513          	addi	a0,a0,553 # 80008229 <.L.str.2>
80004b62:	63c020ef          	jal	8000719e <__SEGGER_RTL_puts_no_nl>
80004b66:	5da020ef          	jal	80007140 <abort>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_IGN:

80004b6a <__SEGGER_RTL_SIGNAL_SIG_IGN>:
80004b6a:	8082                	ret

Disassembly of section .text.libc.__subsf3:

80004b6c <__subsf3>:
80004b6c:	80000637          	lui	a2,0x80000
80004b70:	8db1                	xor	a1,a1,a2
80004b72:	a009                	j	80004b74 <__addsf3>

Disassembly of section .text.libc.__addsf3:

80004b74 <__addsf3>:
80004b74:	80000637          	lui	a2,0x80000
80004b78:	00b546b3          	xor	a3,a0,a1
80004b7c:	0806ca63          	bltz	a3,80004c10 <.L__addsf3_subtract>
80004b80:	00b57563          	bgeu	a0,a1,80004b8a <.L__addsf3_add_already_ordered>
80004b84:	86aa                	mv	a3,a0
80004b86:	852e                	mv	a0,a1
80004b88:	85b6                	mv	a1,a3

80004b8a <.L__addsf3_add_already_ordered>:
80004b8a:	00151713          	slli	a4,a0,0x1
80004b8e:	8361                	srli	a4,a4,0x18
80004b90:	00159693          	slli	a3,a1,0x1
80004b94:	82e1                	srli	a3,a3,0x18
80004b96:	0ff00293          	li	t0,255
80004b9a:	06570563          	beq	a4,t0,80004c04 <.L__addsf3_add_inf_or_nan>
80004b9e:	c325                	beqz	a4,80004bfe <.L__addsf3_zero>
80004ba0:	ceb1                	beqz	a3,80004bfc <.L__addsf3_add_done>
80004ba2:	40d706b3          	sub	a3,a4,a3
80004ba6:	42e1                	li	t0,24
80004ba8:	04d2ca63          	blt	t0,a3,80004bfc <.L__addsf3_add_done>
80004bac:	05a2                	slli	a1,a1,0x8
80004bae:	8dd1                	or	a1,a1,a2
80004bb0:	01755713          	srli	a4,a0,0x17
80004bb4:	0522                	slli	a0,a0,0x8
80004bb6:	8d51                	or	a0,a0,a2
80004bb8:	47e5                	li	a5,25
80004bba:	8f95                	sub	a5,a5,a3
80004bbc:	00f59633          	sll	a2,a1,a5
80004bc0:	821d                	srli	a2,a2,0x7
80004bc2:	00d5d5b3          	srl	a1,a1,a3
80004bc6:	00b507b3          	add	a5,a0,a1
80004bca:	00a7f463          	bgeu	a5,a0,80004bd2 <.L__addsf3_add_no_normalization>
80004bce:	8385                	srli	a5,a5,0x1
80004bd0:	0709                	addi	a4,a4,2

80004bd2 <.L__addsf3_add_no_normalization>:
80004bd2:	177d                	addi	a4,a4,-1
80004bd4:	0ff77593          	zext.b	a1,a4
80004bd8:	f0158593          	addi	a1,a1,-255 # 3fffff01 <_flash_size+0x3fefff01>
80004bdc:	cd91                	beqz	a1,80004bf8 <.L__addsf3_inf>
80004bde:	075e                	slli	a4,a4,0x17
80004be0:	0087d513          	srli	a0,a5,0x8
80004be4:	07e2                	slli	a5,a5,0x18
80004be6:	8fd1                	or	a5,a5,a2
80004be8:	0007d663          	bgez	a5,80004bf4 <.L__addsf3_no_tie>
80004bec:	0786                	slli	a5,a5,0x1
80004bee:	0505                	addi	a0,a0,1
80004bf0:	e391                	bnez	a5,80004bf4 <.L__addsf3_no_tie>
80004bf2:	9979                	andi	a0,a0,-2

80004bf4 <.L__addsf3_no_tie>:
80004bf4:	953a                	add	a0,a0,a4
80004bf6:	8082                	ret

80004bf8 <.L__addsf3_inf>:
80004bf8:	01771513          	slli	a0,a4,0x17

80004bfc <.L__addsf3_add_done>:
80004bfc:	8082                	ret

80004bfe <.L__addsf3_zero>:
80004bfe:	817d                	srli	a0,a0,0x1f
80004c00:	057e                	slli	a0,a0,0x1f
80004c02:	8082                	ret

80004c04 <.L__addsf3_add_inf_or_nan>:
80004c04:	00951613          	slli	a2,a0,0x9
80004c08:	da75                	beqz	a2,80004bfc <.L__addsf3_add_done>

80004c0a <.L__addsf3_return_nan>:
80004c0a:	7fc00537          	lui	a0,0x7fc00
80004c0e:	8082                	ret

80004c10 <.L__addsf3_subtract>:
80004c10:	8db1                	xor	a1,a1,a2
80004c12:	40b506b3          	sub	a3,a0,a1
80004c16:	00b57563          	bgeu	a0,a1,80004c20 <.L__addsf3_sub_already_ordered>
80004c1a:	8eb1                	xor	a3,a3,a2
80004c1c:	8d15                	sub	a0,a0,a3
80004c1e:	95b6                	add	a1,a1,a3

80004c20 <.L__addsf3_sub_already_ordered>:
80004c20:	00159693          	slli	a3,a1,0x1
80004c24:	82e1                	srli	a3,a3,0x18
80004c26:	00151713          	slli	a4,a0,0x1
80004c2a:	8361                	srli	a4,a4,0x18
80004c2c:	05a2                	slli	a1,a1,0x8
80004c2e:	8dd1                	or	a1,a1,a2
80004c30:	0ff00293          	li	t0,255
80004c34:	0c570c63          	beq	a4,t0,80004d0c <.L__addsf3_sub_inf_or_nan>
80004c38:	c2f5                	beqz	a3,80004d1c <.L__addsf3_sub_zero>
80004c3a:	40d706b3          	sub	a3,a4,a3
80004c3e:	c695                	beqz	a3,80004c6a <.L__addsf3_exponents_equal>
80004c40:	4285                	li	t0,1
80004c42:	08569063          	bne	a3,t0,80004cc2 <.L__addsf3_exponents_differ_by_more_than_1>
80004c46:	01755693          	srli	a3,a0,0x17
80004c4a:	0526                	slli	a0,a0,0x9
80004c4c:	00b532b3          	sltu	t0,a0,a1
80004c50:	8d0d                	sub	a0,a0,a1
80004c52:	02029263          	bnez	t0,80004c76 <.L__addsf3_normalization_steps>
80004c56:	06de                	slli	a3,a3,0x17
80004c58:	01751593          	slli	a1,a0,0x17
80004c5c:	8125                	srli	a0,a0,0x9
80004c5e:	0005d463          	bgez	a1,80004c66 <.L__addsf3_sub_no_tie_single>
80004c62:	0505                	addi	a0,a0,1 # 7fc00001 <_flash_size+0x7fb00001>
80004c64:	9979                	andi	a0,a0,-2

80004c66 <.L__addsf3_sub_no_tie_single>:
80004c66:	9536                	add	a0,a0,a3

80004c68 <.L__addsf3_sub_done>:
80004c68:	8082                	ret

80004c6a <.L__addsf3_exponents_equal>:
80004c6a:	01755693          	srli	a3,a0,0x17
80004c6e:	0526                	slli	a0,a0,0x9
80004c70:	0586                	slli	a1,a1,0x1
80004c72:	8d0d                	sub	a0,a0,a1
80004c74:	d975                	beqz	a0,80004c68 <.L__addsf3_sub_done>

80004c76 <.L__addsf3_normalization_steps>:
80004c76:	4581                	li	a1,0
80004c78:	01055793          	srli	a5,a0,0x10
80004c7c:	e399                	bnez	a5,80004c82 <.Ltmp0>
80004c7e:	0542                	slli	a0,a0,0x10
80004c80:	05c1                	addi	a1,a1,16

80004c82 <.Ltmp0>:
80004c82:	01855793          	srli	a5,a0,0x18
80004c86:	e399                	bnez	a5,80004c8c <.Ltmp1>
80004c88:	0522                	slli	a0,a0,0x8
80004c8a:	05a1                	addi	a1,a1,8

80004c8c <.Ltmp1>:
80004c8c:	01c55793          	srli	a5,a0,0x1c
80004c90:	e399                	bnez	a5,80004c96 <.Ltmp2>
80004c92:	0512                	slli	a0,a0,0x4
80004c94:	0591                	addi	a1,a1,4

80004c96 <.Ltmp2>:
80004c96:	01e55793          	srli	a5,a0,0x1e
80004c9a:	e399                	bnez	a5,80004ca0 <.Ltmp3>
80004c9c:	050a                	slli	a0,a0,0x2
80004c9e:	0589                	addi	a1,a1,2

80004ca0 <.Ltmp3>:
80004ca0:	00054463          	bltz	a0,80004ca8 <.Ltmp4>
80004ca4:	0506                	slli	a0,a0,0x1
80004ca6:	0585                	addi	a1,a1,1

80004ca8 <.Ltmp4>:
80004ca8:	0585                	addi	a1,a1,1
80004caa:	0506                	slli	a0,a0,0x1
80004cac:	00e5f763          	bgeu	a1,a4,80004cba <.L__addsf3_underflow>
80004cb0:	8e8d                	sub	a3,a3,a1
80004cb2:	06de                	slli	a3,a3,0x17
80004cb4:	8125                	srli	a0,a0,0x9
80004cb6:	9536                	add	a0,a0,a3
80004cb8:	8082                	ret

80004cba <.L__addsf3_underflow>:
80004cba:	0086d513          	srli	a0,a3,0x8
80004cbe:	057e                	slli	a0,a0,0x1f
80004cc0:	8082                	ret

80004cc2 <.L__addsf3_exponents_differ_by_more_than_1>:
80004cc2:	42e5                	li	t0,25
80004cc4:	fad2e2e3          	bltu	t0,a3,80004c68 <.L__addsf3_sub_done>
80004cc8:	0685                	addi	a3,a3,1
80004cca:	40d00733          	neg	a4,a3
80004cce:	00e59733          	sll	a4,a1,a4
80004cd2:	00d5d5b3          	srl	a1,a1,a3
80004cd6:	00e03733          	snez	a4,a4
80004cda:	95ae                	add	a1,a1,a1
80004cdc:	95ba                	add	a1,a1,a4
80004cde:	01755693          	srli	a3,a0,0x17
80004ce2:	0522                	slli	a0,a0,0x8
80004ce4:	8d51                	or	a0,a0,a2
80004ce6:	40b50733          	sub	a4,a0,a1
80004cea:	00074463          	bltz	a4,80004cf2 <.L__addsf3_sub_already_normalized>
80004cee:	070a                	slli	a4,a4,0x2
80004cf0:	8305                	srli	a4,a4,0x1

80004cf2 <.L__addsf3_sub_already_normalized>:
80004cf2:	16fd                	addi	a3,a3,-1
80004cf4:	06de                	slli	a3,a3,0x17
80004cf6:	00875513          	srli	a0,a4,0x8
80004cfa:	0762                	slli	a4,a4,0x18
80004cfc:	00075663          	bgez	a4,80004d08 <.L__addsf3_sub_no_tie>
80004d00:	0706                	slli	a4,a4,0x1
80004d02:	0505                	addi	a0,a0,1
80004d04:	e311                	bnez	a4,80004d08 <.L__addsf3_sub_no_tie>
80004d06:	9979                	andi	a0,a0,-2

80004d08 <.L__addsf3_sub_no_tie>:
80004d08:	9536                	add	a0,a0,a3
80004d0a:	8082                	ret

80004d0c <.L__addsf3_sub_inf_or_nan>:
80004d0c:	0ff00293          	li	t0,255
80004d10:	ee568de3          	beq	a3,t0,80004c0a <.L__addsf3_return_nan>
80004d14:	00951593          	slli	a1,a0,0x9
80004d18:	d9a1                	beqz	a1,80004c68 <.L__addsf3_sub_done>
80004d1a:	bdc5                	j	80004c0a <.L__addsf3_return_nan>

80004d1c <.L__addsf3_sub_zero>:
80004d1c:	f731                	bnez	a4,80004c68 <.L__addsf3_sub_done>
80004d1e:	4501                	li	a0,0
80004d20:	8082                	ret

Disassembly of section .text.libc.__ltsf2:

80004d22 <__ltsf2>:
80004d22:	ff000637          	lui	a2,0xff000
80004d26:	00151693          	slli	a3,a0,0x1
80004d2a:	02d66763          	bltu	a2,a3,80004d58 <.L__ltsf2_zero>
80004d2e:	00159693          	slli	a3,a1,0x1
80004d32:	02d66363          	bltu	a2,a3,80004d58 <.L__ltsf2_zero>
80004d36:	00b56633          	or	a2,a0,a1
80004d3a:	00161693          	slli	a3,a2,0x1
80004d3e:	ce89                	beqz	a3,80004d58 <.L__ltsf2_zero>
80004d40:	00064763          	bltz	a2,80004d4e <.L__ltsf2_negative>
80004d44:	00b53533          	sltu	a0,a0,a1
80004d48:	40a00533          	neg	a0,a0
80004d4c:	8082                	ret

80004d4e <.L__ltsf2_negative>:
80004d4e:	00a5b533          	sltu	a0,a1,a0
80004d52:	40a00533          	neg	a0,a0
80004d56:	8082                	ret

80004d58 <.L__ltsf2_zero>:
80004d58:	4501                	li	a0,0
80004d5a:	8082                	ret

Disassembly of section .text.libc.__gtsf2:

80004d5c <__gtsf2>:
80004d5c:	ff000637          	lui	a2,0xff000
80004d60:	00151693          	slli	a3,a0,0x1
80004d64:	02d66363          	bltu	a2,a3,80004d8a <.L__gtsf2_zero>
80004d68:	00159693          	slli	a3,a1,0x1
80004d6c:	00d66f63          	bltu	a2,a3,80004d8a <.L__gtsf2_zero>
80004d70:	00b56633          	or	a2,a0,a1
80004d74:	00161693          	slli	a3,a2,0x1
80004d78:	ca89                	beqz	a3,80004d8a <.L__gtsf2_zero>
80004d7a:	00064563          	bltz	a2,80004d84 <.L__gtsf2_negative>
80004d7e:	00a5b533          	sltu	a0,a1,a0
80004d82:	8082                	ret

80004d84 <.L__gtsf2_negative>:
80004d84:	00b53533          	sltu	a0,a0,a1
80004d88:	8082                	ret

80004d8a <.L__gtsf2_zero>:
80004d8a:	4501                	li	a0,0
80004d8c:	8082                	ret

Disassembly of section .text.libc.__gesf2:

80004d8e <__gesf2>:
80004d8e:	ff000637          	lui	a2,0xff000
80004d92:	00151693          	slli	a3,a0,0x1
80004d96:	02d66763          	bltu	a2,a3,80004dc4 <.L__gesf2_nan>
80004d9a:	00159693          	slli	a3,a1,0x1
80004d9e:	02d66363          	bltu	a2,a3,80004dc4 <.L__gesf2_nan>
80004da2:	00b56633          	or	a2,a0,a1
80004da6:	00161693          	slli	a3,a2,0x1
80004daa:	ce99                	beqz	a3,80004dc8 <.L__gesf2_zero>
80004dac:	00064763          	bltz	a2,80004dba <.L__gesf2_negative>
80004db0:	00b53533          	sltu	a0,a0,a1
80004db4:	40a00533          	neg	a0,a0
80004db8:	8082                	ret

80004dba <.L__gesf2_negative>:
80004dba:	00a5b533          	sltu	a0,a1,a0
80004dbe:	40a00533          	neg	a0,a0
80004dc2:	8082                	ret

80004dc4 <.L__gesf2_nan>:
80004dc4:	557d                	li	a0,-1
80004dc6:	8082                	ret

80004dc8 <.L__gesf2_zero>:
80004dc8:	4501                	li	a0,0
80004dca:	8082                	ret

Disassembly of section .text.libc.__floatundisf:

80004dcc <__floatundisf>:
80004dcc:	c5bd                	beqz	a1,80004e3a <.L__floatundisf_high_word_zero>
80004dce:	4701                	li	a4,0
80004dd0:	0105d693          	srli	a3,a1,0x10
80004dd4:	e299                	bnez	a3,80004dda <.Ltmp45>
80004dd6:	0741                	addi	a4,a4,16
80004dd8:	05c2                	slli	a1,a1,0x10

80004dda <.Ltmp45>:
80004dda:	0185d693          	srli	a3,a1,0x18
80004dde:	e299                	bnez	a3,80004de4 <.Ltmp46>
80004de0:	0721                	addi	a4,a4,8
80004de2:	05a2                	slli	a1,a1,0x8

80004de4 <.Ltmp46>:
80004de4:	01c5d693          	srli	a3,a1,0x1c
80004de8:	e299                	bnez	a3,80004dee <.Ltmp47>
80004dea:	0711                	addi	a4,a4,4
80004dec:	0592                	slli	a1,a1,0x4

80004dee <.Ltmp47>:
80004dee:	01e5d693          	srli	a3,a1,0x1e
80004df2:	e299                	bnez	a3,80004df8 <.Ltmp48>
80004df4:	0709                	addi	a4,a4,2
80004df6:	058a                	slli	a1,a1,0x2

80004df8 <.Ltmp48>:
80004df8:	0005c463          	bltz	a1,80004e00 <.Ltmp49>
80004dfc:	0705                	addi	a4,a4,1
80004dfe:	0586                	slli	a1,a1,0x1

80004e00 <.Ltmp49>:
80004e00:	fff74613          	not	a2,a4
80004e04:	00c556b3          	srl	a3,a0,a2
80004e08:	8285                	srli	a3,a3,0x1
80004e0a:	8dd5                	or	a1,a1,a3
80004e0c:	00e51533          	sll	a0,a0,a4
80004e10:	0be60613          	addi	a2,a2,190 # ff0000be <__AHB_SRAM_segment_end__+0xebf80be>
80004e14:	00a03533          	snez	a0,a0
80004e18:	8dc9                	or	a1,a1,a0

80004e1a <.L__floatundisf_round_and_pack>:
80004e1a:	065e                	slli	a2,a2,0x17
80004e1c:	0085d513          	srli	a0,a1,0x8
80004e20:	05de                	slli	a1,a1,0x17
80004e22:	0005a333          	sltz	t1,a1
80004e26:	95ae                	add	a1,a1,a1
80004e28:	959a                	add	a1,a1,t1
80004e2a:	0005d663          	bgez	a1,80004e36 <.L__floatundisf_round_down>
80004e2e:	95ae                	add	a1,a1,a1
80004e30:	00b035b3          	snez	a1,a1
80004e34:	952e                	add	a0,a0,a1

80004e36 <.L__floatundisf_round_down>:
80004e36:	9532                	add	a0,a0,a2

80004e38 <.L__floatundisf_done>:
80004e38:	8082                	ret

80004e3a <.L__floatundisf_high_word_zero>:
80004e3a:	dd7d                	beqz	a0,80004e38 <.L__floatundisf_done>
80004e3c:	09d00613          	li	a2,157
80004e40:	01055693          	srli	a3,a0,0x10
80004e44:	e299                	bnez	a3,80004e4a <.Ltmp50>
80004e46:	0542                	slli	a0,a0,0x10
80004e48:	1641                	addi	a2,a2,-16

80004e4a <.Ltmp50>:
80004e4a:	01855693          	srli	a3,a0,0x18
80004e4e:	e299                	bnez	a3,80004e54 <.Ltmp51>
80004e50:	0522                	slli	a0,a0,0x8
80004e52:	1661                	addi	a2,a2,-8

80004e54 <.Ltmp51>:
80004e54:	01c55693          	srli	a3,a0,0x1c
80004e58:	e299                	bnez	a3,80004e5e <.Ltmp52>
80004e5a:	0512                	slli	a0,a0,0x4
80004e5c:	1671                	addi	a2,a2,-4

80004e5e <.Ltmp52>:
80004e5e:	01e55693          	srli	a3,a0,0x1e
80004e62:	e299                	bnez	a3,80004e68 <.Ltmp53>
80004e64:	050a                	slli	a0,a0,0x2
80004e66:	1679                	addi	a2,a2,-2

80004e68 <.Ltmp53>:
80004e68:	00054463          	bltz	a0,80004e70 <.Ltmp54>
80004e6c:	0506                	slli	a0,a0,0x1
80004e6e:	167d                	addi	a2,a2,-1

80004e70 <.Ltmp54>:
80004e70:	85aa                	mv	a1,a0
80004e72:	4501                	li	a0,0
80004e74:	b75d                	j	80004e1a <.L__floatundisf_round_and_pack>

Disassembly of section .text.libc.__truncdfsf2:

80004e76 <__truncdfsf2>:
80004e76:	00159693          	slli	a3,a1,0x1
80004e7a:	82d5                	srli	a3,a3,0x15
80004e7c:	7ff00613          	li	a2,2047
80004e80:	04c68663          	beq	a3,a2,80004ecc <.L__truncdfsf2_inf_nan>
80004e84:	c8068693          	addi	a3,a3,-896
80004e88:	02d05e63          	blez	a3,80004ec4 <.L__truncdfsf2_underflow>
80004e8c:	0ff00613          	li	a2,255
80004e90:	04c6f263          	bgeu	a3,a2,80004ed4 <.L__truncdfsf2_inf>
80004e94:	06de                	slli	a3,a3,0x17
80004e96:	01f5d613          	srli	a2,a1,0x1f
80004e9a:	067e                	slli	a2,a2,0x1f
80004e9c:	8ed1                	or	a3,a3,a2
80004e9e:	05b2                	slli	a1,a1,0xc
80004ea0:	01455613          	srli	a2,a0,0x14
80004ea4:	8dd1                	or	a1,a1,a2
80004ea6:	81a5                	srli	a1,a1,0x9
80004ea8:	00251613          	slli	a2,a0,0x2
80004eac:	00062733          	sltz	a4,a2
80004eb0:	9632                	add	a2,a2,a2
80004eb2:	000627b3          	sltz	a5,a2
80004eb6:	9632                	add	a2,a2,a2
80004eb8:	963a                	add	a2,a2,a4
80004eba:	c211                	beqz	a2,80004ebe <.L__truncdfsf2_no_round_tie>
80004ebc:	95be                	add	a1,a1,a5

80004ebe <.L__truncdfsf2_no_round_tie>:
80004ebe:	00d58533          	add	a0,a1,a3
80004ec2:	8082                	ret

80004ec4 <.L__truncdfsf2_underflow>:
80004ec4:	01f5d513          	srli	a0,a1,0x1f
80004ec8:	057e                	slli	a0,a0,0x1f
80004eca:	8082                	ret

80004ecc <.L__truncdfsf2_inf_nan>:
80004ecc:	00c59693          	slli	a3,a1,0xc
80004ed0:	8ec9                	or	a3,a3,a0
80004ed2:	ea81                	bnez	a3,80004ee2 <.L__truncdfsf2_nan>

80004ed4 <.L__truncdfsf2_inf>:
80004ed4:	81fd                	srli	a1,a1,0x1f
80004ed6:	05fe                	slli	a1,a1,0x1f
80004ed8:	7f800537          	lui	a0,0x7f800
80004edc:	8d4d                	or	a0,a0,a1
80004ede:	4581                	li	a1,0
80004ee0:	8082                	ret

80004ee2 <.L__truncdfsf2_nan>:
80004ee2:	800006b7          	lui	a3,0x80000
80004ee6:	00d5f633          	and	a2,a1,a3
80004eea:	058e                	slli	a1,a1,0x3
80004eec:	8175                	srli	a0,a0,0x1d
80004eee:	8d4d                	or	a0,a0,a1
80004ef0:	0506                	slli	a0,a0,0x1
80004ef2:	8105                	srli	a0,a0,0x1
80004ef4:	8d51                	or	a0,a0,a2
80004ef6:	82a5                	srli	a3,a3,0x9
80004ef8:	8d55                	or	a0,a0,a3
80004efa:	8082                	ret

Disassembly of section .text.libc.frexpf:

80004efc <frexpf>:
80004efc:	01755613          	srli	a2,a0,0x17
80004f00:	0ff67613          	zext.b	a2,a2
80004f04:	0ff00693          	li	a3,255
80004f08:	00d60363          	beq	a2,a3,80004f0e <frexpf+0x12>
80004f0c:	e601                	bnez	a2,80004f14 <frexpf+0x18>
80004f0e:	0005a023          	sw	zero,0(a1)
80004f12:	8082                	ret
80004f14:	f8260613          	addi	a2,a2,-126
80004f18:	c190                	sw	a2,0(a1)
80004f1a:	808005b7          	lui	a1,0x80800
80004f1e:	15fd                	addi	a1,a1,-1 # 807fffff <__FLASH_segment_end__+0x6fffff>
80004f20:	8d6d                	and	a0,a0,a1
80004f22:	3f0005b7          	lui	a1,0x3f000
80004f26:	8d4d                	or	a0,a0,a1
80004f28:	8082                	ret

Disassembly of section .text.libc.abs:

80004f2a <abs>:
80004f2a:	41f55593          	srai	a1,a0,0x1f
80004f2e:	8d2d                	xor	a0,a0,a1
80004f30:	8d0d                	sub	a0,a0,a1
80004f32:	8082                	ret

Disassembly of section .text.libc.memcpy:

80004f34 <memcpy>:
80004f34:	c251                	beqz	a2,80004fb8 <.Lmemcpy_done>
80004f36:	87aa                	mv	a5,a0
80004f38:	00b546b3          	xor	a3,a0,a1
80004f3c:	06fa                	slli	a3,a3,0x1e
80004f3e:	e2bd                	bnez	a3,80004fa4 <.Lmemcpy_byte_copy>
80004f40:	01e51693          	slli	a3,a0,0x1e
80004f44:	ce81                	beqz	a3,80004f5c <.Lmemcpy_aligned>

80004f46 <.Lmemcpy_word_align>:
80004f46:	00058683          	lb	a3,0(a1) # 3f000000 <_flash_size+0x3ef00000>
80004f4a:	00d50023          	sb	a3,0(a0) # 7f800000 <_flash_size+0x7f700000>
80004f4e:	0585                	addi	a1,a1,1
80004f50:	0505                	addi	a0,a0,1
80004f52:	167d                	addi	a2,a2,-1
80004f54:	c22d                	beqz	a2,80004fb6 <.Lmemcpy_memcpy_end>
80004f56:	01e51693          	slli	a3,a0,0x1e
80004f5a:	f6f5                	bnez	a3,80004f46 <.Lmemcpy_word_align>

80004f5c <.Lmemcpy_aligned>:
80004f5c:	02000693          	li	a3,32
80004f60:	02d66763          	bltu	a2,a3,80004f8e <.Lmemcpy_word_copy>

80004f64 <.Lmemcpy_aligned_block_copy_loop>:
80004f64:	4198                	lw	a4,0(a1)
80004f66:	c118                	sw	a4,0(a0)
80004f68:	41d8                	lw	a4,4(a1)
80004f6a:	c158                	sw	a4,4(a0)
80004f6c:	4598                	lw	a4,8(a1)
80004f6e:	c518                	sw	a4,8(a0)
80004f70:	45d8                	lw	a4,12(a1)
80004f72:	c558                	sw	a4,12(a0)
80004f74:	4998                	lw	a4,16(a1)
80004f76:	c918                	sw	a4,16(a0)
80004f78:	49d8                	lw	a4,20(a1)
80004f7a:	c958                	sw	a4,20(a0)
80004f7c:	4d98                	lw	a4,24(a1)
80004f7e:	cd18                	sw	a4,24(a0)
80004f80:	4dd8                	lw	a4,28(a1)
80004f82:	cd58                	sw	a4,28(a0)
80004f84:	9536                	add	a0,a0,a3
80004f86:	95b6                	add	a1,a1,a3
80004f88:	8e15                	sub	a2,a2,a3
80004f8a:	fcd67de3          	bgeu	a2,a3,80004f64 <.Lmemcpy_aligned_block_copy_loop>

80004f8e <.Lmemcpy_word_copy>:
80004f8e:	c605                	beqz	a2,80004fb6 <.Lmemcpy_memcpy_end>
80004f90:	4691                	li	a3,4
80004f92:	00d66963          	bltu	a2,a3,80004fa4 <.Lmemcpy_byte_copy>

80004f96 <.Lmemcpy_word_copy_loop>:
80004f96:	4198                	lw	a4,0(a1)
80004f98:	c118                	sw	a4,0(a0)
80004f9a:	9536                	add	a0,a0,a3
80004f9c:	95b6                	add	a1,a1,a3
80004f9e:	8e15                	sub	a2,a2,a3
80004fa0:	fed67be3          	bgeu	a2,a3,80004f96 <.Lmemcpy_word_copy_loop>

80004fa4 <.Lmemcpy_byte_copy>:
80004fa4:	ca09                	beqz	a2,80004fb6 <.Lmemcpy_memcpy_end>

80004fa6 <.Lmemcpy_byte_copy_loop>:
80004fa6:	00058703          	lb	a4,0(a1)
80004faa:	00e50023          	sb	a4,0(a0)
80004fae:	0585                	addi	a1,a1,1
80004fb0:	0505                	addi	a0,a0,1
80004fb2:	167d                	addi	a2,a2,-1
80004fb4:	fa6d                	bnez	a2,80004fa6 <.Lmemcpy_byte_copy_loop>

80004fb6 <.Lmemcpy_memcpy_end>:
80004fb6:	853e                	mv	a0,a5

80004fb8 <.Lmemcpy_done>:
80004fb8:	8082                	ret

Disassembly of section .text.libc.strnlen:

80004fba <strnlen>:
80004fba:	cda9                	beqz	a1,80005014 <strnlen+0x5a>
80004fbc:	00054603          	lbu	a2,0(a0)
80004fc0:	ca31                	beqz	a2,80005014 <strnlen+0x5a>
80004fc2:	ffc57713          	andi	a4,a0,-4
80004fc6:	00357613          	andi	a2,a0,3
80004fca:	00351693          	slli	a3,a0,0x3
80004fce:	95b2                	add	a1,a1,a2
80004fd0:	4310                	lw	a2,0(a4)
80004fd2:	57fd                	li	a5,-1
80004fd4:	00d796b3          	sll	a3,a5,a3
80004fd8:	fff6c693          	not	a3,a3
80004fdc:	4791                	li	a5,4
80004fde:	8ed1                	or	a3,a3,a2
80004fe0:	02f5ed63          	bltu	a1,a5,8000501a <strnlen+0x60>
80004fe4:	01010637          	lui	a2,0x1010
80004fe8:	808087b7          	lui	a5,0x80808
80004fec:	10060893          	addi	a7,a2,256 # 1010100 <_flash_size+0xf10100>
80004ff0:	08078793          	addi	a5,a5,128 # 80808080 <__FLASH_segment_end__+0x708080>
80004ff4:	480d                	li	a6,3
80004ff6:	863a                	mv	a2,a4
80004ff8:	40d88733          	sub	a4,a7,a3
80004ffc:	8f55                	or	a4,a4,a3
80004ffe:	8f7d                	and	a4,a4,a5
80005000:	00f71c63          	bne	a4,a5,80005018 <strnlen+0x5e>
80005004:	4254                	lw	a3,4(a2)
80005006:	00460713          	addi	a4,a2,4
8000500a:	15f1                	addi	a1,a1,-4
8000500c:	863a                	mv	a2,a4
8000500e:	feb865e3          	bltu	a6,a1,80004ff8 <strnlen+0x3e>
80005012:	a021                	j	8000501a <strnlen+0x60>
80005014:	4501                	li	a0,0
80005016:	8082                	ret
80005018:	8732                	mv	a4,a2
8000501a:	0ff6f613          	zext.b	a2,a3
8000501e:	c215                	beqz	a2,80005042 <strnlen+0x88>
80005020:	6641                	lui	a2,0x10
80005022:	f0060613          	addi	a2,a2,-256 # ff00 <__AHB_SRAM_segment_size__+0x7f00>
80005026:	8e75                	and	a2,a2,a3
80005028:	ce01                	beqz	a2,80005040 <strnlen+0x86>
8000502a:	00ff0637          	lui	a2,0xff0
8000502e:	8e75                	and	a2,a2,a3
80005030:	c205                	beqz	a2,80005050 <strnlen+0x96>
80005032:	82e1                	srli	a3,a3,0x18
80005034:	00d03633          	snez	a2,a3
80005038:	060d                	addi	a2,a2,3 # ff0003 <_flash_size+0xef0003>
8000503a:	00b67663          	bgeu	a2,a1,80005046 <strnlen+0x8c>
8000503e:	a029                	j	80005048 <strnlen+0x8e>
80005040:	4605                	li	a2,1
80005042:	00b66363          	bltu	a2,a1,80005048 <strnlen+0x8e>
80005046:	862e                	mv	a2,a1
80005048:	40a70533          	sub	a0,a4,a0
8000504c:	9532                	add	a0,a0,a2
8000504e:	8082                	ret
80005050:	4609                	li	a2,2
80005052:	feb67ae3          	bgeu	a2,a1,80005046 <strnlen+0x8c>
80005056:	bfcd                	j	80005048 <strnlen+0x8e>

Disassembly of section .text.libc.__SEGGER_RTL_putc:

80005058 <__SEGGER_RTL_putc>:
80005058:	1141                	addi	sp,sp,-16
8000505a:	c606                	sw	ra,12(sp)
8000505c:	c422                	sw	s0,8(sp)
8000505e:	842a                	mv	s0,a0
80005060:	4908                	lw	a0,16(a0)
80005062:	00b103a3          	sb	a1,7(sp)
80005066:	c11d                	beqz	a0,8000508c <__SEGGER_RTL_putc+0x34>
80005068:	4010                	lw	a2,0(s0)
8000506a:	4054                	lw	a3,4(s0)
8000506c:	06d67f63          	bgeu	a2,a3,800050ea <__SEGGER_RTL_putc+0x92>
80005070:	4850                	lw	a2,20(s0)
80005072:	00160693          	addi	a3,a2,1
80005076:	9532                	add	a0,a0,a2
80005078:	c854                	sw	a3,20(s0)
8000507a:	00b50023          	sb	a1,0(a0)
8000507e:	4848                	lw	a0,20(s0)
80005080:	4c0c                	lw	a1,24(s0)
80005082:	06b51463          	bne	a0,a1,800050ea <__SEGGER_RTL_putc+0x92>
80005086:	8522                	mv	a0,s0
80005088:	2885                	jal	800050f8 <__SEGGER_RTL_prin_flush>
8000508a:	a085                	j	800050ea <__SEGGER_RTL_putc+0x92>
8000508c:	4448                	lw	a0,12(s0)
8000508e:	c105                	beqz	a0,800050ae <__SEGGER_RTL_putc+0x56>
80005090:	4010                	lw	a2,0(s0)
80005092:	4054                	lw	a3,4(s0)
80005094:	04d67b63          	bgeu	a2,a3,800050ea <__SEGGER_RTL_putc+0x92>
80005098:	00160713          	addi	a4,a2,1
8000509c:	8eb9                	xor	a3,a3,a4
8000509e:	0016b693          	seqz	a3,a3
800050a2:	16fd                	addi	a3,a3,-1 # 7fffffff <_flash_size+0x7fefffff>
800050a4:	8df5                	and	a1,a1,a3
800050a6:	9532                	add	a0,a0,a2
800050a8:	00b50023          	sb	a1,0(a0)
800050ac:	a83d                	j	800050ea <__SEGGER_RTL_putc+0x92>
800050ae:	4408                	lw	a0,8(s0)
800050b0:	c115                	beqz	a0,800050d4 <__SEGGER_RTL_putc+0x7c>
800050b2:	4010                	lw	a2,0(s0)
800050b4:	4054                	lw	a3,4(s0)
800050b6:	02d67a63          	bgeu	a2,a3,800050ea <__SEGGER_RTL_putc+0x92>
800050ba:	00160713          	addi	a4,a2,1
800050be:	060a                	slli	a2,a2,0x2
800050c0:	8eb9                	xor	a3,a3,a4
800050c2:	0016b693          	seqz	a3,a3
800050c6:	16fd                	addi	a3,a3,-1
800050c8:	8df5                	and	a1,a1,a3
800050ca:	0ff5f593          	zext.b	a1,a1
800050ce:	9532                	add	a0,a0,a2
800050d0:	c10c                	sw	a1,0(a0)
800050d2:	a821                	j	800050ea <__SEGGER_RTL_putc+0x92>
800050d4:	5014                	lw	a3,32(s0)
800050d6:	ca91                	beqz	a3,800050ea <__SEGGER_RTL_putc+0x92>
800050d8:	4008                	lw	a0,0(s0)
800050da:	404c                	lw	a1,4(s0)
800050dc:	00b57763          	bgeu	a0,a1,800050ea <__SEGGER_RTL_putc+0x92>
800050e0:	00710593          	addi	a1,sp,7
800050e4:	4605                	li	a2,1
800050e6:	8522                	mv	a0,s0
800050e8:	9682                	jalr	a3
800050ea:	4008                	lw	a0,0(s0)
800050ec:	0505                	addi	a0,a0,1
800050ee:	c008                	sw	a0,0(s0)
800050f0:	40b2                	lw	ra,12(sp)
800050f2:	4422                	lw	s0,8(sp)
800050f4:	0141                	addi	sp,sp,16
800050f6:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_prin_flush:

800050f8 <__SEGGER_RTL_prin_flush>:
800050f8:	4950                	lw	a2,20(a0)
800050fa:	ce19                	beqz	a2,80005118 <__SEGGER_RTL_prin_flush+0x20>
800050fc:	1141                	addi	sp,sp,-16
800050fe:	c606                	sw	ra,12(sp)
80005100:	c422                	sw	s0,8(sp)
80005102:	842a                	mv	s0,a0
80005104:	5114                	lw	a3,32(a0)
80005106:	c681                	beqz	a3,8000510e <__SEGGER_RTL_prin_flush+0x16>
80005108:	480c                	lw	a1,16(s0)
8000510a:	8522                	mv	a0,s0
8000510c:	9682                	jalr	a3
8000510e:	00042a23          	sw	zero,20(s0)
80005112:	40b2                	lw	ra,12(sp)
80005114:	4422                	lw	s0,8(sp)
80005116:	0141                	addi	sp,sp,16
80005118:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_print_padding:

8000511a <__SEGGER_RTL_print_padding>:
8000511a:	02c05963          	blez	a2,8000514c <__SEGGER_RTL_print_padding+0x32>
8000511e:	1101                	addi	sp,sp,-32
80005120:	ce06                	sw	ra,28(sp)
80005122:	cc22                	sw	s0,24(sp)
80005124:	ca26                	sw	s1,20(sp)
80005126:	c84a                	sw	s2,16(sp)
80005128:	c64e                	sw	s3,12(sp)
8000512a:	892e                	mv	s2,a1
8000512c:	84aa                	mv	s1,a0
8000512e:	00160413          	addi	s0,a2,1
80005132:	4985                	li	s3,1
80005134:	8526                	mv	a0,s1
80005136:	85ca                	mv	a1,s2
80005138:	3705                	jal	80005058 <__SEGGER_RTL_putc>
8000513a:	147d                	addi	s0,s0,-1
8000513c:	fe89ece3          	bltu	s3,s0,80005134 <__SEGGER_RTL_print_padding+0x1a>
80005140:	40f2                	lw	ra,28(sp)
80005142:	4462                	lw	s0,24(sp)
80005144:	44d2                	lw	s1,20(sp)
80005146:	4942                	lw	s2,16(sp)
80005148:	49b2                	lw	s3,12(sp)
8000514a:	6105                	addi	sp,sp,32
8000514c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pre_padding:

8000514e <__SEGGER_RTL_pre_padding>:
8000514e:	0105f693          	andi	a3,a1,16
80005152:	e699                	bnez	a3,80005160 <__SEGGER_RTL_pre_padding+0x12>
80005154:	2005f593          	andi	a1,a1,512
80005158:	c589                	beqz	a1,80005162 <__SEGGER_RTL_pre_padding+0x14>
8000515a:	03000593          	li	a1,48
8000515e:	bf75                	j	8000511a <__SEGGER_RTL_print_padding>
80005160:	8082                	ret
80005162:	02000593          	li	a1,32
80005166:	bf55                	j	8000511a <__SEGGER_RTL_print_padding>

Disassembly of section .text.libc.vfprintf:

80005168 <vfprintf>:
80005168:	1141                	addi	sp,sp,-16
8000516a:	c606                	sw	ra,12(sp)
8000516c:	c422                	sw	s0,8(sp)
8000516e:	c226                	sw	s1,4(sp)
80005170:	c04a                	sw	s2,0(sp)
80005172:	8932                	mv	s2,a2
80005174:	84ae                	mv	s1,a1
80005176:	842a                	mv	s0,a0
80005178:	797020ef          	jal	8000810e <__SEGGER_RTL_current_locale>
8000517c:	85aa                	mv	a1,a0
8000517e:	8522                	mv	a0,s0
80005180:	8626                	mv	a2,s1
80005182:	86ca                	mv	a3,s2
80005184:	40b2                	lw	ra,12(sp)
80005186:	4422                	lw	s0,8(sp)
80005188:	4492                	lw	s1,4(sp)
8000518a:	4902                	lw	s2,0(sp)
8000518c:	0141                	addi	sp,sp,16
8000518e:	a009                	j	80005190 <vfprintf_l>

Disassembly of section .text.libc.vfprintf_l:

80005190 <vfprintf_l>:
80005190:	739012ef          	jal	t0,800070c8 <__riscv_save_10>
80005194:	7179                	addi	sp,sp,-48
80005196:	1080                	addi	s0,sp,96
80005198:	8936                	mv	s2,a3
8000519a:	89b2                	mv	s3,a2
8000519c:	8a2e                	mv	s4,a1
8000519e:	8aaa                	mv	s5,a0
800051a0:	715010ef          	jal	800070b4 <__SEGGER_RTL_X_file_bufsize>
800051a4:	8baa                	mv	s7,a0
800051a6:	8b0a                	mv	s6,sp
800051a8:	053d                	addi	a0,a0,15
800051aa:	9941                	andi	a0,a0,-16
800051ac:	40a104b3          	sub	s1,sp,a0
800051b0:	8126                	mv	sp,s1
800051b2:	fa840513          	addi	a0,s0,-88
800051b6:	02400613          	li	a2,36
800051ba:	4581                	li	a1,0
800051bc:	627020ef          	jal	80007fe2 <memset>
800051c0:	80000537          	lui	a0,0x80000
800051c4:	800055b7          	lui	a1,0x80005
800051c8:	1fc58593          	addi	a1,a1,508 # 800051fc <__SEGGER_RTL_stream_write>
800051cc:	157d                	addi	a0,a0,-1 # 7fffffff <_flash_size+0x7fefffff>
800051ce:	faa42623          	sw	a0,-84(s0)
800051d2:	fa942c23          	sw	s1,-72(s0)
800051d6:	fd742023          	sw	s7,-64(s0)
800051da:	fd442223          	sw	s4,-60(s0)
800051de:	fcb42423          	sw	a1,-56(s0)
800051e2:	fd542623          	sw	s5,-52(s0)
800051e6:	fa840513          	addi	a0,s0,-88
800051ea:	85ce                	mv	a1,s3
800051ec:	864a                	mv	a2,s2
800051ee:	2091                	jal	80005232 <__SEGGER_RTL_vfprintf>
800051f0:	815a                	mv	sp,s6
800051f2:	fa040113          	addi	sp,s0,-96
800051f6:	6145                	addi	sp,sp,48
800051f8:	7030106f          	j	800070fa <__riscv_restore_8>

Disassembly of section .text.libc.__SEGGER_RTL_stream_write:

800051fc <__SEGGER_RTL_stream_write>:
800051fc:	5154                	lw	a3,36(a0)
800051fe:	852e                	mv	a0,a1
80005200:	4585                	li	a1,1
80005202:	7c30106f          	j	800071c4 <fwrite>

Disassembly of section .text.libc.printf:

80005206 <printf>:
80005206:	7179                	addi	sp,sp,-48
80005208:	c606                	sw	ra,12(sp)
8000520a:	82aa                	mv	t0,a0
8000520c:	d23e                	sw	a5,36(sp)
8000520e:	d442                	sw	a6,40(sp)
80005210:	d646                	sw	a7,44(sp)
80005212:	00080537          	lui	a0,0x80
80005216:	34c52503          	lw	a0,844(a0) # 8034c <stdout>
8000521a:	ca2e                	sw	a1,20(sp)
8000521c:	cc32                	sw	a2,24(sp)
8000521e:	ce36                	sw	a3,28(sp)
80005220:	d03a                	sw	a4,32(sp)
80005222:	084c                	addi	a1,sp,20
80005224:	c42e                	sw	a1,8(sp)
80005226:	0850                	addi	a2,sp,20
80005228:	8596                	mv	a1,t0
8000522a:	3f3d                	jal	80005168 <vfprintf>
8000522c:	40b2                	lw	ra,12(sp)
8000522e:	6145                	addi	sp,sp,48
80005230:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_vfprintf_short_float_long:

80005232 <__SEGGER_RTL_vfprintf>:
80005232:	68f012ef          	jal	t0,800070c0 <__riscv_save_12>
80005236:	711d                	addi	sp,sp,-96
80005238:	8d2e                	mv	s10,a1
8000523a:	8a2a                	mv	s4,a0
8000523c:	448d                	li	s1,3
8000523e:	00052023          	sw	zero,0(a0)
80005242:	02500c93          	li	s9,37
80005246:	4dc1                	li	s11,16
80005248:	49a9                	li	s3,10
8000524a:	66666537          	lui	a0,0x66666
8000524e:	7e9675b7          	lui	a1,0x7e967
80005252:	747d                	lui	s0,0xfffff
80005254:	555556b7          	lui	a3,0x55555
80005258:	51eb8737          	lui	a4,0x51eb8
8000525c:	000207b7          	lui	a5,0x20
80005260:	66750513          	addi	a0,a0,1639 # 66666667 <_flash_size+0x66566667>
80005264:	cc2a                	sw	a0,24(sp)
80005266:	69958513          	addi	a0,a1,1689 # 7e967699 <_flash_size+0x7e867699>
8000526a:	c62a                	sw	a0,12(sp)
8000526c:	7ff40513          	addi	a0,s0,2047 # fffff7ff <__AHB_SRAM_segment_end__+0xfbf77ff>
80005270:	c82a                	sw	a0,16(sp)
80005272:	55668513          	addi	a0,a3,1366 # 55555556 <_flash_size+0x55455556>
80005276:	c02a                	sw	a0,0(sp)
80005278:	51f70513          	addi	a0,a4,1311 # 51eb851f <_flash_size+0x51db851f>
8000527c:	c42a                	sw	a0,8(sp)
8000527e:	02178513          	addi	a0,a5,33 # 20021 <__ILM_segment_end__+0x21>
80005282:	ce2a                	sw	a0,28(sp)
80005284:	4505                	li	a0,1
80005286:	04aa                	slli	s1,s1,0xa
80005288:	d026                	sw	s1,32(sp)
8000528a:	84b2                	mv	s1,a2
8000528c:	052e                	slli	a0,a0,0xb
8000528e:	c22a                	sw	a0,4(sp)
80005290:	e1818913          	addi	s2,gp,-488 # 800036a8 <.LJTI0_0>
80005294:	000d4583          	lbu	a1,0(s10)
80005298:	01958863          	beq	a1,s9,800052a8 <__SEGGER_RTL_vfprintf+0x76>
8000529c:	56058de3          	beqz	a1,80006016 <__SEGGER_RTL_vfprintf+0xde4>
800052a0:	0d05                	addi	s10,s10,1
800052a2:	8552                	mv	a0,s4
800052a4:	3b55                	jal	80005058 <__SEGGER_RTL_putc>
800052a6:	b7fd                	j	80005294 <__SEGGER_RTL_vfprintf+0x62>
800052a8:	4b81                	li	s7,0
800052aa:	0d0d                	addi	s10,s10,3
800052ac:	05e00693          	li	a3,94
800052b0:	ffed4503          	lbu	a0,-2(s10)
800052b4:	fe050593          	addi	a1,a0,-32
800052b8:	00bdeb63          	bltu	s11,a1,800052ce <__SEGGER_RTL_vfprintf+0x9c>
800052bc:	058a                	slli	a1,a1,0x2
800052be:	95ca                	add	a1,a1,s2
800052c0:	4190                	lw	a2,0(a1)
800052c2:	08000593          	li	a1,128
800052c6:	8602                	jr	a2
800052c8:	04000593          	li	a1,64
800052cc:	a831                	j	800052e8 <__SEGGER_RTL_vfprintf+0xb6>
800052ce:	02d51163          	bne	a0,a3,800052f0 <__SEGGER_RTL_vfprintf+0xbe>
800052d2:	6585                	lui	a1,0x1
800052d4:	a811                	j	800052e8 <__SEGGER_RTL_vfprintf+0xb6>
800052d6:	45c1                	li	a1,16
800052d8:	a801                	j	800052e8 <__SEGGER_RTL_vfprintf+0xb6>
800052da:	20000593          	li	a1,512
800052de:	a029                	j	800052e8 <__SEGGER_RTL_vfprintf+0xb6>
800052e0:	65a1                	lui	a1,0x8
800052e2:	a019                	j	800052e8 <__SEGGER_RTL_vfprintf+0xb6>
800052e4:	02000593          	li	a1,32
800052e8:	00bbebb3          	or	s7,s7,a1
800052ec:	0d05                	addi	s10,s10,1
800052ee:	b7c9                	j	800052b0 <__SEGGER_RTL_vfprintf+0x7e>
800052f0:	fd050593          	addi	a1,a0,-48
800052f4:	0ff5f593          	zext.b	a1,a1
800052f8:	1d7d                	addi	s10,s10,-1
800052fa:	4625                	li	a2,9
800052fc:	04b66263          	bltu	a2,a1,80005340 <__SEGGER_RTL_vfprintf+0x10e>
80005300:	4581                	li	a1,0
80005302:	0ff57613          	zext.b	a2,a0
80005306:	000d4503          	lbu	a0,0(s10)
8000530a:	033585b3          	mul	a1,a1,s3
8000530e:	95b2                	add	a1,a1,a2
80005310:	fd058593          	addi	a1,a1,-48 # 7fd0 <__FLASH_segment_used_size__+0x274c>
80005314:	fd050613          	addi	a2,a0,-48
80005318:	0ff67613          	zext.b	a2,a2
8000531c:	0d05                	addi	s10,s10,1
8000531e:	ff3662e3          	bltu	a2,s3,80005302 <__SEGGER_RTL_vfprintf+0xd0>
80005322:	a005                	j	80005342 <__SEGGER_RTL_vfprintf+0x110>
80005324:	408c                	lw	a1,0(s1)
80005326:	0491                	addi	s1,s1,4
80005328:	fffd4503          	lbu	a0,-1(s10)
8000532c:	01b5d693          	srli	a3,a1,0x1b
80005330:	8ac1                	andi	a3,a3,16
80005332:	0176ebb3          	or	s7,a3,s7
80005336:	41f5d693          	srai	a3,a1,0x1f
8000533a:	8db5                	xor	a1,a1,a3
8000533c:	8d95                	sub	a1,a1,a3
8000533e:	a011                	j	80005342 <__SEGGER_RTL_vfprintf+0x110>
80005340:	4581                	li	a1,0
80005342:	02e00613          	li	a2,46
80005346:	00c51f63          	bne	a0,a2,80005364 <__SEGGER_RTL_vfprintf+0x132>
8000534a:	000d4503          	lbu	a0,0(s10)
8000534e:	02a00613          	li	a2,42
80005352:	00c51b63          	bne	a0,a2,80005368 <__SEGGER_RTL_vfprintf+0x136>
80005356:	0004ab03          	lw	s6,0(s1)
8000535a:	001d4503          	lbu	a0,1(s10)
8000535e:	0491                	addi	s1,s1,4
80005360:	0d09                	addi	s10,s10,2
80005362:	a825                	j	8000539a <__SEGGER_RTL_vfprintf+0x168>
80005364:	4b01                	li	s6,0
80005366:	a099                	j	800053ac <__SEGGER_RTL_vfprintf+0x17a>
80005368:	fd050613          	addi	a2,a0,-48
8000536c:	0ff67613          	zext.b	a2,a2
80005370:	0d05                	addi	s10,s10,1
80005372:	4b01                	li	s6,0
80005374:	46a5                	li	a3,9
80005376:	02c6e963          	bltu	a3,a2,800053a8 <__SEGGER_RTL_vfprintf+0x176>
8000537a:	0ff57613          	zext.b	a2,a0
8000537e:	000d4503          	lbu	a0,0(s10)
80005382:	033b06b3          	mul	a3,s6,s3
80005386:	9636                	add	a2,a2,a3
80005388:	fd060b13          	addi	s6,a2,-48
8000538c:	fd050613          	addi	a2,a0,-48
80005390:	0ff67613          	zext.b	a2,a2
80005394:	0d05                	addi	s10,s10,1
80005396:	ff3662e3          	bltu	a2,s3,8000537a <__SEGGER_RTL_vfprintf+0x148>
8000539a:	fffb4613          	not	a2,s6
8000539e:	827d                	srli	a2,a2,0x1f
800053a0:	0622                	slli	a2,a2,0x8
800053a2:	00cbebb3          	or	s7,s7,a2
800053a6:	a019                	j	800053ac <__SEGGER_RTL_vfprintf+0x17a>
800053a8:	100beb93          	ori	s7,s7,256
800053ac:	f9850613          	addi	a2,a0,-104
800053b0:	00761693          	slli	a3,a2,0x7
800053b4:	0662                	slli	a2,a2,0x18
800053b6:	8265                	srli	a2,a2,0x19
800053b8:	8e55                	or	a2,a2,a3
800053ba:	0ff67613          	zext.b	a2,a2
800053be:	46a5                	li	a3,9
800053c0:	04c6ef63          	bltu	a3,a2,8000541e <__SEGGER_RTL_vfprintf+0x1ec>
800053c4:	060a                	slli	a2,a2,0x2
800053c6:	e5c18693          	addi	a3,gp,-420 # 800036ec <.LJTI0_1>
800053ca:	9636                	add	a2,a2,a3
800053cc:	4210                	lw	a2,0(a2)
800053ce:	8602                	jr	a2
800053d0:	000d4503          	lbu	a0,0(s10)
800053d4:	0d05                	addi	s10,s10,1
800053d6:	a0a1                	j	8000541e <__SEGGER_RTL_vfprintf+0x1ec>
800053d8:	000d4503          	lbu	a0,0(s10)
800053dc:	06c00613          	li	a2,108
800053e0:	02c51863          	bne	a0,a2,80005410 <__SEGGER_RTL_vfprintf+0x1de>
800053e4:	001d4503          	lbu	a0,1(s10)
800053e8:	0d09                	addi	s10,s10,2
800053ea:	a005                	j	8000540a <__SEGGER_RTL_vfprintf+0x1d8>
800053ec:	000d4503          	lbu	a0,0(s10)
800053f0:	06800613          	li	a2,104
800053f4:	02c51263          	bne	a0,a2,80005418 <__SEGGER_RTL_vfprintf+0x1e6>
800053f8:	001d4503          	lbu	a0,1(s10)
800053fc:	0d09                	addi	s10,s10,2
800053fe:	008beb93          	ori	s7,s7,8
80005402:	a831                	j	8000541e <__SEGGER_RTL_vfprintf+0x1ec>
80005404:	000d4503          	lbu	a0,0(s10)
80005408:	0d05                	addi	s10,s10,1
8000540a:	002beb93          	ori	s7,s7,2
8000540e:	a801                	j	8000541e <__SEGGER_RTL_vfprintf+0x1ec>
80005410:	0d05                	addi	s10,s10,1
80005412:	001beb93          	ori	s7,s7,1
80005416:	a021                	j	8000541e <__SEGGER_RTL_vfprintf+0x1ec>
80005418:	0d05                	addi	s10,s10,1
8000541a:	004beb93          	ori	s7,s7,4
8000541e:	00b02633          	sgtz	a2,a1
80005422:	40c00633          	neg	a2,a2
80005426:	00b67ab3          	and	s5,a2,a1
8000542a:	04600593          	li	a1,70
8000542e:	02a5d363          	bge	a1,a0,80005454 <__SEGGER_RTL_vfprintf+0x222>
80005432:	f9d50593          	addi	a1,a0,-99
80005436:	4655                	li	a2,21
80005438:	04b66663          	bltu	a2,a1,80005484 <__SEGGER_RTL_vfprintf+0x252>
8000543c:	058a                	slli	a1,a1,0x2
8000543e:	e8418613          	addi	a2,gp,-380 # 80003714 <.LJTI0_2>
80005442:	95b2                	add	a1,a1,a2
80005444:	418c                	lw	a1,0(a1)
80005446:	8582                	jr	a1
80005448:	d456                	sw	s5,40(sp)
8000544a:	d202                	sw	zero,36(sp)
8000544c:	6591                	lui	a1,0x4
8000544e:	00bbeab3          	or	s5,s7,a1
80005452:	a219                	j	80005558 <__SEGGER_RTL_vfprintf+0x326>
80005454:	04400593          	li	a1,68
80005458:	02a5d163          	bge	a1,a0,8000547a <__SEGGER_RTL_vfprintf+0x248>
8000545c:	04500593          	li	a1,69
80005460:	04b50663          	beq	a0,a1,800054ac <__SEGGER_RTL_vfprintf+0x27a>
80005464:	04600593          	li	a1,70
80005468:	e2b516e3          	bne	a0,a1,80005294 <__SEGGER_RTL_vfprintf+0x62>
8000546c:	6509                	lui	a0,0x2
8000546e:	00abebb3          	or	s7,s7,a0
80005472:	5502                	lw	a0,32(sp)
80005474:	c0050513          	addi	a0,a0,-1024 # 1c00 <__NOR_CFG_OPTION_segment_size__+0x1000>
80005478:	a4fd                	j	80005766 <__SEGGER_RTL_vfprintf+0x534>
8000547a:	5b951f63          	bne	a0,s9,80005a38 <__SEGGER_RTL_vfprintf+0x806>
8000547e:	02500593          	li	a1,37
80005482:	b505                	j	800052a2 <__SEGGER_RTL_vfprintf+0x70>
80005484:	04700593          	li	a1,71
80005488:	2cb50b63          	beq	a0,a1,8000575e <__SEGGER_RTL_vfprintf+0x52c>
8000548c:	05800593          	li	a1,88
80005490:	e0b512e3          	bne	a0,a1,80005294 <__SEGGER_RTL_vfprintf+0x62>
80005494:	6589                	lui	a1,0x2
80005496:	00bbebb3          	or	s7,s7,a1
8000549a:	07800593          	li	a1,120
8000549e:	d456                	sw	s5,40(sp)
800054a0:	08b50e63          	beq	a0,a1,8000553c <__SEGGER_RTL_vfprintf+0x30a>
800054a4:	658d                	lui	a1,0x3
800054a6:	05858593          	addi	a1,a1,88 # 3058 <__BOOT_HEADER_segment_size__+0x1058>
800054aa:	a861                	j	80005542 <__SEGGER_RTL_vfprintf+0x310>
800054ac:	6509                	lui	a0,0x2
800054ae:	00abebb3          	or	s7,s7,a0
800054b2:	400bec93          	ori	s9,s7,1024
800054b6:	ac55                	j	8000576a <__SEGGER_RTL_vfprintf+0x538>
800054b8:	100bf593          	andi	a1,s7,256
800054bc:	d456                	sw	s5,40(sp)
800054be:	c199                	beqz	a1,800054c4 <__SEGGER_RTL_vfprintf+0x292>
800054c0:	dffbfb93          	andi	s7,s7,-513
800054c4:	d202                	sw	zero,36(sp)
800054c6:	8ade                	mv	s5,s7
800054c8:	a841                	j	80005558 <__SEGGER_RTL_vfprintf+0x326>
800054ca:	d456                	sw	s5,40(sp)
800054cc:	4c01                	li	s8,0
800054ce:	0004ac83          	lw	s9,0(s1)
800054d2:	0491                	addi	s1,s1,4
800054d4:	018b9593          	slli	a1,s7,0x18
800054d8:	85fd                	srai	a1,a1,0x1f
800054da:	0235f413          	andi	s0,a1,35
800054de:	100bea93          	ori	s5,s7,256
800054e2:	4b21                	li	s6,8
800054e4:	ac39                	j	80005702 <__SEGGER_RTL_vfprintf+0x4d0>
800054e6:	8b26                	mv	s6,s1
800054e8:	0004c483          	lbu	s1,0(s1)
800054ec:	0b11                	addi	s6,s6,4
800054ee:	1afd                	addi	s5,s5,-1
800054f0:	8552                	mv	a0,s4
800054f2:	85de                	mv	a1,s7
800054f4:	8656                	mv	a2,s5
800054f6:	39a1                	jal	8000514e <__SEGGER_RTL_pre_padding>
800054f8:	8552                	mv	a0,s4
800054fa:	85a6                	mv	a1,s1
800054fc:	3eb1                	jal	80005058 <__SEGGER_RTL_putc>
800054fe:	84da                	mv	s1,s6
80005500:	a641                	j	80005880 <__SEGGER_RTL_vfprintf+0x64e>
80005502:	4088                	lw	a0,0(s1)
80005504:	008bf593          	andi	a1,s7,8
80005508:	52059b63          	bnez	a1,80005a3e <__SEGGER_RTL_vfprintf+0x80c>
8000550c:	000a2583          	lw	a1,0(s4)
80005510:	002bf413          	andi	s0,s7,2
80005514:	58041263          	bnez	s0,80005a98 <__SEGGER_RTL_vfprintf+0x866>
80005518:	c10c                	sw	a1,0(a0)
8000551a:	a351                	j	80005a9e <__SEGGER_RTL_vfprintf+0x86c>
8000551c:	4088                	lw	a0,0(s1)
8000551e:	0491                	addi	s1,s1,4
80005520:	ae09                	j	80005832 <__SEGGER_RTL_vfprintf+0x600>
80005522:	d456                	sw	s5,40(sp)
80005524:	100bf593          	andi	a1,s7,256
80005528:	8ade                	mv	s5,s7
8000552a:	c199                	beqz	a1,80005530 <__SEGGER_RTL_vfprintf+0x2fe>
8000552c:	dffbfa93          	andi	s5,s7,-513
80005530:	0be2                	slli	s7,s7,0x18
80005532:	405bd593          	srai	a1,s7,0x5
80005536:	81f9                	srli	a1,a1,0x1e
80005538:	0592                	slli	a1,a1,0x4
8000553a:	a831                	j	80005556 <__SEGGER_RTL_vfprintf+0x324>
8000553c:	658d                	lui	a1,0x3
8000553e:	07858593          	addi	a1,a1,120 # 3078 <__BOOT_HEADER_segment_size__+0x1078>
80005542:	100bf613          	andi	a2,s7,256
80005546:	8ade                	mv	s5,s7
80005548:	c219                	beqz	a2,8000554e <__SEGGER_RTL_vfprintf+0x31c>
8000554a:	dffbfa93          	andi	s5,s7,-513
8000554e:	0be2                	slli	s7,s7,0x18
80005550:	41fbd613          	srai	a2,s7,0x1f
80005554:	8df1                	and	a1,a1,a2
80005556:	d22e                	sw	a1,36(sp)
80005558:	002af613          	andi	a2,s5,2
8000555c:	011a9693          	slli	a3,s5,0x11
80005560:	004af593          	andi	a1,s5,4
80005564:	0006c663          	bltz	a3,80005570 <__SEGGER_RTL_vfprintf+0x33e>
80005568:	e20d                	bnez	a2,8000558a <__SEGGER_RTL_vfprintf+0x358>
8000556a:	00448693          	addi	a3,s1,4
8000556e:	a02d                	j	80005598 <__SEGGER_RTL_vfprintf+0x366>
80005570:	e229                	bnez	a2,800055b2 <__SEGGER_RTL_vfprintf+0x380>
80005572:	0004ac83          	lw	s9,0(s1)
80005576:	00448693          	addi	a3,s1,4
8000557a:	41fcdc13          	srai	s8,s9,0x1f
8000557e:	c5a1                	beqz	a1,800055c6 <__SEGGER_RTL_vfprintf+0x394>
80005580:	010c9593          	slli	a1,s9,0x10
80005584:	4105dc93          	srai	s9,a1,0x10
80005588:	a0b1                	j	800055d4 <__SEGGER_RTL_vfprintf+0x3a2>
8000558a:	00748613          	addi	a2,s1,7
8000558e:	ff867493          	andi	s1,a2,-8
80005592:	40d0                	lw	a2,4(s1)
80005594:	00848693          	addi	a3,s1,8
80005598:	0004ac83          	lw	s9,0(s1)
8000559c:	e9a9                	bnez	a1,800055ee <__SEGGER_RTL_vfprintf+0x3bc>
8000559e:	008af593          	andi	a1,s5,8
800055a2:	c199                	beqz	a1,800055a8 <__SEGGER_RTL_vfprintf+0x376>
800055a4:	0ffcfc93          	zext.b	s9,s9
800055a8:	818d                	srli	a1,a1,0x3
800055aa:	15fd                	addi	a1,a1,-1
800055ac:	00c5fc33          	and	s8,a1,a2
800055b0:	a095                	j	80005614 <__SEGGER_RTL_vfprintf+0x3e2>
800055b2:	00748613          	addi	a2,s1,7
800055b6:	9a61                	andi	a2,a2,-8
800055b8:	00062c83          	lw	s9,0(a2)
800055bc:	00462c03          	lw	s8,4(a2)
800055c0:	00860693          	addi	a3,a2,8
800055c4:	fdd5                	bnez	a1,80005580 <__SEGGER_RTL_vfprintf+0x34e>
800055c6:	008af593          	andi	a1,s5,8
800055ca:	c599                	beqz	a1,800055d8 <__SEGGER_RTL_vfprintf+0x3a6>
800055cc:	018c9593          	slli	a1,s9,0x18
800055d0:	4185dc93          	srai	s9,a1,0x18
800055d4:	41f5dc13          	srai	s8,a1,0x1f
800055d8:	020c4063          	bltz	s8,800055f8 <__SEGGER_RTL_vfprintf+0x3c6>
800055dc:	020af593          	andi	a1,s5,32
800055e0:	e59d                	bnez	a1,8000560e <__SEGGER_RTL_vfprintf+0x3dc>
800055e2:	040af593          	andi	a1,s5,64
800055e6:	c59d                	beqz	a1,80005614 <__SEGGER_RTL_vfprintf+0x3e2>
800055e8:	02000593          	li	a1,32
800055ec:	a01d                	j	80005612 <__SEGGER_RTL_vfprintf+0x3e0>
800055ee:	4c01                	li	s8,0
800055f0:	0cc2                	slli	s9,s9,0x10
800055f2:	010cdc93          	srli	s9,s9,0x10
800055f6:	a839                	j	80005614 <__SEGGER_RTL_vfprintf+0x3e2>
800055f8:	019035b3          	snez	a1,s9
800055fc:	41900cb3          	neg	s9,s9
80005600:	41800633          	neg	a2,s8
80005604:	40b60c33          	sub	s8,a2,a1
80005608:	02d00593          	li	a1,45
8000560c:	a019                	j	80005612 <__SEGGER_RTL_vfprintf+0x3e0>
8000560e:	02b00593          	li	a1,43
80005612:	d22e                	sw	a1,36(sp)
80005614:	100af593          	andi	a1,s5,256
80005618:	c199                	beqz	a1,8000561e <__SEGGER_RTL_vfprintf+0x3ec>
8000561a:	dffafa93          	andi	s5,s5,-513
8000561e:	100af593          	andi	a1,s5,256
80005622:	e191                	bnez	a1,80005626 <__SEGGER_RTL_vfprintf+0x3f4>
80005624:	4b05                	li	s6,1
80005626:	f9c50593          	addi	a1,a0,-100 # 1f9c <__NOR_CFG_OPTION_segment_size__+0x139c>
8000562a:	4651                	li	a2,20
8000562c:	0cb66563          	bltu	a2,a1,800056f6 <__SEGGER_RTL_vfprintf+0x4c4>
80005630:	4672                	lw	a2,28(sp)
80005632:	00b65633          	srl	a2,a2,a1
80005636:	8a05                	andi	a2,a2,1
80005638:	ea31                	bnez	a2,8000568c <__SEGGER_RTL_vfprintf+0x45a>
8000563a:	00101637          	lui	a2,0x101
8000563e:	00b65633          	srl	a2,a2,a1
80005642:	8a05                	andi	a2,a2,1
80005644:	ee4d                	bnez	a2,800056fe <__SEGGER_RTL_vfprintf+0x4cc>
80005646:	462d                	li	a2,11
80005648:	0ac59763          	bne	a1,a2,800056f6 <__SEGGER_RTL_vfprintf+0x4c4>
8000564c:	8736                	mv	a4,a3
8000564e:	4b81                	li	s7,0
80005650:	018ce533          	or	a0,s9,s8
80005654:	c915                	beqz	a0,80005688 <__SEGGER_RTL_vfprintf+0x456>
80005656:	003cd513          	srli	a0,s9,0x3
8000565a:	01dc1593          	slli	a1,s8,0x1d
8000565e:	8dc9                	or	a1,a1,a0
80005660:	04610513          	addi	a0,sp,70
80005664:	007cf613          	andi	a2,s9,7
80005668:	8cae                	mv	s9,a1
8000566a:	0b85                	addi	s7,s7,1
8000566c:	003c5c13          	srli	s8,s8,0x3
80005670:	818d                	srli	a1,a1,0x3
80005672:	03060613          	addi	a2,a2,48 # 101030 <_flash_size+0x1030>
80005676:	018ce6b3          	or	a3,s9,s8
8000567a:	00c50023          	sb	a2,0(a0)
8000567e:	01dc1613          	slli	a2,s8,0x1d
80005682:	8dd1                	or	a1,a1,a2
80005684:	0505                	addi	a0,a0,1
80005686:	fef9                	bnez	a3,80005664 <__SEGGER_RTL_vfprintf+0x432>
80005688:	d63a                	sw	a4,44(sp)
8000568a:	acbd                	j	80005908 <__SEGGER_RTL_vfprintf+0x6d6>
8000568c:	d636                	sw	a3,44(sp)
8000568e:	4b81                	li	s7,0
80005690:	018ce533          	or	a0,s9,s8
80005694:	26050a63          	beqz	a0,80005908 <__SEGGER_RTL_vfprintf+0x6d6>
80005698:	6521                	lui	a0,0x8
8000569a:	00aaf4b3          	and	s1,s5,a0
8000569e:	c085                	beqz	s1,800056be <__SEGGER_RTL_vfprintf+0x48c>
800056a0:	003bf513          	andi	a0,s7,3
800056a4:	458d                	li	a1,3
800056a6:	00b51c63          	bne	a0,a1,800056be <__SEGGER_RTL_vfprintf+0x48c>
800056aa:	04610413          	addi	s0,sp,70
800056ae:	01740533          	add	a0,s0,s7
800056b2:	02c00593          	li	a1,44
800056b6:	00b50023          	sb	a1,0(a0) # 8000 <__AHB_SRAM_segment_size__>
800056ba:	0b85                	addi	s7,s7,1
800056bc:	a019                	j	800056c2 <__SEGGER_RTL_vfprintf+0x490>
800056be:	04610413          	addi	s0,sp,70
800056c2:	4629                	li	a2,10
800056c4:	8566                	mv	a0,s9
800056c6:	85e2                	mv	a1,s8
800056c8:	4681                	li	a3,0
800056ca:	02c020ef          	jal	800076f6 <__udivdi3>
800056ce:	001c3613          	seqz	a2,s8
800056d2:	033506b3          	mul	a3,a0,s3
800056d6:	01740733          	add	a4,s0,s7
800056da:	40dc86b3          	sub	a3,s9,a3
800056de:	00acb793          	sltiu	a5,s9,10
800056e2:	8e7d                	and	a2,a2,a5
800056e4:	0306e693          	ori	a3,a3,48
800056e8:	00d70023          	sb	a3,0(a4)
800056ec:	0b85                	addi	s7,s7,1
800056ee:	8caa                	mv	s9,a0
800056f0:	8c2e                	mv	s8,a1
800056f2:	d655                	beqz	a2,8000569e <__SEGGER_RTL_vfprintf+0x46c>
800056f4:	ac11                	j	80005908 <__SEGGER_RTL_vfprintf+0x6d6>
800056f6:	05800593          	li	a1,88
800056fa:	20b51563          	bne	a0,a1,80005904 <__SEGGER_RTL_vfprintf+0x6d2>
800056fe:	84b6                	mv	s1,a3
80005700:	5412                	lw	s0,36(sp)
80005702:	018ce533          	or	a0,s9,s8
80005706:	d626                	sw	s1,44(sp)
80005708:	c929                	beqz	a0,8000575a <__SEGGER_RTL_vfprintf+0x528>
8000570a:	012a9593          	slli	a1,s5,0x12
8000570e:	80008537          	lui	a0,0x80008
80005712:	31050513          	addi	a0,a0,784 # 80008310 <__SEGGER_RTL_hex_lc>
80005716:	0005d663          	bgez	a1,80005722 <__SEGGER_RTL_vfprintf+0x4f0>
8000571a:	80008537          	lui	a0,0x80008
8000571e:	30050513          	addi	a0,a0,768 # 80008300 <__SEGGER_RTL_hex_uc>
80005722:	4b81                	li	s7,0
80005724:	004cd593          	srli	a1,s9,0x4
80005728:	01cc1613          	slli	a2,s8,0x1c
8000572c:	8e4d                	or	a2,a2,a1
8000572e:	04610593          	addi	a1,sp,70
80005732:	00fcf693          	andi	a3,s9,15
80005736:	8cb2                	mv	s9,a2
80005738:	004c5c13          	srli	s8,s8,0x4
8000573c:	8211                	srli	a2,a2,0x4
8000573e:	96aa                	add	a3,a3,a0
80005740:	018ce733          	or	a4,s9,s8
80005744:	0006c683          	lbu	a3,0(a3)
80005748:	01cc1793          	slli	a5,s8,0x1c
8000574c:	8e5d                	or	a2,a2,a5
8000574e:	0b85                	addi	s7,s7,1
80005750:	00d58023          	sb	a3,0(a1)
80005754:	0585                	addi	a1,a1,1
80005756:	ff71                	bnez	a4,80005732 <__SEGGER_RTL_vfprintf+0x500>
80005758:	aa4d                	j	8000590a <__SEGGER_RTL_vfprintf+0x6d8>
8000575a:	4b81                	li	s7,0
8000575c:	a27d                	j	8000590a <__SEGGER_RTL_vfprintf+0x6d8>
8000575e:	6509                	lui	a0,0x2
80005760:	00abebb3          	or	s7,s7,a0
80005764:	5502                	lw	a0,32(sp)
80005766:	00abecb3          	or	s9,s7,a0
8000576a:	002cf513          	andi	a0,s9,2
8000576e:	ed01                	bnez	a0,80005786 <__SEGGER_RTL_vfprintf+0x554>
80005770:	00748513          	addi	a0,s1,7
80005774:	ff857613          	andi	a2,a0,-8
80005778:	4208                	lw	a0,0(a2)
8000577a:	424c                	lw	a1,4(a2)
8000577c:	00860493          	addi	s1,a2,8
80005780:	ef6ff0ef          	jal	80004e76 <__truncdfsf2>
80005784:	a831                	j	800057a0 <__SEGGER_RTL_vfprintf+0x56e>
80005786:	4088                	lw	a0,0(s1)
80005788:	410c                	lw	a1,0(a0)
8000578a:	4150                	lw	a2,4(a0)
8000578c:	4514                	lw	a3,8(a0)
8000578e:	4558                	lw	a4,12(a0)
80005790:	0491                	addi	s1,s1,4
80005792:	1808                	addi	a0,sp,48
80005794:	d82e                	sw	a1,48(sp)
80005796:	da32                	sw	a2,52(sp)
80005798:	dc36                	sw	a3,56(sp)
8000579a:	de3a                	sw	a4,60(sp)
8000579c:	511010ef          	jal	800074ac <__trunctfsf2>
800057a0:	842a                	mv	s0,a0
800057a2:	100cf513          	andi	a0,s9,256
800057a6:	e111                	bnez	a0,800057aa <__SEGGER_RTL_vfprintf+0x578>
800057a8:	4b19                	li	s6,6
800057aa:	000b1863          	bnez	s6,800057ba <__SEGGER_RTL_vfprintf+0x588>
800057ae:	5582                	lw	a1,32(sp)
800057b0:	00bcf533          	and	a0,s9,a1
800057b4:	8d2d                	xor	a0,a0,a1
800057b6:	00153b13          	seqz	s6,a0
800057ba:	8522                	mv	a0,s0
800057bc:	517010ef          	jal	800074d2 <__SEGGER_RTL_float32_isinf>
800057c0:	c505                	beqz	a0,800057e8 <__SEGGER_RTL_vfprintf+0x5b6>
800057c2:	8522                	mv	a0,s0
800057c4:	4581                	li	a1,0
800057c6:	d5cff0ef          	jal	80004d22 <__ltsf2>
800057ca:	6589                	lui	a1,0x2
800057cc:	00bcf5b3          	and	a1,s9,a1
800057d0:	02055d63          	bgez	a0,8000580a <__SEGGER_RTL_vfprintf+0x5d8>
800057d4:	80008537          	lui	a0,0x80008
800057d8:	28350513          	addi	a0,a0,643 # 80008283 <.L.str.2>
800057dc:	c5b9                	beqz	a1,8000582a <__SEGGER_RTL_vfprintf+0x5f8>
800057de:	80008537          	lui	a0,0x80008
800057e2:	27e50513          	addi	a0,a0,638 # 8000827e <.L.str.1>
800057e6:	a091                	j	8000582a <__SEGGER_RTL_vfprintf+0x5f8>
800057e8:	8522                	mv	a0,s0
800057ea:	4dd010ef          	jal	800074c6 <__SEGGER_RTL_float32_isnan>
800057ee:	c15d                	beqz	a0,80005894 <__SEGGER_RTL_vfprintf+0x662>
800057f0:	012c9593          	slli	a1,s9,0x12
800057f4:	80008537          	lui	a0,0x80008
800057f8:	32450513          	addi	a0,a0,804 # 80008324 <.L.str.6>
800057fc:	0205d763          	bgez	a1,8000582a <__SEGGER_RTL_vfprintf+0x5f8>
80005800:	80008537          	lui	a0,0x80008
80005804:	32050513          	addi	a0,a0,800 # 80008320 <.L.str.5>
80005808:	a00d                	j	8000582a <__SEGGER_RTL_vfprintf+0x5f8>
8000580a:	c591                	beqz	a1,80005816 <__SEGGER_RTL_vfprintf+0x5e4>
8000580c:	800085b7          	lui	a1,0x80008
80005810:	28858593          	addi	a1,a1,648 # 80008288 <.L.str.3>
80005814:	a029                	j	8000581e <__SEGGER_RTL_vfprintf+0x5ec>
80005816:	800085b7          	lui	a1,0x80008
8000581a:	28d58593          	addi	a1,a1,653 # 8000828d <.L.str.4>
8000581e:	00158513          	addi	a0,a1,1
80005822:	020cf613          	andi	a2,s9,32
80005826:	c211                	beqz	a2,8000582a <__SEGGER_RTL_vfprintf+0x5f8>
80005828:	852e                	mv	a0,a1
8000582a:	effcfb93          	andi	s7,s9,-257
8000582e:	02500c93          	li	s9,37
80005832:	1ad18413          	addi	s0,gp,429 # 80003a3d <.L.str>
80005836:	c111                	beqz	a0,8000583a <__SEGGER_RTL_vfprintf+0x608>
80005838:	842a                	mv	s0,a0
8000583a:	100bf513          	andi	a0,s7,256
8000583e:	e509                	bnez	a0,80005848 <__SEGGER_RTL_vfprintf+0x616>
80005840:	8522                	mv	a0,s0
80005842:	009020ef          	jal	8000804a <strlen>
80005846:	a029                	j	80005850 <__SEGGER_RTL_vfprintf+0x61e>
80005848:	8522                	mv	a0,s0
8000584a:	85da                	mv	a1,s6
8000584c:	f6eff0ef          	jal	80004fba <strnlen>
80005850:	8b2a                	mv	s6,a0
80005852:	dffbfb93          	andi	s7,s7,-513
80005856:	40aa8ab3          	sub	s5,s5,a0
8000585a:	8552                	mv	a0,s4
8000585c:	85de                	mv	a1,s7
8000585e:	8656                	mv	a2,s5
80005860:	30fd                	jal	8000514e <__SEGGER_RTL_pre_padding>
80005862:	000b0f63          	beqz	s6,80005880 <__SEGGER_RTL_vfprintf+0x64e>
80005866:	8c26                	mv	s8,s1
80005868:	9b22                	add	s6,s6,s0
8000586a:	00044583          	lbu	a1,0(s0)
8000586e:	00140493          	addi	s1,s0,1
80005872:	8552                	mv	a0,s4
80005874:	fe4ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005878:	8426                	mv	s0,s1
8000587a:	ff6498e3          	bne	s1,s6,8000586a <__SEGGER_RTL_vfprintf+0x638>
8000587e:	84e2                	mv	s1,s8
80005880:	010bf413          	andi	s0,s7,16
80005884:	a00408e3          	beqz	s0,80005294 <__SEGGER_RTL_vfprintf+0x62>
80005888:	02000593          	li	a1,32
8000588c:	8552                	mv	a0,s4
8000588e:	8656                	mv	a2,s5
80005890:	3069                	jal	8000511a <__SEGGER_RTL_print_padding>
80005892:	b409                	j	80005294 <__SEGGER_RTL_vfprintf+0x62>
80005894:	d456                	sw	s5,40(sp)
80005896:	8522                	mv	a0,s0
80005898:	44b010ef          	jal	800074e2 <__SEGGER_RTL_float32_isnormal>
8000589c:	00153513          	seqz	a0,a0
800058a0:	157d                	addi	a0,a0,-1
800058a2:	00857bb3          	and	s7,a0,s0
800058a6:	855e                	mv	a0,s7
800058a8:	453010ef          	jal	800074fa <__SEGGER_RTL_float32_signbit>
800058ac:	8aaa                	mv	s5,a0
800058ae:	00a03533          	snez	a0,a0
800058b2:	057e                	slli	a0,a0,0x1f
800058b4:	00abc433          	xor	s0,s7,a0
800058b8:	08ec                	addi	a1,sp,92
800058ba:	8522                	mv	a0,s0
800058bc:	e40ff0ef          	jal	80004efc <frexpf>
800058c0:	4576                	lw	a0,92(sp)
800058c2:	00151593          	slli	a1,a0,0x1
800058c6:	952e                	add	a0,a0,a1
800058c8:	45e2                	lw	a1,24(sp)
800058ca:	02b51533          	mulh	a0,a0,a1
800058ce:	01f55c13          	srli	s8,a0,0x1f
800058d2:	8509                	srai	a0,a0,0x2
800058d4:	9c2a                	add	s8,s8,a0
800058d6:	cee2                	sw	s8,92(sp)
800058d8:	855e                	mv	a0,s7
800058da:	4581                	li	a1,0
800058dc:	2dd010ef          	jal	800073b8 <__eqsf2>
800058e0:	0e050963          	beqz	a0,800059d2 <__SEGGER_RTL_vfprintf+0x7a0>
800058e4:	001c0513          	addi	a0,s8,1
800058e8:	7ca020ef          	jal	800080b2 <__SEGGER_RTL_pow10f>
800058ec:	85aa                	mv	a1,a0
800058ee:	8522                	mv	a0,s0
800058f0:	c6cff0ef          	jal	80004d5c <__gtsf2>
800058f4:	0ca05263          	blez	a0,800059b8 <__SEGGER_RTL_vfprintf+0x786>
800058f8:	4576                	lw	a0,92(sp)
800058fa:	00150593          	addi	a1,a0,1
800058fe:	ceae                	sw	a1,92(sp)
80005900:	0509                	addi	a0,a0,2
80005902:	b7dd                	j	800058e8 <__SEGGER_RTL_vfprintf+0x6b6>
80005904:	4b81                	li	s7,0
80005906:	d636                	sw	a3,44(sp)
80005908:	5412                	lw	s0,36(sp)
8000590a:	417b0533          	sub	a0,s6,s7
8000590e:	10043593          	sltiu	a1,s0,256
80005912:	8ca2                	mv	s9,s0
80005914:	00143613          	seqz	a2,s0
80005918:	15f9                	addi	a1,a1,-2
8000591a:	167d                	addi	a2,a2,-1
8000591c:	8df1                	and	a1,a1,a2
8000591e:	00a02633          	sgtz	a2,a0
80005922:	40c004b3          	neg	s1,a2
80005926:	8ce9                	and	s1,s1,a0
80005928:	009b8533          	add	a0,s7,s1
8000592c:	5422                	lw	s0,40(sp)
8000592e:	8c09                	sub	s0,s0,a0
80005930:	200af513          	andi	a0,s5,512
80005934:	00b40b33          	add	s6,s0,a1
80005938:	4c05                	li	s8,1
8000593a:	e511                	bnez	a0,80005946 <__SEGGER_RTL_vfprintf+0x714>
8000593c:	8552                	mv	a0,s4
8000593e:	85d6                	mv	a1,s5
80005940:	865a                	mv	a2,s6
80005942:	3031                	jal	8000514e <__SEGGER_RTL_pre_padding>
80005944:	4b01                	li	s6,0
80005946:	04510413          	addi	s0,sp,69
8000594a:	10000513          	li	a0,256
8000594e:	00ace963          	bltu	s9,a0,80005960 <__SEGGER_RTL_vfprintf+0x72e>
80005952:	008cd593          	srli	a1,s9,0x8
80005956:	8552                	mv	a0,s4
80005958:	f00ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
8000595c:	85e6                	mv	a1,s9
8000595e:	a021                	j	80005966 <__SEGGER_RTL_vfprintf+0x734>
80005960:	85e6                	mv	a1,s9
80005962:	000c8563          	beqz	s9,8000596c <__SEGGER_RTL_vfprintf+0x73a>
80005966:	8552                	mv	a0,s4
80005968:	ef0ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
8000596c:	8552                	mv	a0,s4
8000596e:	85d6                	mv	a1,s5
80005970:	865a                	mv	a2,s6
80005972:	fdcff0ef          	jal	8000514e <__SEGGER_RTL_pre_padding>
80005976:	03000593          	li	a1,48
8000597a:	8552                	mv	a0,s4
8000597c:	8626                	mv	a2,s1
8000597e:	f9cff0ef          	jal	8000511a <__SEGGER_RTL_print_padding>
80005982:	01705d63          	blez	s7,8000599c <__SEGGER_RTL_vfprintf+0x76a>
80005986:	84de                	mv	s1,s7
80005988:	01740533          	add	a0,s0,s7
8000598c:	00054583          	lbu	a1,0(a0)
80005990:	1bfd                	addi	s7,s7,-1
80005992:	8552                	mv	a0,s4
80005994:	ec4ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005998:	fe9c67e3          	bltu	s8,s1,80005986 <__SEGGER_RTL_vfprintf+0x754>
8000599c:	010af513          	andi	a0,s5,16
800059a0:	54b2                	lw	s1,44(sp)
800059a2:	02500c93          	li	s9,37
800059a6:	8e0507e3          	beqz	a0,80005294 <__SEGGER_RTL_vfprintf+0x62>
800059aa:	02000593          	li	a1,32
800059ae:	8552                	mv	a0,s4
800059b0:	865a                	mv	a2,s6
800059b2:	f68ff0ef          	jal	8000511a <__SEGGER_RTL_print_padding>
800059b6:	b8f9                	j	80005294 <__SEGGER_RTL_vfprintf+0x62>
800059b8:	4576                	lw	a0,92(sp)
800059ba:	6f8020ef          	jal	800080b2 <__SEGGER_RTL_pow10f>
800059be:	85aa                	mv	a1,a0
800059c0:	8522                	mv	a0,s0
800059c2:	b60ff0ef          	jal	80004d22 <__ltsf2>
800059c6:	00055663          	bgez	a0,800059d2 <__SEGGER_RTL_vfprintf+0x7a0>
800059ca:	4576                	lw	a0,92(sp)
800059cc:	157d                	addi	a0,a0,-1
800059ce:	ceaa                	sw	a0,92(sp)
800059d0:	b7ed                	j	800059ba <__SEGGER_RTL_vfprintf+0x788>
800059d2:	001ab513          	seqz	a0,s5
800059d6:	157d                	addi	a0,a0,-1
800059d8:	06057593          	andi	a1,a0,96
800059dc:	4576                	lw	a0,92(sp)
800059de:	00bcec33          	or	s8,s9,a1
800059e2:	5582                	lw	a1,32(sp)
800059e4:	00bc7ab3          	and	s5,s8,a1
800059e8:	40000593          	li	a1,1024
800059ec:	d626                	sw	s1,44(sp)
800059ee:	02ba8a63          	beq	s5,a1,80005a22 <__SEGGER_RTL_vfprintf+0x7f0>
800059f2:	5582                	lw	a1,32(sp)
800059f4:	00ba9763          	bne	s5,a1,80005a02 <__SEGGER_RTL_vfprintf+0x7d0>
800059f8:	03655563          	bge	a0,s6,80005a22 <__SEGGER_RTL_vfprintf+0x7f0>
800059fc:	55ed                	li	a1,-5
800059fe:	02a5d263          	bge	a1,a0,80005a22 <__SEGGER_RTL_vfprintf+0x7f0>
80005a02:	400c7593          	andi	a1,s8,1024
80005a06:	080c7693          	andi	a3,s8,128
80005a0a:	ca36                	sw	a3,20(sp)
80005a0c:	80003ab7          	lui	s5,0x80003
80005a10:	068a8a93          	addi	s5,s5,104 # 80003068 <__SEGGER_RTL_ipow10>
80005a14:	0c058b63          	beqz	a1,80005aea <__SEGGER_RTL_vfprintf+0x8b8>
80005a18:	45b9                	li	a1,14
80005a1a:	08a5d563          	bge	a1,a0,80005aa4 <__SEGGER_RTL_vfprintf+0x872>
80005a1e:	4b01                	li	s6,0
80005a20:	a0e9                	j	80005aea <__SEGGER_RTL_vfprintf+0x8b8>
80005a22:	02500c93          	li	s9,37
80005a26:	02600593          	li	a1,38
80005a2a:	00b51f63          	bne	a0,a1,80005a48 <__SEGGER_RTL_vfprintf+0x816>
80005a2e:	8522                	mv	a0,s0
80005a30:	45b2                	lw	a1,12(sp)
80005a32:	087010ef          	jal	800072b8 <__divsf3>
80005a36:	a00d                	j	80005a58 <__SEGGER_RTL_vfprintf+0x826>
80005a38:	84051ee3          	bnez	a0,80005294 <__SEGGER_RTL_vfprintf+0x62>
80005a3c:	a509                	j	8000603e <__SEGGER_RTL_vfprintf+0xe0c>
80005a3e:	000a2583          	lw	a1,0(s4)
80005a42:	00b50023          	sb	a1,0(a0)
80005a46:	a8a1                	j	80005a9e <__SEGGER_RTL_vfprintf+0x86c>
80005a48:	40a00533          	neg	a0,a0
80005a4c:	666020ef          	jal	800080b2 <__SEGGER_RTL_pow10f>
80005a50:	85aa                	mv	a1,a0
80005a52:	8522                	mv	a0,s0
80005a54:	7b4010ef          	jal	80007208 <__mulsf3>
80005a58:	842a                	mv	s0,a0
80005a5a:	4581                	li	a1,0
80005a5c:	15d010ef          	jal	800073b8 <__eqsf2>
80005a60:	1a050c63          	beqz	a0,80005c18 <__SEGGER_RTL_vfprintf+0x9e6>
80005a64:	8522                	mv	a0,s0
80005a66:	26d010ef          	jal	800074d2 <__SEGGER_RTL_float32_isinf>
80005a6a:	14050c63          	beqz	a0,80005bc2 <__SEGGER_RTL_vfprintf+0x990>
80005a6e:	8522                	mv	a0,s0
80005a70:	4581                	li	a1,0
80005a72:	ab0ff0ef          	jal	80004d22 <__ltsf2>
80005a76:	6589                	lui	a1,0x2
80005a78:	00bc75b3          	and	a1,s8,a1
80005a7c:	54055d63          	bgez	a0,80005fd6 <__SEGGER_RTL_vfprintf+0xda4>
80005a80:	80008537          	lui	a0,0x80008
80005a84:	28350513          	addi	a0,a0,643 # 80008283 <.L.str.2>
80005a88:	5aa2                	lw	s5,40(sp)
80005a8a:	56058763          	beqz	a1,80005ff8 <__SEGGER_RTL_vfprintf+0xdc6>
80005a8e:	80008537          	lui	a0,0x80008
80005a92:	27e50513          	addi	a0,a0,638 # 8000827e <.L.str.1>
80005a96:	a38d                	j	80005ff8 <__SEGGER_RTL_vfprintf+0xdc6>
80005a98:	c10c                	sw	a1,0(a0)
80005a9a:	00052223          	sw	zero,4(a0)
80005a9e:	0491                	addi	s1,s1,4
80005aa0:	ff4ff06f          	j	80005294 <__SEGGER_RTL_vfprintf+0x62>
80005aa4:	fff54593          	not	a1,a0
80005aa8:	95da                	add	a1,a1,s6
80005aaa:	4641                	li	a2,16
80005aac:	8b2e                	mv	s6,a1
80005aae:	00c5c363          	blt	a1,a2,80005ab4 <__SEGGER_RTL_vfprintf+0x882>
80005ab2:	4b41                	li	s6,16
80005ab4:	ea9d                	bnez	a3,80005aea <__SEGGER_RTL_vfprintf+0x8b8>
80005ab6:	c995                	beqz	a1,80005aea <__SEGGER_RTL_vfprintf+0x8b8>
80005ab8:	855a                	mv	a0,s6
80005aba:	5f8020ef          	jal	800080b2 <__SEGGER_RTL_pow10f>
80005abe:	85aa                	mv	a1,a0
80005ac0:	8522                	mv	a0,s0
80005ac2:	746010ef          	jal	80007208 <__mulsf3>
80005ac6:	3f0005b7          	lui	a1,0x3f000
80005aca:	8aaff0ef          	jal	80004b74 <__addsf3>
80005ace:	3c1010ef          	jal	8000768e <floorf>
80005ad2:	412005b7          	lui	a1,0x41200
80005ad6:	26d010ef          	jal	80007542 <fmodf>
80005ada:	4581                	li	a1,0
80005adc:	0dd010ef          	jal	800073b8 <__eqsf2>
80005ae0:	e501                	bnez	a0,80005ae8 <__SEGGER_RTL_vfprintf+0x8b6>
80005ae2:	1b7d                	addi	s6,s6,-1
80005ae4:	fc0b1ae3          	bnez	s6,80005ab8 <__SEGGER_RTL_vfprintf+0x886>
80005ae8:	4576                	lw	a0,92(sp)
80005aea:	416005b3          	neg	a1,s6
80005aee:	1541                	addi	a0,a0,-16
80005af0:	00a5c363          	blt	a1,a0,80005af6 <__SEGGER_RTL_vfprintf+0x8c4>
80005af4:	852e                	mv	a0,a1
80005af6:	5bc020ef          	jal	800080b2 <__SEGGER_RTL_pow10f>
80005afa:	55fd                	li	a1,-1
80005afc:	203010ef          	jal	800074fe <ldexpf>
80005b00:	85aa                	mv	a1,a0
80005b02:	8522                	mv	a0,s0
80005b04:	870ff0ef          	jal	80004b74 <__addsf3>
80005b08:	8baa                	mv	s7,a0
80005b0a:	4576                	lw	a0,92(sp)
80005b0c:	0505                	addi	a0,a0,1
80005b0e:	5a4020ef          	jal	800080b2 <__SEGGER_RTL_pow10f>
80005b12:	85aa                	mv	a1,a0
80005b14:	855e                	mv	a0,s7
80005b16:	a78ff0ef          	jal	80004d8e <__gesf2>
80005b1a:	45f6                	lw	a1,92(sp)
80005b1c:	00052513          	slti	a0,a0,0
80005b20:	00154513          	xori	a0,a0,1
80005b24:	952e                	add	a0,a0,a1
80005b26:	02054663          	bltz	a0,80005b52 <__SEGGER_RTL_vfprintf+0x920>
80005b2a:	45c5                	li	a1,17
80005b2c:	02b56863          	bltu	a0,a1,80005b5c <__SEGGER_RTL_vfprintf+0x92a>
80005b30:	ff050593          	addi	a1,a0,-16
80005b34:	ceae                	sw	a1,92(sp)
80005b36:	40ad8533          	sub	a0,s11,a0
80005b3a:	578020ef          	jal	800080b2 <__SEGGER_RTL_pow10f>
80005b3e:	85aa                	mv	a1,a0
80005b40:	855e                	mv	a0,s7
80005b42:	6c6010ef          	jal	80007208 <__mulsf3>
80005b46:	09f010ef          	jal	800073e4 <__fixunssfdi>
80005b4a:	842a                	mv	s0,a0
80005b4c:	84ae                	mv	s1,a1
80005b4e:	d202                	sw	zero,36(sp)
80005b50:	a01d                	j	80005b76 <__SEGGER_RTL_vfprintf+0x944>
80005b52:	d25e                	sw	s7,36(sp)
80005b54:	4401                	li	s0,0
80005b56:	4481                	li	s1,0
80005b58:	ce82                	sw	zero,92(sp)
80005b5a:	a831                	j	80005b76 <__SEGGER_RTL_vfprintf+0x944>
80005b5c:	ce82                	sw	zero,92(sp)
80005b5e:	855e                	mv	a0,s7
80005b60:	085010ef          	jal	800073e4 <__fixunssfdi>
80005b64:	842a                	mv	s0,a0
80005b66:	84ae                	mv	s1,a1
80005b68:	a64ff0ef          	jal	80004dcc <__floatundisf>
80005b6c:	85aa                	mv	a1,a0
80005b6e:	855e                	mv	a0,s7
80005b70:	ffdfe0ef          	jal	80004b6c <__subsf3>
80005b74:	d22a                	sw	a0,36(sp)
80005b76:	4c81                	li	s9,0
80005b78:	bffc7b93          	andi	s7,s8,-1025
80005b7c:	5522                	lw	a0,40(sp)
80005b7e:	40ab0533          	sub	a0,s6,a0
80005b82:	008a8593          	addi	a1,s5,8
80005b86:	46d2                	lw	a3,20(sp)
80005b88:	41d0                	lw	a2,4(a1)
80005b8a:	00c48563          	beq	s1,a2,80005b94 <__SEGGER_RTL_vfprintf+0x962>
80005b8e:	00c4b633          	sltu	a2,s1,a2
80005b92:	a021                	j	80005b9a <__SEGGER_RTL_vfprintf+0x968>
80005b94:	4190                	lw	a2,0(a1)
80005b96:	00c43633          	sltu	a2,s0,a2
80005b9a:	0505                	addi	a0,a0,1
80005b9c:	0c85                	addi	s9,s9,1
80005b9e:	05a1                	addi	a1,a1,8 # 41200008 <_flash_size+0x41100008>
80005ba0:	d665                	beqz	a2,80005b88 <__SEGGER_RTL_vfprintf+0x956>
80005ba2:	45f6                	lw	a1,92(sp)
80005ba4:	00db6633          	or	a2,s6,a3
80005ba8:	060c7693          	andi	a3,s8,96
80005bac:	00163613          	seqz	a2,a2
80005bb0:	00d036b3          	snez	a3,a3
80005bb4:	fff6c693          	not	a3,a3
80005bb8:	9636                	add	a2,a2,a3
80005bba:	8e0d                	sub	a2,a2,a1
80005bbc:	40a60ab3          	sub	s5,a2,a0
80005bc0:	a2e9                	j	80005d8a <__SEGGER_RTL_vfprintf+0xb58>
80005bc2:	44f6                	lw	s1,92(sp)
80005bc4:	412005b7          	lui	a1,0x41200
80005bc8:	8522                	mv	a0,s0
80005bca:	9c4ff0ef          	jal	80004d8e <__gesf2>
80005bce:	02054063          	bltz	a0,80005bee <__SEGGER_RTL_vfprintf+0x9bc>
80005bd2:	412005b7          	lui	a1,0x41200
80005bd6:	8522                	mv	a0,s0
80005bd8:	6e0010ef          	jal	800072b8 <__divsf3>
80005bdc:	842a                	mv	s0,a0
80005bde:	0485                	addi	s1,s1,1
80005be0:	412005b7          	lui	a1,0x41200
80005be4:	9aaff0ef          	jal	80004d8e <__gesf2>
80005be8:	fe0555e3          	bgez	a0,80005bd2 <__SEGGER_RTL_vfprintf+0x9a0>
80005bec:	cea6                	sw	s1,92(sp)
80005bee:	3f8005b7          	lui	a1,0x3f800
80005bf2:	8522                	mv	a0,s0
80005bf4:	92eff0ef          	jal	80004d22 <__ltsf2>
80005bf8:	02055063          	bgez	a0,80005c18 <__SEGGER_RTL_vfprintf+0x9e6>
80005bfc:	412005b7          	lui	a1,0x41200
80005c00:	8522                	mv	a0,s0
80005c02:	606010ef          	jal	80007208 <__mulsf3>
80005c06:	842a                	mv	s0,a0
80005c08:	14fd                	addi	s1,s1,-1
80005c0a:	3f8005b7          	lui	a1,0x3f800
80005c0e:	914ff0ef          	jal	80004d22 <__ltsf2>
80005c12:	fe0545e3          	bltz	a0,80005bfc <__SEGGER_RTL_vfprintf+0x9ca>
80005c16:	cea6                	sw	s1,92(sp)
80005c18:	001b3513          	seqz	a0,s6
80005c1c:	5582                	lw	a1,32(sp)
80005c1e:	00bac5b3          	xor	a1,s5,a1
80005c22:	0015b593          	seqz	a1,a1
80005c26:	40bb0b33          	sub	s6,s6,a1
80005c2a:	157d                	addi	a0,a0,-1
80005c2c:	01657bb3          	and	s7,a0,s6
80005c30:	41700533          	neg	a0,s7
80005c34:	47e020ef          	jal	800080b2 <__SEGGER_RTL_pow10f>
80005c38:	55fd                	li	a1,-1
80005c3a:	0c5010ef          	jal	800074fe <ldexpf>
80005c3e:	85aa                	mv	a1,a0
80005c40:	8522                	mv	a0,s0
80005c42:	f33fe0ef          	jal	80004b74 <__addsf3>
80005c46:	8caa                	mv	s9,a0
80005c48:	412005b7          	lui	a1,0x41200
80005c4c:	942ff0ef          	jal	80004d8e <__gesf2>
80005c50:	00054b63          	bltz	a0,80005c66 <__SEGGER_RTL_vfprintf+0xa34>
80005c54:	4576                	lw	a0,92(sp)
80005c56:	0505                	addi	a0,a0,1
80005c58:	ceaa                	sw	a0,92(sp)
80005c5a:	412005b7          	lui	a1,0x41200
80005c5e:	8566                	mv	a0,s9
80005c60:	658010ef          	jal	800072b8 <__divsf3>
80005c64:	8caa                	mv	s9,a0
80005c66:	5aa2                	lw	s5,40(sp)
80005c68:	060b8563          	beqz	s7,80005cd2 <__SEGGER_RTL_vfprintf+0xaa0>
80005c6c:	5502                	lw	a0,32(sp)
80005c6e:	c8050513          	addi	a0,a0,-896
80005c72:	00ac7533          	and	a0,s8,a0
80005c76:	4592                	lw	a1,4(sp)
80005c78:	04b51e63          	bne	a0,a1,80005cd4 <__SEGGER_RTL_vfprintf+0xaa2>
80005c7c:	4541                	li	a0,16
80005c7e:	00abc363          	blt	s7,a0,80005c84 <__SEGGER_RTL_vfprintf+0xa52>
80005c82:	4bc1                	li	s7,16
80005c84:	855e                	mv	a0,s7
80005c86:	42c020ef          	jal	800080b2 <__SEGGER_RTL_pow10f>
80005c8a:	85aa                	mv	a1,a0
80005c8c:	8566                	mv	a0,s9
80005c8e:	57a010ef          	jal	80007208 <__mulsf3>
80005c92:	752010ef          	jal	800073e4 <__fixunssfdi>
80005c96:	842a                	mv	s0,a0
80005c98:	8d4d                	or	a0,a0,a1
80005c9a:	cd05                	beqz	a0,80005cd2 <__SEGGER_RTL_vfprintf+0xaa0>
80005c9c:	84ae                	mv	s1,a1
80005c9e:	4629                	li	a2,10
80005ca0:	8522                	mv	a0,s0
80005ca2:	85a6                	mv	a1,s1
80005ca4:	4681                	li	a3,0
80005ca6:	251010ef          	jal	800076f6 <__udivdi3>
80005caa:	03358633          	mul	a2,a1,s3
80005cae:	033536b3          	mulhu	a3,a0,s3
80005cb2:	9636                	add	a2,a2,a3
80005cb4:	033506b3          	mul	a3,a0,s3
80005cb8:	8c91                	sub	s1,s1,a2
80005cba:	00d43633          	sltu	a2,s0,a3
80005cbe:	8c91                	sub	s1,s1,a2
80005cc0:	8c15                	sub	s0,s0,a3
80005cc2:	8c45                	or	s0,s0,s1
80005cc4:	32041e63          	bnez	s0,80006000 <__SEGGER_RTL_vfprintf+0xdce>
80005cc8:	1bfd                	addi	s7,s7,-1
80005cca:	842a                	mv	s0,a0
80005ccc:	84ae                	mv	s1,a1
80005cce:	fc0b98e3          	bnez	s7,80005c9e <__SEGGER_RTL_vfprintf+0xa6c>
80005cd2:	4b01                	li	s6,0
80005cd4:	d266                	sw	s9,36(sp)
80005cd6:	080c7513          	andi	a0,s8,128
80005cda:	416a85b3          	sub	a1,s5,s6
80005cde:	4476                	lw	s0,92(sp)
80005ce0:	00ab6533          	or	a0,s6,a0
80005ce4:	00a03533          	snez	a0,a0
80005ce8:	8d89                	sub	a1,a1,a0
80005cea:	013c1513          	slli	a0,s8,0x13
80005cee:	ffb58a93          	addi	s5,a1,-5 # 411ffffb <_flash_size+0x410ffffb>
80005cf2:	00054463          	bltz	a0,80005cfa <__SEGGER_RTL_vfprintf+0xac8>
80005cf6:	4c85                	li	s9,1
80005cf8:	a891                	j	80005d4c <__SEGGER_RTL_vfprintf+0xb1a>
80005cfa:	4502                	lw	a0,0(sp)
80005cfc:	02a41533          	mulh	a0,s0,a0
80005d00:	01f55593          	srli	a1,a0,0x1f
80005d04:	952e                	add	a0,a0,a1
80005d06:	00151593          	slli	a1,a0,0x1
80005d0a:	40a40533          	sub	a0,s0,a0
80005d0e:	8d0d                	sub	a0,a0,a1
80005d10:	0509                	addi	a0,a0,2
80005d12:	050a                	slli	a0,a0,0x2
80005d14:	edc18593          	addi	a1,gp,-292 # 8000376c <.LJTI0_3>
80005d18:	952e                	add	a0,a0,a1
80005d1a:	4108                	lw	a0,0(a0)
80005d1c:	4b89                	li	s7,2
80005d1e:	54fd                	li	s1,-1
80005d20:	412005b7          	lui	a1,0x41200
80005d24:	4c85                	li	s9,1
80005d26:	8502                	jr	a0
80005d28:	4b8d                	li	s7,3
80005d2a:	54f9                	li	s1,-2
80005d2c:	42c805b7          	lui	a1,0x42c80
80005d30:	5512                	lw	a0,36(sp)
80005d32:	4d6010ef          	jal	80007208 <__mulsf3>
80005d36:	d22a                	sw	a0,36(sp)
80005d38:	9426                	add	s0,s0,s1
80005d3a:	cea2                	sw	s0,92(sp)
80005d3c:	9aa6                	add	s5,s5,s1
80005d3e:	8cde                	mv	s9,s7
80005d40:	01602533          	sgtz	a0,s6
80005d44:	40a00533          	neg	a0,a0
80005d48:	01657b33          	and	s6,a0,s6
80005d4c:	4542                	lw	a0,16(sp)
80005d4e:	00ac7bb3          	and	s7,s8,a0
80005d52:	060c7513          	andi	a0,s8,96
80005d56:	00a03533          	snez	a0,a0
80005d5a:	40aa84b3          	sub	s1,s5,a0
80005d5e:	8522                	mv	a0,s0
80005d60:	9caff0ef          	jal	80004f2a <abs>
80005d64:	06452513          	slti	a0,a0,100
80005d68:	00154513          	xori	a0,a0,1
80005d6c:	40a48ab3          	sub	s5,s1,a0
80005d70:	5c12                	lw	s8,36(sp)
80005d72:	8562                	mv	a0,s8
80005d74:	670010ef          	jal	800073e4 <__fixunssfdi>
80005d78:	842a                	mv	s0,a0
80005d7a:	84ae                	mv	s1,a1
80005d7c:	850ff0ef          	jal	80004dcc <__floatundisf>
80005d80:	85aa                	mv	a1,a0
80005d82:	8562                	mv	a0,s8
80005d84:	de9fe0ef          	jal	80004b6c <__subsf3>
80005d88:	d22a                	sw	a0,36(sp)
80005d8a:	01502533          	sgtz	a0,s5
80005d8e:	40a00533          	neg	a0,a0
80005d92:	210bf593          	andi	a1,s7,528
80005d96:	01557c33          	and	s8,a0,s5
80005d9a:	e999                	bnez	a1,80005db0 <__SEGGER_RTL_vfprintf+0xb7e>
80005d9c:	01505a63          	blez	s5,80005db0 <__SEGGER_RTL_vfprintf+0xb7e>
80005da0:	1c7d                	addi	s8,s8,-1
80005da2:	02000593          	li	a1,32
80005da6:	8552                	mv	a0,s4
80005da8:	ab0ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005dac:	fe0c1ae3          	bnez	s8,80005da0 <__SEGGER_RTL_vfprintf+0xb6e>
80005db0:	80003ab7          	lui	s5,0x80003
80005db4:	068a8a93          	addi	s5,s5,104 # 80003068 <__SEGGER_RTL_ipow10>
80005db8:	020bf593          	andi	a1,s7,32
80005dbc:	040bf513          	andi	a0,s7,64
80005dc0:	e589                	bnez	a1,80005dca <__SEGGER_RTL_vfprintf+0xb98>
80005dc2:	cd09                	beqz	a0,80005ddc <__SEGGER_RTL_vfprintf+0xbaa>
80005dc4:	02000593          	li	a1,32
80005dc8:	a039                	j	80005dd6 <__SEGGER_RTL_vfprintf+0xba4>
80005dca:	c501                	beqz	a0,80005dd2 <__SEGGER_RTL_vfprintf+0xba0>
80005dcc:	02d00593          	li	a1,45
80005dd0:	a019                	j	80005dd6 <__SEGGER_RTL_vfprintf+0xba4>
80005dd2:	02b00593          	li	a1,43
80005dd6:	8552                	mv	a0,s4
80005dd8:	a80ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005ddc:	010bf513          	andi	a0,s7,16
80005de0:	e919                	bnez	a0,80005df6 <__SEGGER_RTL_vfprintf+0xbc4>
80005de2:	000c0a63          	beqz	s8,80005df6 <__SEGGER_RTL_vfprintf+0xbc4>
80005de6:	1c7d                	addi	s8,s8,-1
80005de8:	03000593          	li	a1,48
80005dec:	8552                	mv	a0,s4
80005dee:	a6aff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005df2:	fe0c1ae3          	bnez	s8,80005de6 <__SEGGER_RTL_vfprintf+0xbb4>
80005df6:	1cfd                	addi	s9,s9,-1
80005df8:	003c9513          	slli	a0,s9,0x3
80005dfc:	00aa85b3          	add	a1,s5,a0
80005e00:	41c8                	lw	a0,4(a1)
80005e02:	418c                	lw	a1,0(a1)
80005e04:	02a48863          	beq	s1,a0,80005e34 <__SEGGER_RTL_vfprintf+0xc02>
80005e08:	00a4b633          	sltu	a2,s1,a0
80005e0c:	e61d                	bnez	a2,80005e3a <__SEGGER_RTL_vfprintf+0xc08>
80005e0e:	03000613          	li	a2,48
80005e12:	00b436b3          	sltu	a3,s0,a1
80005e16:	8c89                	sub	s1,s1,a0
80005e18:	8c95                	sub	s1,s1,a3
80005e1a:	8c0d                	sub	s0,s0,a1
80005e1c:	00a48563          	beq	s1,a0,80005e26 <__SEGGER_RTL_vfprintf+0xbf4>
80005e20:	00a4b6b3          	sltu	a3,s1,a0
80005e24:	a019                	j	80005e2a <__SEGGER_RTL_vfprintf+0xbf8>
80005e26:	00b436b3          	sltu	a3,s0,a1
80005e2a:	0605                	addi	a2,a2,1
80005e2c:	d2fd                	beqz	a3,80005e12 <__SEGGER_RTL_vfprintf+0xbe0>
80005e2e:	0ff67593          	zext.b	a1,a2
80005e32:	a031                	j	80005e3e <__SEGGER_RTL_vfprintf+0xc0c>
80005e34:	00b43633          	sltu	a2,s0,a1
80005e38:	da79                	beqz	a2,80005e0e <__SEGGER_RTL_vfprintf+0xbdc>
80005e3a:	03000593          	li	a1,48
80005e3e:	8552                	mv	a0,s4
80005e40:	a18ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005e44:	fa0c99e3          	bnez	s9,80005df6 <__SEGGER_RTL_vfprintf+0xbc4>
80005e48:	5502                	lw	a0,32(sp)
80005e4a:	c0050513          	addi	a0,a0,-1024
80005e4e:	00abf433          	and	s0,s7,a0
80005e52:	cc01                	beqz	s0,80005e6a <__SEGGER_RTL_vfprintf+0xc38>
80005e54:	4576                	lw	a0,92(sp)
80005e56:	00a05a63          	blez	a0,80005e6a <__SEGGER_RTL_vfprintf+0xc38>
80005e5a:	157d                	addi	a0,a0,-1
80005e5c:	ceaa                	sw	a0,92(sp)
80005e5e:	03000593          	li	a1,48
80005e62:	8552                	mv	a0,s4
80005e64:	9f4ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005e68:	b7f5                	j	80005e54 <__SEGGER_RTL_vfprintf+0xc22>
80005e6a:	080bf513          	andi	a0,s7,128
80005e6e:	00ab6533          	or	a0,s6,a0
80005e72:	54b2                	lw	s1,44(sp)
80005e74:	cd55                	beqz	a0,80005f30 <__SEGGER_RTL_vfprintf+0xcfe>
80005e76:	02e00593          	li	a1,46
80005e7a:	8552                	mv	a0,s4
80005e7c:	9dcff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005e80:	45c1                	li	a1,16
80005e82:	855a                	mv	a0,s6
80005e84:	00bb4363          	blt	s6,a1,80005e8a <__SEGGER_RTL_vfprintf+0xc58>
80005e88:	4541                	li	a0,16
80005e8a:	00a025b3          	sgtz	a1,a0
80005e8e:	4676                	lw	a2,92(sp)
80005e90:	40b005b3          	neg	a1,a1
80005e94:	00a5fcb3          	and	s9,a1,a0
80005e98:	00143513          	seqz	a0,s0
80005e9c:	157d                	addi	a0,a0,-1
80005e9e:	8d71                	and	a0,a0,a2
80005ea0:	40ac8533          	sub	a0,s9,a0
80005ea4:	20e020ef          	jal	800080b2 <__SEGGER_RTL_pow10f>
80005ea8:	07605763          	blez	s6,80005f16 <__SEGGER_RTL_vfprintf+0xce4>
80005eac:	85aa                	mv	a1,a0
80005eae:	5512                	lw	a0,36(sp)
80005eb0:	358010ef          	jal	80007208 <__mulsf3>
80005eb4:	530010ef          	jal	800073e4 <__fixunssfdi>
80005eb8:	842a                	mv	s0,a0
80005eba:	84ae                	mv	s1,a1
80005ebc:	8ae6                	mv	s5,s9
80005ebe:	1afd                	addi	s5,s5,-1
80005ec0:	003a9513          	slli	a0,s5,0x3
80005ec4:	800035b7          	lui	a1,0x80003
80005ec8:	06858593          	addi	a1,a1,104 # 80003068 <__SEGGER_RTL_ipow10>
80005ecc:	95aa                	add	a1,a1,a0
80005ece:	41c8                	lw	a0,4(a1)
80005ed0:	418c                	lw	a1,0(a1)
80005ed2:	02a48863          	beq	s1,a0,80005f02 <__SEGGER_RTL_vfprintf+0xcd0>
80005ed6:	00a4b633          	sltu	a2,s1,a0
80005eda:	e61d                	bnez	a2,80005f08 <__SEGGER_RTL_vfprintf+0xcd6>
80005edc:	03000613          	li	a2,48
80005ee0:	00b436b3          	sltu	a3,s0,a1
80005ee4:	8c89                	sub	s1,s1,a0
80005ee6:	8c95                	sub	s1,s1,a3
80005ee8:	8c0d                	sub	s0,s0,a1
80005eea:	00a48563          	beq	s1,a0,80005ef4 <__SEGGER_RTL_vfprintf+0xcc2>
80005eee:	00a4b6b3          	sltu	a3,s1,a0
80005ef2:	a019                	j	80005ef8 <__SEGGER_RTL_vfprintf+0xcc6>
80005ef4:	00b436b3          	sltu	a3,s0,a1
80005ef8:	0605                	addi	a2,a2,1
80005efa:	d2fd                	beqz	a3,80005ee0 <__SEGGER_RTL_vfprintf+0xcae>
80005efc:	0ff67593          	zext.b	a1,a2
80005f00:	a031                	j	80005f0c <__SEGGER_RTL_vfprintf+0xcda>
80005f02:	00b43633          	sltu	a2,s0,a1
80005f06:	da79                	beqz	a2,80005edc <__SEGGER_RTL_vfprintf+0xcaa>
80005f08:	03000593          	li	a1,48
80005f0c:	8552                	mv	a0,s4
80005f0e:	94aff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005f12:	fa0a96e3          	bnez	s5,80005ebe <__SEGGER_RTL_vfprintf+0xc8c>
80005f16:	419b0533          	sub	a0,s6,s9
80005f1a:	54b2                	lw	s1,44(sp)
80005f1c:	c911                	beqz	a0,80005f30 <__SEGGER_RTL_vfprintf+0xcfe>
80005f1e:	416c8433          	sub	s0,s9,s6
80005f22:	03000593          	li	a1,48
80005f26:	8552                	mv	a0,s4
80005f28:	930ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005f2c:	0405                	addi	s0,s0,1
80005f2e:	f875                	bnez	s0,80005f22 <__SEGGER_RTL_vfprintf+0xcf0>
80005f30:	400bf513          	andi	a0,s7,1024
80005f34:	02500c93          	li	s9,37
80005f38:	c969                	beqz	a0,8000600a <__SEGGER_RTL_vfprintf+0xdd8>
80005f3a:	0bca                	slli	s7,s7,0x12
80005f3c:	41fbd513          	srai	a0,s7,0x1f
80005f40:	9901                	andi	a0,a0,-32
80005f42:	06550593          	addi	a1,a0,101
80005f46:	8552                	mv	a0,s4
80005f48:	910ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005f4c:	4576                	lw	a0,92(sp)
80005f4e:	00054963          	bltz	a0,80005f60 <__SEGGER_RTL_vfprintf+0xd2e>
80005f52:	02b00593          	li	a1,43
80005f56:	8552                	mv	a0,s4
80005f58:	900ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005f5c:	4576                	lw	a0,92(sp)
80005f5e:	a811                	j	80005f72 <__SEGGER_RTL_vfprintf+0xd40>
80005f60:	02d00593          	li	a1,45
80005f64:	8552                	mv	a0,s4
80005f66:	8f2ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005f6a:	4576                	lw	a0,92(sp)
80005f6c:	40a00533          	neg	a0,a0
80005f70:	ceaa                	sw	a0,92(sp)
80005f72:	06400493          	li	s1,100
80005f76:	02954663          	blt	a0,s1,80005fa2 <__SEGGER_RTL_vfprintf+0xd70>
80005f7a:	4422                	lw	s0,8(sp)
80005f7c:	02853533          	mulhu	a0,a0,s0
80005f80:	8115                	srli	a0,a0,0x5
80005f82:	03050593          	addi	a1,a0,48
80005f86:	8552                	mv	a0,s4
80005f88:	8d0ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005f8c:	4576                	lw	a0,92(sp)
80005f8e:	028515b3          	mulh	a1,a0,s0
80005f92:	01f5d613          	srli	a2,a1,0x1f
80005f96:	8595                	srai	a1,a1,0x5
80005f98:	95b2                	add	a1,a1,a2
80005f9a:	029585b3          	mul	a1,a1,s1
80005f9e:	8d0d                	sub	a0,a0,a1
80005fa0:	ceaa                	sw	a0,92(sp)
80005fa2:	54b2                	lw	s1,44(sp)
80005fa4:	4462                	lw	s0,24(sp)
80005fa6:	02851533          	mulh	a0,a0,s0
80005faa:	01f55593          	srli	a1,a0,0x1f
80005fae:	8509                	srai	a0,a0,0x2
80005fb0:	952e                	add	a0,a0,a1
80005fb2:	03050593          	addi	a1,a0,48
80005fb6:	8552                	mv	a0,s4
80005fb8:	8a0ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
80005fbc:	4576                	lw	a0,92(sp)
80005fbe:	028515b3          	mulh	a1,a0,s0
80005fc2:	01f5d613          	srli	a2,a1,0x1f
80005fc6:	8589                	srai	a1,a1,0x2
80005fc8:	95b2                	add	a1,a1,a2
80005fca:	033585b3          	mul	a1,a1,s3
80005fce:	8d0d                	sub	a0,a0,a1
80005fd0:	03050593          	addi	a1,a0,48
80005fd4:	a805                	j	80006004 <__SEGGER_RTL_vfprintf+0xdd2>
80005fd6:	5aa2                	lw	s5,40(sp)
80005fd8:	c591                	beqz	a1,80005fe4 <__SEGGER_RTL_vfprintf+0xdb2>
80005fda:	800085b7          	lui	a1,0x80008
80005fde:	28858593          	addi	a1,a1,648 # 80008288 <.L.str.3>
80005fe2:	a029                	j	80005fec <__SEGGER_RTL_vfprintf+0xdba>
80005fe4:	800085b7          	lui	a1,0x80008
80005fe8:	28d58593          	addi	a1,a1,653 # 8000828d <.L.str.4>
80005fec:	00158513          	addi	a0,a1,1
80005ff0:	020c7613          	andi	a2,s8,32
80005ff4:	c211                	beqz	a2,80005ff8 <__SEGGER_RTL_vfprintf+0xdc6>
80005ff6:	852e                	mv	a0,a1
80005ff8:	effc7b93          	andi	s7,s8,-257
80005ffc:	837ff06f          	j	80005832 <__SEGGER_RTL_vfprintf+0x600>
80006000:	8b5e                	mv	s6,s7
80006002:	b9c9                	j	80005cd4 <__SEGGER_RTL_vfprintf+0xaa2>
80006004:	8552                	mv	a0,s4
80006006:	852ff0ef          	jal	80005058 <__SEGGER_RTL_putc>
8000600a:	a80c0563          	beqz	s8,80005294 <__SEGGER_RTL_vfprintf+0x62>
8000600e:	1c7d                	addi	s8,s8,-1
80006010:	02000593          	li	a1,32
80006014:	bfc5                	j	80006004 <__SEGGER_RTL_vfprintf+0xdd2>
80006016:	00ca2503          	lw	a0,12(s4)
8000601a:	c911                	beqz	a0,8000602e <__SEGGER_RTL_vfprintf+0xdfc>
8000601c:	000a2583          	lw	a1,0(s4)
80006020:	004a2603          	lw	a2,4(s4)
80006024:	00c5f563          	bgeu	a1,a2,8000602e <__SEGGER_RTL_vfprintf+0xdfc>
80006028:	952e                	add	a0,a0,a1
8000602a:	00050023          	sb	zero,0(a0)
8000602e:	8552                	mv	a0,s4
80006030:	8c8ff0ef          	jal	800050f8 <__SEGGER_RTL_prin_flush>
80006034:	000a2503          	lw	a0,0(s4)
80006038:	6125                	addi	sp,sp,96
8000603a:	0b60106f          	j	800070f0 <__riscv_restore_12>
8000603e:	8552                	mv	a0,s4
80006040:	8b8ff0ef          	jal	800050f8 <__SEGGER_RTL_prin_flush>
80006044:	557d                	li	a0,-1
80006046:	bfcd                	j	80006038 <__SEGGER_RTL_vfprintf+0xe06>

Disassembly of section .segger.init.__SEGGER_init_heap:

80006048 <__SEGGER_init_heap>:
80006048:	00080537          	lui	a0,0x80
8000604c:	35850513          	addi	a0,a0,856 # 80358 <__heap_start__>

80006050 <.Lpcrel_hi1>:
80006050:	000845b7          	lui	a1,0x84
80006054:	35858593          	addi	a1,a1,856 # 84358 <__heap_end__>
80006058:	8d89                	sub	a1,a1,a0
8000605a:	a009                	j	8000605c <__SEGGER_RTL_init_heap>

Disassembly of section .text.libc.__SEGGER_RTL_init_heap:

8000605c <__SEGGER_RTL_init_heap>:
8000605c:	4621                	li	a2,8
8000605e:	00c5e963          	bltu	a1,a2,80006070 <__SEGGER_RTL_init_heap+0x14>
80006062:	00080637          	lui	a2,0x80
80006066:	34a62423          	sw	a0,840(a2) # 80348 <__SEGGER_RTL_heap_globals.0>
8000606a:	00052023          	sw	zero,0(a0)
8000606e:	c14c                	sw	a1,4(a0)
80006070:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_toupper:

80006072 <__SEGGER_RTL_ascii_toupper>:
80006072:	f9f50593          	addi	a1,a0,-97
80006076:	01a5b593          	sltiu	a1,a1,26
8000607a:	40b005b3          	neg	a1,a1
8000607e:	9981                	andi	a1,a1,-32
80006080:	952e                	add	a0,a0,a1
80006082:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_tolower:

80006084 <__SEGGER_RTL_ascii_tolower>:
80006084:	fbf50593          	addi	a1,a0,-65
80006088:	01a5b593          	sltiu	a1,a1,26
8000608c:	0596                	slli	a1,a1,0x5
8000608e:	8d4d                	or	a0,a0,a1
80006090:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towupper:

80006092 <__SEGGER_RTL_ascii_towupper>:
80006092:	f9f50593          	addi	a1,a0,-97
80006096:	01a5b593          	sltiu	a1,a1,26
8000609a:	40b005b3          	neg	a1,a1
8000609e:	9981                	andi	a1,a1,-32
800060a0:	952e                	add	a0,a0,a1
800060a2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towlower:

800060a4 <__SEGGER_RTL_ascii_towlower>:
800060a4:	fbf50593          	addi	a1,a0,-65
800060a8:	01a5b593          	sltiu	a1,a1,26
800060ac:	0596                	slli	a1,a1,0x5
800060ae:	8d4d                	or	a0,a0,a1
800060b0:	8082                	ret

Disassembly of section .text.gpio_set_pin_input:

800060b2 <gpio_set_pin_input>:
 * @param ptr GPIO base address
 * @param port Port index
 * @param pin Pin index
 */
static inline void gpio_set_pin_input(GPIO_Type *ptr, uint32_t port, uint8_t pin)
{
800060b2:	1141                	addi	sp,sp,-16
800060b4:	c62a                	sw	a0,12(sp)
800060b6:	c42e                	sw	a1,8(sp)
800060b8:	87b2                	mv	a5,a2
800060ba:	00f103a3          	sb	a5,7(sp)
    ptr->OE[port].CLEAR = 1 << pin;
800060be:	00714783          	lbu	a5,7(sp)
800060c2:	4705                	li	a4,1
800060c4:	00f717b3          	sll	a5,a4,a5
800060c8:	86be                	mv	a3,a5
800060ca:	4732                	lw	a4,12(sp)
800060cc:	47a2                	lw	a5,8(sp)
800060ce:	02078793          	addi	a5,a5,32
800060d2:	0792                	slli	a5,a5,0x4
800060d4:	97ba                	add	a5,a5,a4
800060d6:	c794                	sw	a3,8(a5)
}
800060d8:	0001                	nop
800060da:	0141                	addi	sp,sp,16
800060dc:	8082                	ret

Disassembly of section .text.gpio_set_pin_output:

800060de <gpio_set_pin_output>:
 * @param ptr GPIO base address
 * @param port Port index
 * @param pin Pin index
 */
static inline void gpio_set_pin_output(GPIO_Type *ptr, uint32_t port, uint8_t pin)
{
800060de:	1141                	addi	sp,sp,-16
800060e0:	c62a                	sw	a0,12(sp)
800060e2:	c42e                	sw	a1,8(sp)
800060e4:	87b2                	mv	a5,a2
800060e6:	00f103a3          	sb	a5,7(sp)
    ptr->OE[port].SET = 1 << pin;
800060ea:	00714783          	lbu	a5,7(sp)
800060ee:	4705                	li	a4,1
800060f0:	00f717b3          	sll	a5,a4,a5
800060f4:	86be                	mv	a3,a5
800060f6:	4732                	lw	a4,12(sp)
800060f8:	47a2                	lw	a5,8(sp)
800060fa:	02078793          	addi	a5,a5,32
800060fe:	0792                	slli	a5,a5,0x4
80006100:	97ba                	add	a5,a5,a4
80006102:	c3d4                	sw	a3,4(a5)
}
80006104:	0001                	nop
80006106:	0141                	addi	sp,sp,16
80006108:	8082                	ret

Disassembly of section .text.gpio_clear_pin_interrupt_flag:

8000610a <gpio_clear_pin_interrupt_flag>:
 * @param ptr GPIO base address
 * @param port Port index
 * @param pin Pin index
 */
static inline void gpio_clear_pin_interrupt_flag(GPIO_Type *ptr, uint32_t port, uint8_t pin)
{
8000610a:	1141                	addi	sp,sp,-16
8000610c:	c62a                	sw	a0,12(sp)
8000610e:	c42e                	sw	a1,8(sp)
80006110:	87b2                	mv	a5,a2
80006112:	00f103a3          	sb	a5,7(sp)
    ptr->IF[port].VALUE = 1 << pin;
80006116:	00714783          	lbu	a5,7(sp)
8000611a:	4705                	li	a4,1
8000611c:	00f717b3          	sll	a5,a4,a5
80006120:	86be                	mv	a3,a5
80006122:	4732                	lw	a4,12(sp)
80006124:	47a2                	lw	a5,8(sp)
80006126:	03078793          	addi	a5,a5,48
8000612a:	0792                	slli	a5,a5,0x4
8000612c:	97ba                	add	a5,a5,a4
8000612e:	c394                	sw	a3,0(a5)
}
80006130:	0001                	nop
80006132:	0141                	addi	sp,sp,16
80006134:	8082                	ret

Disassembly of section .text.gpio_enable_pin_interrupt:

80006136 <gpio_enable_pin_interrupt>:
 * @param ptr GPIO base address
 * @param port Port index
 * @param pin Pin index
 */
static inline void gpio_enable_pin_interrupt(GPIO_Type *ptr, uint32_t port, uint8_t pin)
{
80006136:	1141                	addi	sp,sp,-16
80006138:	c62a                	sw	a0,12(sp)
8000613a:	c42e                	sw	a1,8(sp)
8000613c:	87b2                	mv	a5,a2
8000613e:	00f103a3          	sb	a5,7(sp)
    ptr->IE[port].SET = 1 << pin;
80006142:	00714783          	lbu	a5,7(sp)
80006146:	4705                	li	a4,1
80006148:	00f717b3          	sll	a5,a4,a5
8000614c:	86be                	mv	a3,a5
8000614e:	4732                	lw	a4,12(sp)
80006150:	47a2                	lw	a5,8(sp)
80006152:	04078793          	addi	a5,a5,64
80006156:	0792                	slli	a5,a5,0x4
80006158:	97ba                	add	a5,a5,a4
8000615a:	c3d4                	sw	a3,4(a5)
}
8000615c:	0001                	nop
8000615e:	0141                	addi	sp,sp,16
80006160:	8082                	ret

Disassembly of section .text.test_gpio_input_interrupt:

80006162 <test_gpio_input_interrupt>:
{
80006162:	715d                	addi	sp,sp,-80
80006164:	c686                	sw	ra,76(sp)
    printf("input interrupt\n");
80006166:	f8c18513          	addi	a0,gp,-116 # 8000381c <.LC1>
8000616a:	89cff0ef          	jal	80005206 <printf>
    printf("user led will be switched on off based on user switch\n");
8000616e:	fa018513          	addi	a0,gp,-96 # 80003830 <.LC2>
80006172:	894ff0ef          	jal	80005206 <printf>
    gpio_set_pin_output(BOARD_LED_GPIO_CTRL, BOARD_LED_GPIO_INDEX,
80006176:	465d                	li	a2,23
80006178:	4581                	li	a1,0
8000617a:	f00d0537          	lui	a0,0xf00d0
8000617e:	3785                	jal	800060de <gpio_set_pin_output>
    gpio_set_pin_input(BOARD_APP_GPIO_CTRL, BOARD_APP_GPIO_INDEX,
80006180:	4625                	li	a2,9
80006182:	4581                	li	a1,0
80006184:	f00d0537          	lui	a0,0xf00d0
80006188:	372d                	jal	800060b2 <gpio_set_pin_input>
    trigger = gpio_interrupt_trigger_edge_both;
8000618a:	4791                	li	a5,4
8000618c:	02f10fa3          	sb	a5,63(sp)
    gpio_config_pin_interrupt(BOARD_APP_GPIO_CTRL, BOARD_APP_GPIO_INDEX,
80006190:	03f14783          	lbu	a5,63(sp)
80006194:	86be                	mv	a3,a5
80006196:	4625                	li	a2,9
80006198:	4581                	li	a1,0
8000619a:	f00d0537          	lui	a0,0xf00d0
8000619e:	ec4fe0ef          	jal	80004862 <gpio_config_pin_interrupt>
    gpio_enable_pin_interrupt(BOARD_APP_GPIO_CTRL, BOARD_APP_GPIO_INDEX,
800061a2:	4625                	li	a2,9
800061a4:	4581                	li	a1,0
800061a6:	f00d0537          	lui	a0,0xf00d0
800061aa:	3771                	jal	80006136 <gpio_enable_pin_interrupt>
800061ac:	4785                	li	a5,1
800061ae:	ce3e                	sw	a5,28(sp)
800061b0:	4785                	li	a5,1
800061b2:	cc3e                	sw	a5,24(sp)
800061b4:	e40007b7          	lui	a5,0xe4000
800061b8:	ca3e                	sw	a5,20(sp)
800061ba:	47f2                	lw	a5,28(sp)
800061bc:	c83e                	sw	a5,16(sp)
800061be:	47e2                	lw	a5,24(sp)
800061c0:	c63e                	sw	a5,12(sp)

800061c2 <.LBB14>:
                                                             ((irq - 1) << HPM_PLIC_PRIORITY_SHIFT_PER_SOURCE));
800061c2:	47c2                	lw	a5,16(sp)
800061c4:	17fd                	addi	a5,a5,-1 # e3ffffff <__FLASH_segment_end__+0x63efffff>
800061c6:	00279713          	slli	a4,a5,0x2
                                                             HPM_PLIC_PRIORITY_OFFSET +
800061ca:	47d2                	lw	a5,20(sp)
800061cc:	97ba                	add	a5,a5,a4
800061ce:	0791                	addi	a5,a5,4
    volatile uint32_t *priority_ptr = (volatile uint32_t *) (base +
800061d0:	c43e                	sw	a5,8(sp)
    *priority_ptr = priority;
800061d2:	47a2                	lw	a5,8(sp)
800061d4:	4732                	lw	a4,12(sp)
800061d6:	c398                	sw	a4,0(a5)
}
800061d8:	0001                	nop

800061da <.LBE16>:
}
800061da:	0001                	nop
800061dc:	dc02                	sw	zero,56(sp)
800061de:	4785                	li	a5,1
800061e0:	da3e                	sw	a5,52(sp)
800061e2:	e40007b7          	lui	a5,0xe4000
800061e6:	d83e                	sw	a5,48(sp)
800061e8:	57e2                	lw	a5,56(sp)
800061ea:	d63e                	sw	a5,44(sp)
800061ec:	57d2                	lw	a5,52(sp)
800061ee:	d43e                	sw	a5,40(sp)

800061f0 <.LBB18>:
                                                            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
800061f0:	57b2                	lw	a5,44(sp)
800061f2:	00779713          	slli	a4,a5,0x7
                                                            HPM_PLIC_ENABLE_OFFSET +
800061f6:	57c2                	lw	a5,48(sp)
800061f8:	973e                	add	a4,a4,a5
                                                            ((irq >> 5) << 2));
800061fa:	57a2                	lw	a5,40(sp)
800061fc:	8395                	srli	a5,a5,0x5
800061fe:	078a                	slli	a5,a5,0x2
                                                            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
80006200:	973e                	add	a4,a4,a5
80006202:	6789                	lui	a5,0x2
80006204:	97ba                	add	a5,a5,a4
    volatile uint32_t *current_ptr = (volatile uint32_t *) (base +
80006206:	d23e                	sw	a5,36(sp)
    uint32_t current = *current_ptr;
80006208:	5792                	lw	a5,36(sp)
8000620a:	439c                	lw	a5,0(a5)
8000620c:	d03e                	sw	a5,32(sp)
    current = current | (1 << (irq & 0x1F));
8000620e:	57a2                	lw	a5,40(sp)
80006210:	8bfd                	andi	a5,a5,31
80006212:	4705                	li	a4,1
80006214:	00f717b3          	sll	a5,a4,a5
80006218:	873e                	mv	a4,a5
8000621a:	5782                	lw	a5,32(sp)
8000621c:	8fd9                	or	a5,a5,a4
8000621e:	d03e                	sw	a5,32(sp)
    *current_ptr = current;
80006220:	5792                	lw	a5,36(sp)
80006222:	5702                	lw	a4,32(sp)
80006224:	c398                	sw	a4,0(a5)
}
80006226:	0001                	nop

80006228 <.LBE20>:
}
80006228:	0001                	nop

8000622a <.L13>:
        __asm("wfi");
8000622a:	10500073          	wfi
8000622e:	bff5                	j	8000622a <.L13>

Disassembly of section .text.reset_handler:

80006230 <reset_handler>:
        ;
    }
}

__attribute__((weak)) void reset_handler(void)
{
80006230:	1141                	addi	sp,sp,-16
80006232:	c606                	sw	ra,12(sp)
    fencei();
80006234:	0000100f          	fence.i

    /* Call platform specific hardware initialization */
    system_init();
80006238:	8e5fd0ef          	jal	80003b1c <system_init>

    /* Entry function */
    MAIN_ENTRY();
8000623c:	809fd0ef          	jal	80003a44 <main>
}
80006240:	0001                	nop
80006242:	40b2                	lw	ra,12(sp)
80006244:	0141                	addi	sp,sp,16
80006246:	8082                	ret

Disassembly of section .text._init:

80006248 <_init>:
__attribute__((weak)) void *__dso_handle = (void *) &__dso_handle;
#endif

__attribute__((weak)) void _init(void)
{
}
80006248:	0001                	nop
8000624a:	8082                	ret

Disassembly of section .text.mchtmr_isr:

8000624c <mchtmr_isr>:
}
8000624c:	0001                	nop
8000624e:	8082                	ret

Disassembly of section .text.swi_isr:

80006250 <swi_isr>:
}
80006250:	0001                	nop
80006252:	8082                	ret

Disassembly of section .text.exception_handler:

80006254 <exception_handler>:

__attribute__((weak)) long exception_handler(long cause, long epc)
{
80006254:	1141                	addi	sp,sp,-16
80006256:	c62a                	sw	a0,12(sp)
80006258:	c42e                	sw	a1,8(sp)
    switch (cause) {
8000625a:	4732                	lw	a4,12(sp)
8000625c:	47bd                	li	a5,15
8000625e:	00e7ea63          	bltu	a5,a4,80006272 <.L23>
80006262:	47b2                	lw	a5,12(sp)
80006264:	00279713          	slli	a4,a5,0x2
80006268:	87818793          	addi	a5,gp,-1928 # 80003108 <.L7>
8000626c:	97ba                	add	a5,a5,a4
8000626e:	439c                	lw	a5,0(a5)
80006270:	8782                	jr	a5

80006272 <.L23>:
    case MCAUSE_LOAD_PAGE_FAULT:
        break;
    case MCAUSE_STORE_AMO_PAGE_FAULT:
        break;
    default:
        break;
80006272:	0001                	nop
    }
    /* Unhandled Trap */
    return epc;
80006274:	47a2                	lw	a5,8(sp)
}
80006276:	853e                	mv	a0,a5
80006278:	0141                	addi	sp,sp,16
8000627a:	8082                	ret

Disassembly of section .text.enable_plic_feature:

8000627c <enable_plic_feature>:
{
8000627c:	1141                	addi	sp,sp,-16
    uint32_t plic_feature = 0;
8000627e:	c602                	sw	zero,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_VECTORED_MODE;
80006280:	47b2                	lw	a5,12(sp)
80006282:	0027e793          	ori	a5,a5,2
80006286:	c63e                	sw	a5,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_PREEMPTIVE_PRIORITY_IRQ;
80006288:	47b2                	lw	a5,12(sp)
8000628a:	0017e793          	ori	a5,a5,1
8000628e:	c63e                	sw	a5,12(sp)
80006290:	e40007b7          	lui	a5,0xe4000
80006294:	c43e                	sw	a5,8(sp)
80006296:	47b2                	lw	a5,12(sp)
80006298:	c23e                	sw	a5,4(sp)

8000629a <.LBB14>:
    *(volatile uint32_t *) (base + HPM_PLIC_FEATURE_OFFSET) = feature;
8000629a:	47a2                	lw	a5,8(sp)
8000629c:	4712                	lw	a4,4(sp)
8000629e:	c398                	sw	a4,0(a5)
}
800062a0:	0001                	nop

800062a2 <.LBE14>:
}
800062a2:	0001                	nop
800062a4:	0141                	addi	sp,sp,16
800062a6:	8082                	ret

Disassembly of section .text.sysctl_enable_group_resource:

800062a8 <sysctl_enable_group_resource>:
{
800062a8:	7179                	addi	sp,sp,-48
800062aa:	d606                	sw	ra,44(sp)
800062ac:	c62a                	sw	a0,12(sp)
800062ae:	87ae                	mv	a5,a1
800062b0:	8736                	mv	a4,a3
800062b2:	00f105a3          	sb	a5,11(sp)
800062b6:	87b2                	mv	a5,a2
800062b8:	00f11423          	sh	a5,8(sp)
800062bc:	87ba                	mv	a5,a4
800062be:	00f10523          	sb	a5,10(sp)
    if (resource < sysctl_resource_linkable_start) {
800062c2:	00815703          	lhu	a4,8(sp)
800062c6:	0ff00793          	li	a5,255
800062ca:	00e7e463          	bltu	a5,a4,800062d2 <.L55>
        return status_invalid_argument;
800062ce:	4789                	li	a5,2
800062d0:	a851                	j	80006364 <.L56>

800062d2 <.L55>:
    index = (resource - sysctl_resource_linkable_start) / 32;
800062d2:	00815783          	lhu	a5,8(sp)
800062d6:	f0078793          	addi	a5,a5,-256 # e3ffff00 <__FLASH_segment_end__+0x63efff00>
800062da:	41f7d713          	srai	a4,a5,0x1f
800062de:	8b7d                	andi	a4,a4,31
800062e0:	97ba                	add	a5,a5,a4
800062e2:	8795                	srai	a5,a5,0x5
800062e4:	ce3e                	sw	a5,28(sp)
    offset = (resource - sysctl_resource_linkable_start) % 32;
800062e6:	00815783          	lhu	a5,8(sp)
800062ea:	f0078713          	addi	a4,a5,-256
800062ee:	41f75793          	srai	a5,a4,0x1f
800062f2:	83ed                	srli	a5,a5,0x1b
800062f4:	973e                	add	a4,a4,a5
800062f6:	8b7d                	andi	a4,a4,31
800062f8:	40f707b3          	sub	a5,a4,a5
800062fc:	cc3e                	sw	a5,24(sp)
    switch (group) {
800062fe:	00b14783          	lbu	a5,11(sp)
80006302:	efa9                	bnez	a5,8000635c <.L57>
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset)) | (enable ? (1UL << offset) : 0);
80006304:	4732                	lw	a4,12(sp)
80006306:	47f2                	lw	a5,28(sp)
80006308:	08078793          	addi	a5,a5,128
8000630c:	0792                	slli	a5,a5,0x4
8000630e:	97ba                	add	a5,a5,a4
80006310:	4398                	lw	a4,0(a5)
80006312:	47e2                	lw	a5,24(sp)
80006314:	4685                	li	a3,1
80006316:	00f697b3          	sll	a5,a3,a5
8000631a:	fff7c793          	not	a5,a5
8000631e:	8f7d                	and	a4,a4,a5
80006320:	00a14783          	lbu	a5,10(sp)
80006324:	c791                	beqz	a5,80006330 <.L58>
80006326:	47e2                	lw	a5,24(sp)
80006328:	4685                	li	a3,1
8000632a:	00f697b3          	sll	a5,a3,a5
8000632e:	a011                	j	80006332 <.L59>

80006330 <.L58>:
80006330:	4781                	li	a5,0

80006332 <.L59>:
80006332:	8f5d                	or	a4,a4,a5
80006334:	46b2                	lw	a3,12(sp)
80006336:	47f2                	lw	a5,28(sp)
80006338:	08078793          	addi	a5,a5,128
8000633c:	0792                	slli	a5,a5,0x4
8000633e:	97b6                	add	a5,a5,a3
80006340:	c398                	sw	a4,0(a5)
        if (enable) {
80006342:	00a14783          	lbu	a5,10(sp)
80006346:	cf89                	beqz	a5,80006360 <.L63>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
80006348:	0001                	nop

8000634a <.L61>:
8000634a:	00815783          	lhu	a5,8(sp)
8000634e:	85be                	mv	a1,a5
80006350:	4532                	lw	a0,12(sp)
80006352:	821fd0ef          	jal	80003b72 <sysctl_resource_target_is_busy>
80006356:	87aa                	mv	a5,a0
80006358:	fbed                	bnez	a5,8000634a <.L61>
        break;
8000635a:	a019                	j	80006360 <.L63>

8000635c <.L57>:
        return status_invalid_argument;
8000635c:	4789                	li	a5,2
8000635e:	a019                	j	80006364 <.L56>

80006360 <.L63>:
        break;
80006360:	0001                	nop
    return status_success;
80006362:	4781                	li	a5,0

80006364 <.L56>:
}
80006364:	853e                	mv	a0,a5
80006366:	50b2                	lw	ra,44(sp)
80006368:	6145                	addi	sp,sp,48
8000636a:	8082                	ret

Disassembly of section .text.sysctl_check_group_resource_enable:

8000636c <sysctl_check_group_resource_enable>:
{
8000636c:	1101                	addi	sp,sp,-32
8000636e:	c62a                	sw	a0,12(sp)
80006370:	87ae                	mv	a5,a1
80006372:	8732                	mv	a4,a2
80006374:	00f105a3          	sb	a5,11(sp)
80006378:	87ba                	mv	a5,a4
8000637a:	00f11423          	sh	a5,8(sp)
    index = (resource - sysctl_resource_linkable_start) / 32;
8000637e:	00815783          	lhu	a5,8(sp)
80006382:	f0078793          	addi	a5,a5,-256
80006386:	41f7d713          	srai	a4,a5,0x1f
8000638a:	8b7d                	andi	a4,a4,31
8000638c:	97ba                	add	a5,a5,a4
8000638e:	8795                	srai	a5,a5,0x5
80006390:	cc3e                	sw	a5,24(sp)
    offset = (resource - sysctl_resource_linkable_start) % 32;
80006392:	00815783          	lhu	a5,8(sp)
80006396:	f0078713          	addi	a4,a5,-256
8000639a:	41f75793          	srai	a5,a4,0x1f
8000639e:	83ed                	srli	a5,a5,0x1b
800063a0:	973e                	add	a4,a4,a5
800063a2:	8b7d                	andi	a4,a4,31
800063a4:	40f707b3          	sub	a5,a4,a5
800063a8:	ca3e                	sw	a5,20(sp)
    switch (group) {
800063aa:	00b14783          	lbu	a5,11(sp)
800063ae:	e38d                	bnez	a5,800063d0 <.L65>
        enable = ((ptr->GROUP0[index].VALUE & (1UL << offset)) != 0) ? true : false;
800063b0:	4732                	lw	a4,12(sp)
800063b2:	47e2                	lw	a5,24(sp)
800063b4:	08078793          	addi	a5,a5,128
800063b8:	0792                	slli	a5,a5,0x4
800063ba:	97ba                	add	a5,a5,a4
800063bc:	4398                	lw	a4,0(a5)
800063be:	47d2                	lw	a5,20(sp)
800063c0:	00f757b3          	srl	a5,a4,a5
800063c4:	8b85                	andi	a5,a5,1
800063c6:	00f037b3          	snez	a5,a5
800063ca:	00f10fa3          	sb	a5,31(sp)
        break;
800063ce:	a021                	j	800063d6 <.L66>

800063d0 <.L65>:
        enable =  false;
800063d0:	00010fa3          	sb	zero,31(sp)
        break;
800063d4:	0001                	nop

800063d6 <.L66>:
    return enable;
800063d6:	01f14783          	lbu	a5,31(sp)
}
800063da:	853e                	mv	a0,a5
800063dc:	6105                	addi	sp,sp,32
800063de:	8082                	ret

Disassembly of section .text.sysctl_config_cpu0_domain_clock:

800063e0 <sysctl_config_cpu0_domain_clock>:

hpm_stat_t sysctl_config_cpu0_domain_clock(SYSCTL_Type *ptr,
                                           clock_source_t source,
                                           uint32_t cpu_div,
                                           uint32_t ahb_sub_div)
{
800063e0:	7179                	addi	sp,sp,-48
800063e2:	d606                	sw	ra,44(sp)
800063e4:	c62a                	sw	a0,12(sp)
800063e6:	87ae                	mv	a5,a1
800063e8:	c232                	sw	a2,4(sp)
800063ea:	c036                	sw	a3,0(sp)
800063ec:	00f105a3          	sb	a5,11(sp)
    if (source >= clock_source_general_source_end) {
800063f0:	00b14703          	lbu	a4,11(sp)
800063f4:	479d                	li	a5,7
800063f6:	00e7f463          	bgeu	a5,a4,800063fe <.L86>
        return status_invalid_argument;
800063fa:	4789                	li	a5,2
800063fc:	a849                	j	8000648e <.L87>

800063fe <.L86>:
    }

    uint32_t origin_cpu_div = SYSCTL_CLOCK_CPU_DIV_GET(ptr->CLOCK_CPU[0]) + 1U;
800063fe:	4732                	lw	a4,12(sp)
80006400:	6789                	lui	a5,0x2
80006402:	97ba                	add	a5,a5,a4
80006404:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
80006408:	0ff7f793          	zext.b	a5,a5
8000640c:	0785                	addi	a5,a5,1
8000640e:	ce3e                	sw	a5,28(sp)
    if (origin_cpu_div == cpu_div) {
80006410:	4772                	lw	a4,28(sp)
80006412:	4792                	lw	a5,4(sp)
80006414:	02f71e63          	bne	a4,a5,80006450 <.L88>
        ptr->CLOCK_CPU[0] = SYSCTL_CLOCK_CPU_MUX_SET(source) | SYSCTL_CLOCK_CPU_DIV_SET(cpu_div) | SYSCTL_CLOCK_CPU_SUB0_DIV_SET(ahb_sub_div - 1);
80006418:	00b14783          	lbu	a5,11(sp)
8000641c:	07a2                	slli	a5,a5,0x8
8000641e:	7007f713          	andi	a4,a5,1792
80006422:	4792                	lw	a5,4(sp)
80006424:	0ff7f793          	zext.b	a5,a5
80006428:	8f5d                	or	a4,a4,a5
8000642a:	4782                	lw	a5,0(sp)
8000642c:	17fd                	addi	a5,a5,-1
8000642e:	01079693          	slli	a3,a5,0x10
80006432:	000f07b7          	lui	a5,0xf0
80006436:	8ff5                	and	a5,a5,a3
80006438:	8f5d                	or	a4,a4,a5
8000643a:	46b2                	lw	a3,12(sp)
8000643c:	6789                	lui	a5,0x2
8000643e:	97b6                	add	a5,a5,a3
80006440:	80e7a023          	sw	a4,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
        while (sysctl_cpu_clock_any_is_busy(ptr)) {
80006444:	0001                	nop

80006446 <.L89>:
80006446:	4532                	lw	a0,12(sp)
80006448:	f54fd0ef          	jal	80003b9c <sysctl_cpu_clock_any_is_busy>
8000644c:	87aa                	mv	a5,a0
8000644e:	ffe5                	bnez	a5,80006446 <.L89>

80006450 <.L88>:
        }
    }
    ptr->CLOCK_CPU[0] = SYSCTL_CLOCK_CPU_MUX_SET(source) | SYSCTL_CLOCK_CPU_DIV_SET(cpu_div - 1) | SYSCTL_CLOCK_CPU_SUB0_DIV_SET(ahb_sub_div - 1);
80006450:	00b14783          	lbu	a5,11(sp)
80006454:	07a2                	slli	a5,a5,0x8
80006456:	7007f713          	andi	a4,a5,1792
8000645a:	4792                	lw	a5,4(sp)
8000645c:	17fd                	addi	a5,a5,-1
8000645e:	0ff7f793          	zext.b	a5,a5
80006462:	8f5d                	or	a4,a4,a5
80006464:	4782                	lw	a5,0(sp)
80006466:	17fd                	addi	a5,a5,-1
80006468:	01079693          	slli	a3,a5,0x10
8000646c:	000f07b7          	lui	a5,0xf0
80006470:	8ff5                	and	a5,a5,a3
80006472:	8f5d                	or	a4,a4,a5
80006474:	46b2                	lw	a3,12(sp)
80006476:	6789                	lui	a5,0x2
80006478:	97b6                	add	a5,a5,a3
8000647a:	80e7a023          	sw	a4,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>

    while (sysctl_cpu_clock_any_is_busy(ptr)) {
8000647e:	0001                	nop

80006480 <.L90>:
80006480:	4532                	lw	a0,12(sp)
80006482:	f1afd0ef          	jal	80003b9c <sysctl_cpu_clock_any_is_busy>
80006486:	87aa                	mv	a5,a0
80006488:	ffe5                	bnez	a5,80006480 <.L90>
    }

    clock_update_core_clock();
8000648a:	2e09                	jal	8000679c <clock_update_core_clock>

    return status_success;
8000648c:	4781                	li	a5,0

8000648e <.L87>:
}
8000648e:	853e                	mv	a0,a5
80006490:	50b2                	lw	ra,44(sp)
80006492:	6145                	addi	sp,sp,48
80006494:	8082                	ret

Disassembly of section .text.clock_get_frequency:

80006496 <clock_get_frequency>:
{
80006496:	7179                	addi	sp,sp,-48
80006498:	d606                	sw	ra,44(sp)
8000649a:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
8000649c:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
8000649e:	47b2                	lw	a5,12(sp)
800064a0:	83a1                	srli	a5,a5,0x8
800064a2:	0ff7f793          	zext.b	a5,a5
800064a6:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
800064a8:	47b2                	lw	a5,12(sp)
800064aa:	0ff7f793          	zext.b	a5,a5
800064ae:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
800064b0:	4762                	lw	a4,24(sp)
800064b2:	47ad                	li	a5,11
800064b4:	06e7e963          	bltu	a5,a4,80006526 <.L16>
800064b8:	47e2                	lw	a5,24(sp)
800064ba:	00279713          	slli	a4,a5,0x2
800064be:	8c018793          	addi	a5,gp,-1856 # 80003150 <.L18>
800064c2:	97ba                	add	a5,a5,a4
800064c4:	439c                	lw	a5,0(a5)
800064c6:	8782                	jr	a5

800064c8 <.L26>:
        clk_freq = get_frequency_for_ip_in_common_group((clock_node_t) node_or_instance);
800064c8:	47d2                	lw	a5,20(sp)
800064ca:	0ff7f793          	zext.b	a5,a5
800064ce:	853e                	mv	a0,a5
800064d0:	8cdfd0ef          	jal	80003d9c <get_frequency_for_ip_in_common_group>
800064d4:	ce2a                	sw	a0,28(sp)
        break;
800064d6:	a891                	j	8000652a <.L27>

800064d8 <.L25>:
        clk_freq = get_frequency_for_adc(CLK_SRC_GROUP_ADC, node_or_instance);
800064d8:	45d2                	lw	a1,20(sp)
800064da:	4505                	li	a0,1
800064dc:	92dfd0ef          	jal	80003e08 <get_frequency_for_adc>
800064e0:	ce2a                	sw	a0,28(sp)
        break;
800064e2:	a0a1                	j	8000652a <.L27>

800064e4 <.L21>:
        clk_freq = get_frequency_for_dac(node_or_instance);
800064e4:	4552                	lw	a0,20(sp)
800064e6:	20b9                	jal	80006534 <.LFE116>
800064e8:	ce2a                	sw	a0,28(sp)
        break;
800064ea:	a081                	j	8000652a <.L27>

800064ec <.L24>:
        clk_freq = get_frequency_for_ewdg(node_or_instance);
800064ec:	4552                	lw	a0,20(sp)
800064ee:	9b3fd0ef          	jal	80003ea0 <get_frequency_for_ewdg>
800064f2:	ce2a                	sw	a0,28(sp)
        break;
800064f4:	a81d                	j	8000652a <.L27>

800064f6 <.L17>:
        clk_freq = get_frequency_for_pewdg();
800064f6:	20f1                	jal	800065c2 <get_frequency_for_pewdg>
800064f8:	ce2a                	sw	a0,28(sp)
        break;
800064fa:	a805                	j	8000652a <.L27>

800064fc <.L23>:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
800064fc:	016e37b7          	lui	a5,0x16e3
80006500:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80006504:	ce3e                	sw	a5,28(sp)
        break;
80006506:	a015                	j	8000652a <.L27>

80006508 <.L20>:
        clk_freq = get_frequency_for_cpu();
80006508:	9cbfd0ef          	jal	80003ed2 <get_frequency_for_cpu>
8000650c:	ce2a                	sw	a0,28(sp)
        break;
8000650e:	a831                	j	8000652a <.L27>

80006510 <.L22>:
        clk_freq = get_frequency_for_ahb();
80006510:	28e9                	jal	800065ea <get_frequency_for_ahb>
80006512:	ce2a                	sw	a0,28(sp)
        break;
80006514:	a819                	j	8000652a <.L27>

80006516 <.L19>:
        clk_freq = get_frequency_for_source((clock_source_t) node_or_instance);
80006516:	47d2                	lw	a5,20(sp)
80006518:	0ff7f793          	zext.b	a5,a5
8000651c:	853e                	mv	a0,a5
8000651e:	fd0fd0ef          	jal	80003cee <get_frequency_for_source>
80006522:	ce2a                	sw	a0,28(sp)
        break;
80006524:	a019                	j	8000652a <.L27>

80006526 <.L16>:
        clk_freq = 0UL;
80006526:	ce02                	sw	zero,28(sp)
        break;
80006528:	0001                	nop

8000652a <.L27>:
    return clk_freq;
8000652a:	47f2                	lw	a5,28(sp)
}
8000652c:	853e                	mv	a0,a5
8000652e:	50b2                	lw	ra,44(sp)
80006530:	6145                	addi	sp,sp,48
80006532:	8082                	ret

Disassembly of section .text.get_frequency_for_dac:

80006534 <get_frequency_for_dac>:
{
80006534:	7179                	addi	sp,sp,-48
80006536:	d606                	sw	ra,44(sp)
80006538:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
8000653a:	ce02                	sw	zero,28(sp)
    bool is_mux_valid = false;
8000653c:	00010da3          	sb	zero,27(sp)
    clock_node_t node = clock_node_end;
80006540:	02800793          	li	a5,40
80006544:	00f10d23          	sb	a5,26(sp)
    if (instance < DAC_INSTANCE_NUM) {
80006548:	4732                	lw	a4,12(sp)
8000654a:	4785                	li	a5,1
8000654c:	02e7ec63          	bltu	a5,a4,80006584 <.L51>

80006550 <.LBB8>:
        uint32_t mux_in_reg = SYSCTL_DACCLK_MUX_GET(HPM_SYSCTL->DACCLK[instance]);
80006550:	f4000737          	lui	a4,0xf4000
80006554:	47b2                	lw	a5,12(sp)
80006556:	70078793          	addi	a5,a5,1792
8000655a:	078a                	slli	a5,a5,0x2
8000655c:	97ba                	add	a5,a5,a4
8000655e:	479c                	lw	a5,8(a5)
80006560:	83a1                	srli	a5,a5,0x8
80006562:	8b85                	andi	a5,a5,1
80006564:	ca3e                	sw	a5,20(sp)
        if (mux_in_reg < ARRAY_SIZE(s_dac_clk_mux_node)) {
80006566:	4752                	lw	a4,20(sp)
80006568:	4785                	li	a5,1
8000656a:	00e7ed63          	bltu	a5,a4,80006584 <.L51>
            node = s_dac_clk_mux_node[mux_in_reg];
8000656e:	0a018713          	addi	a4,gp,160 # 80003930 <s_dac_clk_mux_node>
80006572:	47d2                	lw	a5,20(sp)
80006574:	97ba                	add	a5,a5,a4
80006576:	0007c783          	lbu	a5,0(a5)
8000657a:	00f10d23          	sb	a5,26(sp)
            is_mux_valid = true;
8000657e:	4785                	li	a5,1
80006580:	00f10da3          	sb	a5,27(sp)

80006584 <.L51>:
    if (is_mux_valid) {
80006584:	01b14783          	lbu	a5,27(sp)
80006588:	cb85                	beqz	a5,800065b8 <.L52>
        if (node == clock_node_ahb) {
8000658a:	01a14703          	lbu	a4,26(sp)
8000658e:	0fe00793          	li	a5,254
80006592:	00f71563          	bne	a4,a5,8000659c <.L53>
            clk_freq = get_frequency_for_ahb();
80006596:	2891                	jal	800065ea <get_frequency_for_ahb>
80006598:	ce2a                	sw	a0,28(sp)
8000659a:	a839                	j	800065b8 <.L52>

8000659c <.L53>:
            node += instance;
8000659c:	47b2                	lw	a5,12(sp)
8000659e:	0ff7f793          	zext.b	a5,a5
800065a2:	01a14703          	lbu	a4,26(sp)
800065a6:	97ba                	add	a5,a5,a4
800065a8:	00f10d23          	sb	a5,26(sp)
            clk_freq = get_frequency_for_ip_in_common_group(node);
800065ac:	01a14783          	lbu	a5,26(sp)
800065b0:	853e                	mv	a0,a5
800065b2:	feafd0ef          	jal	80003d9c <get_frequency_for_ip_in_common_group>
800065b6:	ce2a                	sw	a0,28(sp)

800065b8 <.L52>:
    return clk_freq;
800065b8:	47f2                	lw	a5,28(sp)
}
800065ba:	853e                	mv	a0,a5
800065bc:	50b2                	lw	ra,44(sp)
800065be:	6145                	addi	sp,sp,48
800065c0:	8082                	ret

Disassembly of section .text.get_frequency_for_pewdg:

800065c2 <get_frequency_for_pewdg>:
{
800065c2:	1141                	addi	sp,sp,-16
    if (EWDG_CTRL0_CLK_SEL_GET(HPM_PEWDG->CTRL0) == 0) {
800065c4:	f41287b7          	lui	a5,0xf4128
800065c8:	4398                	lw	a4,0(a5)
800065ca:	200007b7          	lui	a5,0x20000
800065ce:	8ff9                	and	a5,a5,a4
800065d0:	e799                	bnez	a5,800065de <.L60>
        freq_in_hz = FREQ_PRESET1_OSC0_CLK0;
800065d2:	016e37b7          	lui	a5,0x16e3
800065d6:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
800065da:	c63e                	sw	a5,12(sp)
800065dc:	a019                	j	800065e2 <.L61>

800065de <.L60>:
        freq_in_hz = FREQ_32KHz;
800065de:	67a1                	lui	a5,0x8
800065e0:	c63e                	sw	a5,12(sp)

800065e2 <.L61>:
    return freq_in_hz;
800065e2:	47b2                	lw	a5,12(sp)
}
800065e4:	853e                	mv	a0,a5
800065e6:	0141                	addi	sp,sp,16
800065e8:	8082                	ret

Disassembly of section .text.get_frequency_for_ahb:

800065ea <get_frequency_for_ahb>:
{
800065ea:	1101                	addi	sp,sp,-32
800065ec:	ce06                	sw	ra,28(sp)
    uint32_t div = SYSCTL_CLOCK_CPU_SUB0_DIV_GET(HPM_SYSCTL->CLOCK_CPU[0]) + 1U;
800065ee:	f4000737          	lui	a4,0xf4000
800065f2:	6789                	lui	a5,0x2
800065f4:	97ba                	add	a5,a5,a4
800065f6:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
800065fa:	83c1                	srli	a5,a5,0x10
800065fc:	8bbd                	andi	a5,a5,15
800065fe:	0785                	addi	a5,a5,1
80006600:	c63e                	sw	a5,12(sp)
    return (get_frequency_for_cpu() / div);
80006602:	8d1fd0ef          	jal	80003ed2 <get_frequency_for_cpu>
80006606:	872a                	mv	a4,a0
80006608:	47b2                	lw	a5,12(sp)
8000660a:	02f757b3          	divu	a5,a4,a5
}
8000660e:	853e                	mv	a0,a5
80006610:	40f2                	lw	ra,28(sp)
80006612:	6105                	addi	sp,sp,32
80006614:	8082                	ret

Disassembly of section .text.clock_set_source_divider:

80006616 <clock_set_source_divider>:
{
80006616:	7139                	addi	sp,sp,-64
80006618:	de06                	sw	ra,60(sp)
8000661a:	c62a                	sw	a0,12(sp)
8000661c:	87ae                	mv	a5,a1
8000661e:	c232                	sw	a2,4(sp)
80006620:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status = status_success;
80006624:	d602                	sw	zero,44(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
80006626:	47b2                	lw	a5,12(sp)
80006628:	83a1                	srli	a5,a5,0x8
8000662a:	0ff7f793          	zext.b	a5,a5
8000662e:	d43e                	sw	a5,40(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
80006630:	47b2                	lw	a5,12(sp)
80006632:	0ff7f793          	zext.b	a5,a5
80006636:	d23e                	sw	a5,36(sp)
    switch (clk_src_type) {
80006638:	5722                	lw	a4,40(sp)
8000663a:	47ad                	li	a5,11
8000663c:	0ce7e263          	bltu	a5,a4,80006700 <.L132>
80006640:	57a2                	lw	a5,40(sp)
80006642:	00279713          	slli	a4,a5,0x2
80006646:	91018793          	addi	a5,gp,-1776 # 800031a0 <.L134>
8000664a:	97ba                	add	a5,a5,a4
8000664c:	439c                	lw	a5,0(a5)
8000664e:	8782                	jr	a5

80006650 <.L138>:
        if ((div < 1U) || (div > 256U)) {
80006650:	4792                	lw	a5,4(sp)
80006652:	c791                	beqz	a5,8000665e <.L139>
80006654:	4712                	lw	a4,4(sp)
80006656:	10000793          	li	a5,256
8000665a:	00e7f763          	bgeu	a5,a4,80006668 <.L140>

8000665e <.L139>:
            status = status_clk_div_invalid;
8000665e:	6795                	lui	a5,0x5
80006660:	5f078793          	addi	a5,a5,1520 # 55f0 <__HEAPSIZE__+0x15f0>
80006664:	d63e                	sw	a5,44(sp)
        break;
80006666:	a055                	j	8000670a <.L142>

80006668 <.L140>:
            clock_source_t clk_src = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
80006668:	00b14783          	lbu	a5,11(sp)
8000666c:	8bbd                	andi	a5,a5,15
8000666e:	00f10da3          	sb	a5,27(sp)
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, clk_src, div);
80006672:	5792                	lw	a5,36(sp)
80006674:	0ff7f793          	zext.b	a5,a5
80006678:	01b14703          	lbu	a4,27(sp)
8000667c:	4692                	lw	a3,4(sp)
8000667e:	863a                	mv	a2,a4
80006680:	85be                	mv	a1,a5
80006682:	f4000537          	lui	a0,0xf4000
80006686:	d66fd0ef          	jal	80003bec <sysctl_config_clock>

8000668a <.LBE13>:
        break;
8000668a:	a041                	j	8000670a <.L142>

8000668c <.L133>:
        status = status_clk_operation_unsupported;
8000668c:	6795                	lui	a5,0x5
8000668e:	5f378793          	addi	a5,a5,1523 # 55f3 <__HEAPSIZE__+0x15f3>
80006692:	d63e                	sw	a5,44(sp)
        break;
80006694:	a89d                	j	8000670a <.L142>

80006696 <.L137>:
        status = status_clk_fixed;
80006696:	6795                	lui	a5,0x5
80006698:	5fa78793          	addi	a5,a5,1530 # 55fa <__HEAPSIZE__+0x15fa>
8000669c:	d63e                	sw	a5,44(sp)
        break;
8000669e:	a0b5                	j	8000670a <.L142>

800066a0 <.L136>:
        status = status_clk_shared_cpu0;
800066a0:	6795                	lui	a5,0x5
800066a2:	5f878793          	addi	a5,a5,1528 # 55f8 <__HEAPSIZE__+0x15f8>
800066a6:	d63e                	sw	a5,44(sp)
        break;
800066a8:	a08d                	j	8000670a <.L142>

800066aa <.L135>:
        if (node_or_instance == clock_node_cpu0) {
800066aa:	5712                	lw	a4,36(sp)
800066ac:	0fc00793          	li	a5,252
800066b0:	04f71363          	bne	a4,a5,800066f6 <.L143>

800066b4 <.LBB14>:
            uint32_t expected_freq = get_frequency_for_source((clock_source_t) src) / div;
800066b4:	00b14783          	lbu	a5,11(sp)
800066b8:	853e                	mv	a0,a5
800066ba:	e34fd0ef          	jal	80003cee <get_frequency_for_source>
800066be:	872a                	mv	a4,a0
800066c0:	4792                	lw	a5,4(sp)
800066c2:	02f757b3          	divu	a5,a4,a5
800066c6:	d03e                	sw	a5,32(sp)
            uint32_t ahb_sub_div = (expected_freq + BUS_FREQ_MAX - 1U) / BUS_FREQ_MAX;
800066c8:	5702                	lw	a4,32(sp)
800066ca:	0bebc7b7          	lui	a5,0xbebc
800066ce:	1ff78793          	addi	a5,a5,511 # bebc1ff <_flash_size+0xbdbc1ff>
800066d2:	973e                	add	a4,a4,a5
800066d4:	55e647b7          	lui	a5,0x55e64
800066d8:	b8978793          	addi	a5,a5,-1143 # 55e63b89 <_flash_size+0x55d63b89>
800066dc:	02f737b3          	mulhu	a5,a4,a5
800066e0:	83e9                	srli	a5,a5,0x1a
800066e2:	ce3e                	sw	a5,28(sp)
            sysctl_config_cpu0_domain_clock(HPM_SYSCTL, (clock_source_t) src, div, ahb_sub_div);
800066e4:	00b14783          	lbu	a5,11(sp)
800066e8:	46f2                	lw	a3,28(sp)
800066ea:	4612                	lw	a2,4(sp)
800066ec:	85be                	mv	a1,a5
800066ee:	f4000537          	lui	a0,0xf4000
800066f2:	31fd                	jal	800063e0 <sysctl_config_cpu0_domain_clock>

800066f4 <.LBE14>:
        break;
800066f4:	a819                	j	8000670a <.L142>

800066f6 <.L143>:
            status = status_clk_shared_cpu0;
800066f6:	6795                	lui	a5,0x5
800066f8:	5f878793          	addi	a5,a5,1528 # 55f8 <__HEAPSIZE__+0x15f8>
800066fc:	d63e                	sw	a5,44(sp)
        break;
800066fe:	a031                	j	8000670a <.L142>

80006700 <.L132>:
        status = status_clk_src_invalid;
80006700:	6795                	lui	a5,0x5
80006702:	5f178793          	addi	a5,a5,1521 # 55f1 <__HEAPSIZE__+0x15f1>
80006706:	d63e                	sw	a5,44(sp)
        break;
80006708:	0001                	nop

8000670a <.L142>:
    return status;
8000670a:	57b2                	lw	a5,44(sp)
}
8000670c:	853e                	mv	a0,a5
8000670e:	50f2                	lw	ra,60(sp)
80006710:	6121                	addi	sp,sp,64
80006712:	8082                	ret

Disassembly of section .text.clock_check_in_group:

80006714 <clock_check_in_group>:
{
80006714:	7179                	addi	sp,sp,-48
80006716:	d606                	sw	ra,44(sp)
80006718:	c62a                	sw	a0,12(sp)
8000671a:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
8000671c:	47b2                	lw	a5,12(sp)
8000671e:	83c1                	srli	a5,a5,0x10
80006720:	ce3e                	sw	a5,28(sp)
    return sysctl_check_group_resource_enable(HPM_SYSCTL, group, resource);
80006722:	47a2                	lw	a5,8(sp)
80006724:	0ff7f793          	zext.b	a5,a5
80006728:	4772                	lw	a4,28(sp)
8000672a:	08074733          	zext.h	a4,a4
8000672e:	863a                	mv	a2,a4
80006730:	85be                	mv	a1,a5
80006732:	f4000537          	lui	a0,0xf4000
80006736:	391d                	jal	8000636c <sysctl_check_group_resource_enable>
80006738:	87aa                	mv	a5,a0
}
8000673a:	853e                	mv	a0,a5
8000673c:	50b2                	lw	ra,44(sp)
8000673e:	6145                	addi	sp,sp,48
80006740:	8082                	ret

Disassembly of section .text.clock_connect_group_to_cpu:

80006742 <clock_connect_group_to_cpu>:
{
80006742:	1141                	addi	sp,sp,-16
80006744:	c62a                	sw	a0,12(sp)
80006746:	c42e                	sw	a1,8(sp)
    if (cpu == 0U) {
80006748:	47a2                	lw	a5,8(sp)
8000674a:	ef89                	bnez	a5,80006764 <.L163>
        HPM_SYSCTL->AFFILIATE[cpu].SET = (1UL << group);
8000674c:	f40006b7          	lui	a3,0xf4000
80006750:	47b2                	lw	a5,12(sp)
80006752:	4705                	li	a4,1
80006754:	00f71733          	sll	a4,a4,a5
80006758:	47a2                	lw	a5,8(sp)
8000675a:	09078793          	addi	a5,a5,144
8000675e:	0792                	slli	a5,a5,0x4
80006760:	97b6                	add	a5,a5,a3
80006762:	c3d8                	sw	a4,4(a5)

80006764 <.L163>:
}
80006764:	0001                	nop
80006766:	0141                	addi	sp,sp,16
80006768:	8082                	ret

Disassembly of section .text.clock_get_core_clock_ticks_per_ms:

8000676a <clock_get_core_clock_ticks_per_ms>:
{
8000676a:	1141                	addi	sp,sp,-16
8000676c:	c606                	sw	ra,12(sp)
    if (hpm_core_clock == 0U) {
8000676e:	000807b7          	lui	a5,0x80
80006772:	3387a783          	lw	a5,824(a5) # 80338 <hpm_core_clock>
80006776:	e391                	bnez	a5,8000677a <.L171>
        clock_update_core_clock();
80006778:	2015                	jal	8000679c <.LFE141>

8000677a <.L171>:
    return (hpm_core_clock + FREQ_1KHz - 1U) / FREQ_1KHz;
8000677a:	000807b7          	lui	a5,0x80
8000677e:	3387a783          	lw	a5,824(a5) # 80338 <hpm_core_clock>
80006782:	3e778713          	addi	a4,a5,999
80006786:	106257b7          	lui	a5,0x10625
8000678a:	dd378793          	addi	a5,a5,-557 # 10624dd3 <_flash_size+0x10524dd3>
8000678e:	02f737b3          	mulhu	a5,a4,a5
80006792:	8399                	srli	a5,a5,0x6
}
80006794:	853e                	mv	a0,a5
80006796:	40b2                	lw	ra,12(sp)
80006798:	0141                	addi	sp,sp,16
8000679a:	8082                	ret

Disassembly of section .text.clock_update_core_clock:

8000679c <clock_update_core_clock>:

void clock_update_core_clock(void)
{
8000679c:	1141                	addi	sp,sp,-16
8000679e:	c606                	sw	ra,12(sp)
    hpm_core_clock = clock_get_frequency(clock_cpu0);
800067a0:	6785                	lui	a5,0x1
800067a2:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x5ce>
800067a6:	39c5                	jal	80006496 <clock_get_frequency>
800067a8:	872a                	mv	a4,a0
800067aa:	000807b7          	lui	a5,0x80
800067ae:	32e7ac23          	sw	a4,824(a5) # 80338 <hpm_core_clock>
}
800067b2:	0001                	nop
800067b4:	40b2                	lw	ra,12(sp)
800067b6:	0141                	addi	sp,sp,16
800067b8:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate_all:

800067ba <l1c_dc_invalidate_all>:
{
800067ba:	1141                	addi	sp,sp,-16
800067bc:	47dd                	li	a5,23
800067be:	00f107a3          	sb	a5,15(sp)

800067c2 <.LBB68>:
}

/* send command */
ATTR_ALWAYS_INLINE static inline void l1c_cctl_cmd(uint8_t cmd)
{
    write_csr(CSR_MCCTLCOMMAND, cmd);
800067c2:	00f14783          	lbu	a5,15(sp)
800067c6:	7cc79073          	csrw	0x7cc,a5
}
800067ca:	0001                	nop

800067cc <.LBE68>:
}
800067cc:	0001                	nop
800067ce:	0141                	addi	sp,sp,16
800067d0:	8082                	ret

Disassembly of section .text.init_py_pins_as_pgpio:

800067d2 <init_py_pins_as_pgpio>:
    HPM_PIOC->PAD[IOC_PAD_PY00].FUNC_CTL = PIOC_PY00_FUNC_CTL_PGPIO_Y_00;
800067d2:	f4118737          	lui	a4,0xf4118
800067d6:	6785                	lui	a5,0x1
800067d8:	97ba                	add	a5,a5,a4
800067da:	e007a023          	sw	zero,-512(a5) # e00 <__NOR_CFG_OPTION_segment_size__+0x200>
    HPM_PIOC->PAD[IOC_PAD_PY01].FUNC_CTL = PIOC_PY01_FUNC_CTL_PGPIO_Y_01;
800067de:	f4118737          	lui	a4,0xf4118
800067e2:	6785                	lui	a5,0x1
800067e4:	97ba                	add	a5,a5,a4
800067e6:	e007a423          	sw	zero,-504(a5) # e08 <__NOR_CFG_OPTION_segment_size__+0x208>
    HPM_PIOC->PAD[IOC_PAD_PY02].FUNC_CTL = PIOC_PY02_FUNC_CTL_PGPIO_Y_02;
800067ea:	f4118737          	lui	a4,0xf4118
800067ee:	6785                	lui	a5,0x1
800067f0:	97ba                	add	a5,a5,a4
800067f2:	e007a823          	sw	zero,-496(a5) # e10 <__NOR_CFG_OPTION_segment_size__+0x210>
    HPM_PIOC->PAD[IOC_PAD_PY03].FUNC_CTL = PIOC_PY03_FUNC_CTL_PGPIO_Y_03;
800067f6:	f4118737          	lui	a4,0xf4118
800067fa:	6785                	lui	a5,0x1
800067fc:	97ba                	add	a5,a5,a4
800067fe:	e007ac23          	sw	zero,-488(a5) # e18 <__NOR_CFG_OPTION_segment_size__+0x218>
    HPM_PIOC->PAD[IOC_PAD_PY04].FUNC_CTL = PIOC_PY04_FUNC_CTL_PGPIO_Y_04;
80006802:	f4118737          	lui	a4,0xf4118
80006806:	6785                	lui	a5,0x1
80006808:	97ba                	add	a5,a5,a4
8000680a:	e207a023          	sw	zero,-480(a5) # e20 <__NOR_CFG_OPTION_segment_size__+0x220>
    HPM_PIOC->PAD[IOC_PAD_PY05].FUNC_CTL = PIOC_PY05_FUNC_CTL_PGPIO_Y_05;
8000680e:	f4118737          	lui	a4,0xf4118
80006812:	6785                	lui	a5,0x1
80006814:	97ba                	add	a5,a5,a4
80006816:	e207a423          	sw	zero,-472(a5) # e28 <__NOR_CFG_OPTION_segment_size__+0x228>
}
8000681a:	0001                	nop
8000681c:	8082                	ret

Disassembly of section .text.init_uart0_pins:

8000681e <init_uart0_pins>:
    HPM_IOC->PAD[IOC_PAD_PA00].FUNC_CTL = IOC_PA00_FUNC_CTL_UART0_TXD;
8000681e:	f40407b7          	lui	a5,0xf4040
80006822:	4709                	li	a4,2
80006824:	c398                	sw	a4,0(a5)
    HPM_IOC->PAD[IOC_PAD_PA01].FUNC_CTL = IOC_PA01_FUNC_CTL_UART0_RXD;
80006826:	f40407b7          	lui	a5,0xf4040
8000682a:	4709                	li	a4,2
8000682c:	c798                	sw	a4,8(a5)
}
8000682e:	0001                	nop
80006830:	8082                	ret

Disassembly of section .text.init_uart3_pins:

80006832 <init_uart3_pins>:
    HPM_IOC->PAD[IOC_PAD_PA14].FUNC_CTL = IOC_PA14_FUNC_CTL_UART3_RXD;
80006832:	f40407b7          	lui	a5,0xf4040
80006836:	4709                	li	a4,2
80006838:	dbb8                	sw	a4,112(a5)
    HPM_IOC->PAD[IOC_PAD_PA15].FUNC_CTL = IOC_PA15_FUNC_CTL_UART3_TXD;
8000683a:	f40407b7          	lui	a5,0xf4040
8000683e:	4709                	li	a4,2
80006840:	dfb8                	sw	a4,120(a5)
}
80006842:	0001                	nop
80006844:	8082                	ret

Disassembly of section .text.sysctl_resource_any_is_busy:

80006846 <sysctl_resource_any_is_busy>:
{
80006846:	1141                	addi	sp,sp,-16
80006848:	c62a                	sw	a0,12(sp)
    return ptr->RESOURCE[0] & SYSCTL_RESOURCE_GLB_BUSY_MASK;
8000684a:	47b2                	lw	a5,12(sp)
8000684c:	4398                	lw	a4,0(a5)
8000684e:	800007b7          	lui	a5,0x80000
80006852:	8ff9                	and	a5,a5,a4
80006854:	00f037b3          	snez	a5,a5
80006858:	0ff7f793          	zext.b	a5,a5
}
8000685c:	853e                	mv	a0,a5
8000685e:	0141                	addi	sp,sp,16
80006860:	8082                	ret

Disassembly of section .text.gptmr_check_status:

80006862 <gptmr_check_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline bool gptmr_check_status(GPTMR_Type *ptr, uint32_t mask)
{
80006862:	1141                	addi	sp,sp,-16
80006864:	c62a                	sw	a0,12(sp)
80006866:	c42e                	sw	a1,8(sp)
    return (ptr->SR & mask) == mask;
80006868:	47b2                	lw	a5,12(sp)
8000686a:	2007a703          	lw	a4,512(a5) # 80000200 <_flash_size+0x7ff00200>
8000686e:	47a2                	lw	a5,8(sp)
80006870:	8ff9                	and	a5,a5,a4
80006872:	4722                	lw	a4,8(sp)
80006874:	40f707b3          	sub	a5,a4,a5
80006878:	0017b793          	seqz	a5,a5
8000687c:	0ff7f793          	zext.b	a5,a5
}
80006880:	853e                	mv	a0,a5
80006882:	0141                	addi	sp,sp,16
80006884:	8082                	ret

Disassembly of section .text.gptmr_clear_status:

80006886 <gptmr_clear_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline void gptmr_clear_status(GPTMR_Type *ptr, uint32_t mask)
{
80006886:	1141                	addi	sp,sp,-16
80006888:	c62a                	sw	a0,12(sp)
8000688a:	c42e                	sw	a1,8(sp)
    ptr->SR = mask;
8000688c:	47b2                	lw	a5,12(sp)
8000688e:	4722                	lw	a4,8(sp)
80006890:	20e7a023          	sw	a4,512(a5)
}
80006894:	0001                	nop
80006896:	0141                	addi	sp,sp,16
80006898:	8082                	ret

Disassembly of section .text.gpio_set_pin_input:

8000689a <gpio_set_pin_input>:
{
8000689a:	1141                	addi	sp,sp,-16
8000689c:	c62a                	sw	a0,12(sp)
8000689e:	c42e                	sw	a1,8(sp)
800068a0:	87b2                	mv	a5,a2
800068a2:	00f103a3          	sb	a5,7(sp)
    ptr->OE[port].CLEAR = 1 << pin;
800068a6:	00714783          	lbu	a5,7(sp)
800068aa:	4705                	li	a4,1
800068ac:	00f717b3          	sll	a5,a4,a5
800068b0:	86be                	mv	a3,a5
800068b2:	4732                	lw	a4,12(sp)
800068b4:	47a2                	lw	a5,8(sp)
800068b6:	02078793          	addi	a5,a5,32
800068ba:	0792                	slli	a5,a5,0x4
800068bc:	97ba                	add	a5,a5,a4
800068be:	c794                	sw	a3,8(a5)
}
800068c0:	0001                	nop
800068c2:	0141                	addi	sp,sp,16
800068c4:	8082                	ret

Disassembly of section .text.usb_phy_disable_dp_dm_pulldown:

800068c6 <usb_phy_disable_dp_dm_pulldown>:
 * @brief USB phy disconnect dp/dm pins pulldown resistance
 *
 * @param[in] ptr A USB peripheral base address
 */
static inline void usb_phy_disable_dp_dm_pulldown(USB_Type *ptr)
{
800068c6:	1141                	addi	sp,sp,-16
800068c8:	c62a                	sw	a0,12(sp)
    ptr->PHY_CTRL0 |= 0x001000E0u;
800068ca:	47b2                	lw	a5,12(sp)
800068cc:	2107a703          	lw	a4,528(a5)
800068d0:	001007b7          	lui	a5,0x100
800068d4:	0e078793          	addi	a5,a5,224 # 1000e0 <_flash_size+0xe0>
800068d8:	8f5d                	or	a4,a4,a5
800068da:	47b2                	lw	a5,12(sp)
800068dc:	20e7a823          	sw	a4,528(a5)
}
800068e0:	0001                	nop
800068e2:	0141                	addi	sp,sp,16
800068e4:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_is_enabled:

800068e6 <pllctlv2_xtal_is_enabled>:
{
800068e6:	1141                	addi	sp,sp,-16
800068e8:	c62a                	sw	a0,12(sp)
    return IS_HPM_BITMASK_SET(ptr->XTAL, PLLCTLV2_XTAL_ENABLE_MASK);
800068ea:	47b2                	lw	a5,12(sp)
800068ec:	4398                	lw	a4,0(a5)
800068ee:	100007b7          	lui	a5,0x10000
800068f2:	8ff9                	and	a5,a5,a4
800068f4:	00f037b3          	snez	a5,a5
800068f8:	0ff7f793          	zext.b	a5,a5
}
800068fc:	853e                	mv	a0,a5
800068fe:	0141                	addi	sp,sp,16
80006900:	8082                	ret

Disassembly of section .text.board_init_console:

80006902 <board_init_console>:
{
80006902:	1101                	addi	sp,sp,-32
80006904:	ce06                	sw	ra,28(sp)
    init_uart_pins((UART_Type *) BOARD_CONSOLE_UART_BASE);
80006906:	f0040537          	lui	a0,0xf0040
8000690a:	2a4d                	jal	80006abc <init_uart_pins>
    clock_add_to_group(BOARD_CONSOLE_UART_CLK_NAME, 0);
8000690c:	4581                	li	a1,0
8000690e:	011907b7          	lui	a5,0x1190
80006912:	01578513          	addi	a0,a5,21 # 1190015 <_flash_size+0x1090015>
80006916:	e00fd0ef          	jal	80003f16 <clock_add_to_group>
    cfg.type = BOARD_CONSOLE_TYPE;
8000691a:	c002                	sw	zero,0(sp)
    cfg.base = (uint32_t)BOARD_CONSOLE_UART_BASE;
8000691c:	f00407b7          	lui	a5,0xf0040
80006920:	c23e                	sw	a5,4(sp)
    cfg.src_freq_in_hz = clock_get_frequency(BOARD_CONSOLE_UART_CLK_NAME);
80006922:	011907b7          	lui	a5,0x1190
80006926:	01578513          	addi	a0,a5,21 # 1190015 <_flash_size+0x1090015>
8000692a:	36b5                	jal	80006496 <clock_get_frequency>
8000692c:	87aa                	mv	a5,a0
8000692e:	c43e                	sw	a5,8(sp)
    cfg.baudrate = BOARD_CONSOLE_UART_BAUDRATE;
80006930:	67f1                	lui	a5,0x1c
80006932:	20078793          	addi	a5,a5,512 # 1c200 <__AHB_SRAM_segment_size__+0x14200>
80006936:	c63e                	sw	a5,12(sp)
    if (status_success != console_init(&cfg)) {
80006938:	878a                	mv	a5,sp
8000693a:	853e                	mv	a0,a5
8000693c:	2595                	jal	80006fa0 <console_init>
8000693e:	87aa                	mv	a5,a0
80006940:	c391                	beqz	a5,80006944 <.L45>

80006942 <.L44>:
        while (1) {
80006942:	a001                	j	80006942 <.L44>

80006944 <.L45>:
}
80006944:	0001                	nop
80006946:	40f2                	lw	ra,28(sp)
80006948:	6105                	addi	sp,sp,32
8000694a:	8082                	ret

Disassembly of section .text.board_init:

8000694c <board_init>:
{
8000694c:	1141                	addi	sp,sp,-16
8000694e:	c606                	sw	ra,12(sp)
    init_py_pins_as_pgpio();
80006950:	3549                	jal	800067d2 <init_py_pins_as_pgpio>
    board_init_usb_dp_dm_pins();
80006952:	94ffd0ef          	jal	800042a0 <board_init_usb_dp_dm_pins>
    board_init_clock();
80006956:	2819                	jal	8000696c <.LFE358>
    board_init_console();
80006958:	376d                	jal	80006902 <board_init_console>
    board_init_pmp();
8000695a:	2ab9                	jal	80006ab8 <board_init_pmp>
    board_print_clock_freq();
8000695c:	8bbfd0ef          	jal	80004216 <board_print_clock_freq>
    board_print_banner();
80006960:	875fd0ef          	jal	800041d4 <board_print_banner>
}
80006964:	0001                	nop
80006966:	40b2                	lw	ra,12(sp)
80006968:	0141                	addi	sp,sp,16
8000696a:	8082                	ret

Disassembly of section .text.board_init_clock:

8000696c <board_init_clock>:
{
8000696c:	1101                	addi	sp,sp,-32
8000696e:	ce06                	sw	ra,28(sp)
    uint32_t cpu0_freq = clock_get_frequency(clock_cpu0);
80006970:	6785                	lui	a5,0x1
80006972:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x5ce>
80006976:	3605                	jal	80006496 <clock_get_frequency>
80006978:	c62a                	sw	a0,12(sp)
    if (cpu0_freq == PLLCTL_SOC_PLL_REFCLK_FREQ) {
8000697a:	4732                	lw	a4,12(sp)
8000697c:	016e37b7          	lui	a5,0x16e3
80006980:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80006984:	00f71f63          	bne	a4,a5,800069a2 <.L57>
        pllctlv2_xtal_set_rampup_time(HPM_PLLCTLV2, 32UL * 1000UL * 9U);
80006988:	000467b7          	lui	a5,0x46
8000698c:	50078593          	addi	a1,a5,1280 # 46500 <__ILM_segment_end__+0x26500>
80006990:	f40c0537          	lui	a0,0xf40c0
80006994:	81bfd0ef          	jal	800041ae <pllctlv2_xtal_set_rampup_time>
        sysctl_clock_set_preset(HPM_SYSCTL, 2);
80006998:	4589                	li	a1,2
8000699a:	f4000537          	lui	a0,0xf4000
8000699e:	fb0fd0ef          	jal	8000414e <sysctl_clock_set_preset>

800069a2 <.L57>:
    clock_add_to_group(clock_cpu0, 0);
800069a2:	4581                	li	a1,0
800069a4:	6785                	lui	a5,0x1
800069a6:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x5ce>
800069aa:	d6cfd0ef          	jal	80003f16 <clock_add_to_group>
    clock_add_to_group(clock_ahb, 0);
800069ae:	4581                	li	a1,0
800069b0:	fffd07b7          	lui	a5,0xfffd0
800069b4:	5fe78513          	addi	a0,a5,1534 # fffd05fe <__AHB_SRAM_segment_end__+0xfbc85fe>
800069b8:	d5efd0ef          	jal	80003f16 <clock_add_to_group>
    clock_add_to_group(clock_lmm0, 0);
800069bc:	4581                	li	a1,0
800069be:	010117b7          	lui	a5,0x1011
800069c2:	90078513          	addi	a0,a5,-1792 # 1010900 <_flash_size+0xf10900>
800069c6:	d50fd0ef          	jal	80003f16 <clock_add_to_group>
    clock_add_to_group(clock_mchtmr0, 0);
800069ca:	4581                	li	a1,0
800069cc:	01020537          	lui	a0,0x1020
800069d0:	d46fd0ef          	jal	80003f16 <clock_add_to_group>
    clock_add_to_group(clock_rom, 0);
800069d4:	4581                	li	a1,0
800069d6:	010307b7          	lui	a5,0x1030
800069da:	50b78513          	addi	a0,a5,1291 # 103050b <_flash_size+0xf3050b>
800069de:	d38fd0ef          	jal	80003f16 <clock_add_to_group>
    clock_add_to_group(clock_mot0, 0);
800069e2:	4581                	li	a1,0
800069e4:	012d07b7          	lui	a5,0x12d0
800069e8:	50578513          	addi	a0,a5,1285 # 12d0505 <_flash_size+0x11d0505>
800069ec:	d2afd0ef          	jal	80003f16 <clock_add_to_group>
    clock_add_to_group(clock_gpio, 0);
800069f0:	4581                	li	a1,0
800069f2:	013107b7          	lui	a5,0x1310
800069f6:	50978513          	addi	a0,a5,1289 # 1310509 <_flash_size+0x1210509>
800069fa:	d1cfd0ef          	jal	80003f16 <clock_add_to_group>
    clock_add_to_group(clock_hdma, 0);
800069fe:	4581                	li	a1,0
80006a00:	013207b7          	lui	a5,0x1320
80006a04:	50a78513          	addi	a0,a5,1290 # 132050a <_flash_size+0x122050a>
80006a08:	d0efd0ef          	jal	80003f16 <clock_add_to_group>
    clock_add_to_group(clock_xpi0, 0);
80006a0c:	4581                	li	a1,0
80006a0e:	013307b7          	lui	a5,0x1330
80006a12:	01d78513          	addi	a0,a5,29 # 133001d <_flash_size+0x123001d>
80006a16:	d00fd0ef          	jal	80003f16 <clock_add_to_group>
    clock_add_to_group(clock_ptpc, 0);
80006a1a:	4581                	li	a1,0
80006a1c:	010807b7          	lui	a5,0x1080
80006a20:	50e78513          	addi	a0,a5,1294 # 108050e <_flash_size+0xf8050e>
80006a24:	cf2fd0ef          	jal	80003f16 <clock_add_to_group>
    clock_connect_group_to_cpu(0, 0);
80006a28:	4581                	li	a1,0
80006a2a:	4501                	li	a0,0
80006a2c:	3b19                	jal	80006742 <clock_connect_group_to_cpu>
    pcfg_dcdc_set_voltage(HPM_PCFG, 1275);
80006a2e:	4fb00593          	li	a1,1275
80006a32:	f4104537          	lui	a0,0xf4104
80006a36:	230d                	jal	80006f58 <pcfg_dcdc_set_voltage>
    sysctl_config_cpu0_domain_clock(HPM_SYSCTL, clock_source_pll0_clk0, 2, 3);
80006a38:	468d                	li	a3,3
80006a3a:	4609                	li	a2,2
80006a3c:	4585                	li	a1,1
80006a3e:	f4000537          	lui	a0,0xf4000
80006a42:	3a79                	jal	800063e0 <sysctl_config_cpu0_domain_clock>
    pllctlv2_set_postdiv(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk0, pllctlv2_div_1p0);    /* PLL0CLK0: 960MHz */
80006a44:	4681                	li	a3,0
80006a46:	4601                	li	a2,0
80006a48:	4581                	li	a1,0
80006a4a:	f40c0537          	lui	a0,0xf40c0
80006a4e:	2c79                	jal	80006cec <pllctlv2_set_postdiv>
    pllctlv2_set_postdiv(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk1, pllctlv2_div_1p6);    /* PLL0CLK1: 600MHz */
80006a50:	468d                	li	a3,3
80006a52:	4605                	li	a2,1
80006a54:	4581                	li	a1,0
80006a56:	f40c0537          	lui	a0,0xf40c0
80006a5a:	2c49                	jal	80006cec <pllctlv2_set_postdiv>
    pllctlv2_set_postdiv(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk2, pllctlv2_div_2p4);    /* PLL0CLK2: 400MHz */
80006a5c:	469d                	li	a3,7
80006a5e:	4609                	li	a2,2
80006a60:	4581                	li	a1,0
80006a62:	f40c0537          	lui	a0,0xf40c0
80006a66:	2459                	jal	80006cec <pllctlv2_set_postdiv>
    pllctlv2_init_pll_with_freq(HPM_PLLCTLV2, pllctlv2_pll0, 960000000);
80006a68:	39387637          	lui	a2,0x39387
80006a6c:	4581                	li	a1,0
80006a6e:	f40c0537          	lui	a0,0xf40c0
80006a72:	f7dfd0ef          	jal	800049ee <pllctlv2_init_pll_with_freq>
    clock_update_core_clock();
80006a76:	331d                	jal	8000679c <clock_update_core_clock>
    clock_set_source_divider(clock_mchtmr0, clk_src_osc24m, 1);
80006a78:	4605                	li	a2,1
80006a7a:	4581                	li	a1,0
80006a7c:	01020537          	lui	a0,0x1020
80006a80:	3e59                	jal	80006616 <clock_set_source_divider>
}
80006a82:	0001                	nop
80006a84:	40f2                	lw	ra,28(sp)
80006a86:	6105                	addi	sp,sp,32
80006a88:	8082                	ret

Disassembly of section .text.board_delay_ms:

80006a8a <board_delay_ms>:
{
80006a8a:	1101                	addi	sp,sp,-32
80006a8c:	ce06                	sw	ra,28(sp)
80006a8e:	c62a                	sw	a0,12(sp)
    clock_cpu_delay_ms(ms);
80006a90:	4532                	lw	a0,12(sp)
80006a92:	cf8fd0ef          	jal	80003f8a <clock_cpu_delay_ms>
}
80006a96:	0001                	nop
80006a98:	40f2                	lw	ra,28(sp)
80006a9a:	6105                	addi	sp,sp,32
80006a9c:	8082                	ret

Disassembly of section .text.board_init_gpio_pins:

80006a9e <board_init_gpio_pins>:
{
80006a9e:	1141                	addi	sp,sp,-16
80006aa0:	c606                	sw	ra,12(sp)
    init_gpio_pins();
80006aa2:	e08fd0ef          	jal	800040aa <init_gpio_pins>
    gpio_set_pin_input(BOARD_APP_GPIO_CTRL, BOARD_APP_GPIO_INDEX, BOARD_APP_GPIO_PIN);
80006aa6:	4625                	li	a2,9
80006aa8:	4581                	li	a1,0
80006aaa:	f00d0537          	lui	a0,0xf00d0
80006aae:	33f5                	jal	8000689a <gpio_set_pin_input>
}
80006ab0:	0001                	nop
80006ab2:	40b2                	lw	ra,12(sp)
80006ab4:	0141                	addi	sp,sp,16
80006ab6:	8082                	ret

Disassembly of section .text.board_init_pmp:

80006ab8 <board_init_pmp>:

void board_init_pmp(void)
{
}
80006ab8:	0001                	nop
80006aba:	8082                	ret

Disassembly of section .text.init_uart_pins:

80006abc <init_uart_pins>:
    }
    return freq;
}

void init_uart_pins(UART_Type *ptr)
{
80006abc:	1101                	addi	sp,sp,-32
80006abe:	ce06                	sw	ra,28(sp)
80006ac0:	c62a                	sw	a0,12(sp)
    if (ptr == HPM_UART0) {
80006ac2:	4732                	lw	a4,12(sp)
80006ac4:	f00407b7          	lui	a5,0xf0040
80006ac8:	00f71463          	bne	a4,a5,80006ad0 <.L153>
        init_uart0_pins();
80006acc:	3b89                	jal	8000681e <init_uart0_pins>
        /* using for uart_lin function */
        init_uart3_pins();
    } else {
        ;
    }
}
80006ace:	a839                	j	80006aec <.L156>

80006ad0 <.L153>:
    } else if (ptr == HPM_UART2) {
80006ad0:	4732                	lw	a4,12(sp)
80006ad2:	f00487b7          	lui	a5,0xf0048
80006ad6:	00f71563          	bne	a4,a5,80006ae0 <.L155>
        init_uart2_pins();
80006ada:	daefd0ef          	jal	80004088 <init_uart2_pins>
}
80006ade:	a039                	j	80006aec <.L156>

80006ae0 <.L155>:
    } else if (ptr == HPM_UART3) {
80006ae0:	4732                	lw	a4,12(sp)
80006ae2:	f004c7b7          	lui	a5,0xf004c
80006ae6:	00f71363          	bne	a4,a5,80006aec <.L156>
        init_uart3_pins();
80006aea:	33a1                	jal	80006832 <init_uart3_pins>

80006aec <.L156>:
}
80006aec:	0001                	nop
80006aee:	40f2                	lw	ra,28(sp)
80006af0:	6105                	addi	sp,sp,32
80006af2:	8082                	ret

Disassembly of section .text.uart_modem_config:

80006af4 <uart_modem_config>:
 *
 * @param [in] ptr UART base address
 * @param config Pointer to modem config struct
 */
static inline void uart_modem_config(UART_Type *ptr, uart_modem_config_t *config)
{
80006af4:	1141                	addi	sp,sp,-16
80006af6:	c62a                	sw	a0,12(sp)
80006af8:	c42e                	sw	a1,8(sp)
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
80006afa:	47a2                	lw	a5,8(sp)
80006afc:	0007c783          	lbu	a5,0(a5) # f004c000 <__FLASH_segment_end__+0x6ff4c000>
80006b00:	0796                	slli	a5,a5,0x5
80006b02:	0207f713          	andi	a4,a5,32
        | UART_MCR_LOOP_SET(config->loop_back_en)
80006b06:	47a2                	lw	a5,8(sp)
80006b08:	0017c783          	lbu	a5,1(a5)
80006b0c:	0792                	slli	a5,a5,0x4
80006b0e:	8bc1                	andi	a5,a5,16
80006b10:	8f5d                	or	a4,a4,a5
        | UART_MCR_RTS_SET(!config->set_rts_high);
80006b12:	47a2                	lw	a5,8(sp)
80006b14:	0027c783          	lbu	a5,2(a5)
80006b18:	0017c793          	xori	a5,a5,1
80006b1c:	0ff7f793          	zext.b	a5,a5
80006b20:	0786                	slli	a5,a5,0x1
80006b22:	8b89                	andi	a5,a5,2
80006b24:	8f5d                	or	a4,a4,a5
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
80006b26:	47b2                	lw	a5,12(sp)
80006b28:	db98                	sw	a4,48(a5)
}
80006b2a:	0001                	nop
80006b2c:	0141                	addi	sp,sp,16
80006b2e:	8082                	ret

Disassembly of section .text.uart_disable_irq:

80006b30 <uart_disable_irq>:
 *
 * @param [in] ptr UART base address
 * @param irq_mask IRQ mask value to be disabled
 */
static inline void uart_disable_irq(UART_Type *ptr, uint32_t irq_mask)
{
80006b30:	1141                	addi	sp,sp,-16
80006b32:	c62a                	sw	a0,12(sp)
80006b34:	c42e                	sw	a1,8(sp)
    ptr->IER &= ~irq_mask;
80006b36:	47b2                	lw	a5,12(sp)
80006b38:	53d8                	lw	a4,36(a5)
80006b3a:	47a2                	lw	a5,8(sp)
80006b3c:	fff7c793          	not	a5,a5
80006b40:	8f7d                	and	a4,a4,a5
80006b42:	47b2                	lw	a5,12(sp)
80006b44:	d3d8                	sw	a4,36(a5)
}
80006b46:	0001                	nop
80006b48:	0141                	addi	sp,sp,16
80006b4a:	8082                	ret

Disassembly of section .text.uart_enable_irq:

80006b4c <uart_enable_irq>:
 *
 * @param [in] ptr UART base address
 * @param irq_mask IRQ mask value to be enabled
 */
static inline void uart_enable_irq(UART_Type *ptr, uint32_t irq_mask)
{
80006b4c:	1141                	addi	sp,sp,-16
80006b4e:	c62a                	sw	a0,12(sp)
80006b50:	c42e                	sw	a1,8(sp)
    ptr->IER |= irq_mask;
80006b52:	47b2                	lw	a5,12(sp)
80006b54:	53d8                	lw	a4,36(a5)
80006b56:	47a2                	lw	a5,8(sp)
80006b58:	8f5d                	or	a4,a4,a5
80006b5a:	47b2                	lw	a5,12(sp)
80006b5c:	d3d8                	sw	a4,36(a5)
}
80006b5e:	0001                	nop
80006b60:	0141                	addi	sp,sp,16
80006b62:	8082                	ret

Disassembly of section .text.uart_default_config:

80006b64 <uart_default_config>:
{
80006b64:	1141                	addi	sp,sp,-16
80006b66:	c62a                	sw	a0,12(sp)
80006b68:	c42e                	sw	a1,8(sp)
    config->baudrate = 115200;
80006b6a:	47a2                	lw	a5,8(sp)
80006b6c:	6771                	lui	a4,0x1c
80006b6e:	20070713          	addi	a4,a4,512 # 1c200 <__AHB_SRAM_segment_size__+0x14200>
80006b72:	c3d8                	sw	a4,4(a5)
    config->word_length = word_length_8_bits;
80006b74:	47a2                	lw	a5,8(sp)
80006b76:	470d                	li	a4,3
80006b78:	00e784a3          	sb	a4,9(a5)
    config->parity = parity_none;
80006b7c:	47a2                	lw	a5,8(sp)
80006b7e:	00078523          	sb	zero,10(a5)
    config->num_of_stop_bits = stop_bits_1;
80006b82:	47a2                	lw	a5,8(sp)
80006b84:	00078423          	sb	zero,8(a5)
    config->fifo_enable = true;
80006b88:	47a2                	lw	a5,8(sp)
80006b8a:	4705                	li	a4,1
80006b8c:	00e78723          	sb	a4,14(a5)
    config->rx_fifo_level = uart_rx_fifo_trg_not_empty;
80006b90:	47a2                	lw	a5,8(sp)
80006b92:	00078623          	sb	zero,12(a5)
    config->tx_fifo_level = uart_tx_fifo_trg_not_full;
80006b96:	47a2                	lw	a5,8(sp)
80006b98:	473d                	li	a4,15
80006b9a:	00e785a3          	sb	a4,11(a5)
    config->dma_enable = false;
80006b9e:	47a2                	lw	a5,8(sp)
80006ba0:	000786a3          	sb	zero,13(a5)
    config->modem_config.auto_flow_ctrl_en = false;
80006ba4:	47a2                	lw	a5,8(sp)
80006ba6:	000787a3          	sb	zero,15(a5)
    config->modem_config.loop_back_en = false;
80006baa:	47a2                	lw	a5,8(sp)
80006bac:	00078823          	sb	zero,16(a5)
    config->modem_config.set_rts_high = false;
80006bb0:	47a2                	lw	a5,8(sp)
80006bb2:	000788a3          	sb	zero,17(a5)
    config->rxidle_config.detect_enable = false;
80006bb6:	47a2                	lw	a5,8(sp)
80006bb8:	00078923          	sb	zero,18(a5)
    config->rxidle_config.detect_irq_enable = false;
80006bbc:	47a2                	lw	a5,8(sp)
80006bbe:	000789a3          	sb	zero,19(a5)
    config->rxidle_config.idle_cond = uart_rxline_idle_cond_rxline_logic_one;
80006bc2:	47a2                	lw	a5,8(sp)
80006bc4:	00078a23          	sb	zero,20(a5)
    config->rxidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
80006bc8:	47a2                	lw	a5,8(sp)
80006bca:	4729                	li	a4,10
80006bcc:	00e78aa3          	sb	a4,21(a5)
    config->txidle_config.detect_enable = false;
80006bd0:	47a2                	lw	a5,8(sp)
80006bd2:	00078b23          	sb	zero,22(a5)
    config->txidle_config.detect_irq_enable = false;
80006bd6:	47a2                	lw	a5,8(sp)
80006bd8:	00078ba3          	sb	zero,23(a5)
    config->txidle_config.idle_cond = uart_rxline_idle_cond_rxline_logic_one;
80006bdc:	47a2                	lw	a5,8(sp)
80006bde:	00078c23          	sb	zero,24(a5)
    config->txidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
80006be2:	47a2                	lw	a5,8(sp)
80006be4:	4729                	li	a4,10
80006be6:	00e78ca3          	sb	a4,25(a5)
    config->rx_enable = true;
80006bea:	47a2                	lw	a5,8(sp)
80006bec:	4705                	li	a4,1
80006bee:	00e78d23          	sb	a4,26(a5)
}
80006bf2:	0001                	nop
80006bf4:	0141                	addi	sp,sp,16
80006bf6:	8082                	ret

Disassembly of section .text.uart_flush:

80006bf8 <uart_flush>:
{
80006bf8:	1101                	addi	sp,sp,-32
80006bfa:	c62a                	sw	a0,12(sp)
    uint32_t retry = 0;
80006bfc:	ce02                	sw	zero,28(sp)
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
80006bfe:	a811                	j	80006c12 <.L60>

80006c00 <.L63>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
80006c00:	4772                	lw	a4,28(sp)
80006c02:	6785                	lui	a5,0x1
80006c04:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80006c08:	00e7eb63          	bltu	a5,a4,80006c1e <.L66>
        retry++;
80006c0c:	47f2                	lw	a5,28(sp)
80006c0e:	0785                	addi	a5,a5,1
80006c10:	ce3e                	sw	a5,28(sp)

80006c12 <.L60>:
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
80006c12:	47b2                	lw	a5,12(sp)
80006c14:	5bdc                	lw	a5,52(a5)
80006c16:	0407f793          	andi	a5,a5,64
80006c1a:	d3fd                	beqz	a5,80006c00 <.L63>
80006c1c:	a011                	j	80006c20 <.L62>

80006c1e <.L66>:
            break;
80006c1e:	0001                	nop

80006c20 <.L62>:
    if (retry > HPM_UART_DRV_RETRY_COUNT) {
80006c20:	4772                	lw	a4,28(sp)
80006c22:	6785                	lui	a5,0x1
80006c24:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
80006c28:	00e7f463          	bgeu	a5,a4,80006c30 <.L64>
        return status_timeout;
80006c2c:	478d                	li	a5,3
80006c2e:	a011                	j	80006c32 <.L65>

80006c30 <.L64>:
    return status_success;
80006c30:	4781                	li	a5,0

80006c32 <.L65>:
}
80006c32:	853e                	mv	a0,a5
80006c34:	6105                	addi	sp,sp,32
80006c36:	8082                	ret

Disassembly of section .text.uart_init_rxline_idle_detection:

80006c38 <uart_init_rxline_idle_detection>:
{
80006c38:	1101                	addi	sp,sp,-32
80006c3a:	ce06                	sw	ra,28(sp)
80006c3c:	c62a                	sw	a0,12(sp)
80006c3e:	c42e                	sw	a1,8(sp)
    ptr->IDLE_CFG &= ~(UART_IDLE_CFG_RX_IDLE_EN_MASK
80006c40:	47b2                	lw	a5,12(sp)
80006c42:	43dc                	lw	a5,4(a5)
80006c44:	c007f713          	andi	a4,a5,-1024
80006c48:	47b2                	lw	a5,12(sp)
80006c4a:	c3d8                	sw	a4,4(a5)
    ptr->IDLE_CFG |= UART_IDLE_CFG_RX_IDLE_EN_SET(rxidle_config.detect_enable)
80006c4c:	47b2                	lw	a5,12(sp)
80006c4e:	43d8                	lw	a4,4(a5)
80006c50:	00814783          	lbu	a5,8(sp)
80006c54:	07a2                	slli	a5,a5,0x8
80006c56:	1007f793          	andi	a5,a5,256
                    | UART_IDLE_CFG_RX_IDLE_THR_SET(rxidle_config.threshold)
80006c5a:	00b14683          	lbu	a3,11(sp)
80006c5e:	8edd                	or	a3,a3,a5
                    | UART_IDLE_CFG_RX_IDLE_COND_SET(rxidle_config.idle_cond);
80006c60:	00a14783          	lbu	a5,10(sp)
80006c64:	07a6                	slli	a5,a5,0x9
80006c66:	2007f793          	andi	a5,a5,512
80006c6a:	8fd5                	or	a5,a5,a3
    ptr->IDLE_CFG |= UART_IDLE_CFG_RX_IDLE_EN_SET(rxidle_config.detect_enable)
80006c6c:	8f5d                	or	a4,a4,a5
80006c6e:	47b2                	lw	a5,12(sp)
80006c70:	c3d8                	sw	a4,4(a5)
    if (rxidle_config.detect_irq_enable) {
80006c72:	00914783          	lbu	a5,9(sp)
80006c76:	c791                	beqz	a5,80006c82 <.L93>
        uart_enable_irq(ptr, uart_intr_rx_line_idle);
80006c78:	800005b7          	lui	a1,0x80000
80006c7c:	4532                	lw	a0,12(sp)
80006c7e:	35f9                	jal	80006b4c <uart_enable_irq>
80006c80:	a029                	j	80006c8a <.L94>

80006c82 <.L93>:
        uart_disable_irq(ptr, uart_intr_rx_line_idle);
80006c82:	800005b7          	lui	a1,0x80000
80006c86:	4532                	lw	a0,12(sp)
80006c88:	3565                	jal	80006b30 <uart_disable_irq>

80006c8a <.L94>:
    return status_success;
80006c8a:	4781                	li	a5,0
}
80006c8c:	853e                	mv	a0,a5
80006c8e:	40f2                	lw	ra,28(sp)
80006c90:	6105                	addi	sp,sp,32
80006c92:	8082                	ret

Disassembly of section .text.pllctlv2_pll_clk_is_stable:

80006c94 <pllctlv2_pll_clk_is_stable>:
 * @param [in] pll Index of the PLL to check (pllctlv2_pll0 through pllctlv2_pll6)
 * @param [in] clk Post-divider output index (pllctlv2_clk0 through pllctlv2_clk3)
 * @return true if the PLL CLK is stable and locked, false otherwise
 */
static inline bool pllctlv2_pll_clk_is_stable(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk)
{
80006c94:	1101                	addi	sp,sp,-32
80006c96:	c62a                	sw	a0,12(sp)
80006c98:	87ae                	mv	a5,a1
80006c9a:	8732                	mv	a4,a2
80006c9c:	00f105a3          	sb	a5,11(sp)
80006ca0:	87ba                	mv	a5,a4
80006ca2:	00f10523          	sb	a5,10(sp)
    uint32_t status = ptr->PLL[pll].DIV[clk];
80006ca6:	00b14683          	lbu	a3,11(sp)
80006caa:	00a14783          	lbu	a5,10(sp)
80006cae:	4732                	lw	a4,12(sp)
80006cb0:	0696                	slli	a3,a3,0x5
80006cb2:	97b6                	add	a5,a5,a3
80006cb4:	03078793          	addi	a5,a5,48
80006cb8:	078a                	slli	a5,a5,0x2
80006cba:	97ba                	add	a5,a5,a4
80006cbc:	439c                	lw	a5,0(a5)
80006cbe:	ce3e                	sw	a5,28(sp)
    return (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_DIV_ENABLE_MASK)
80006cc0:	4772                	lw	a4,28(sp)
80006cc2:	100007b7          	lui	a5,0x10000
80006cc6:	8ff9                	and	a5,a5,a4
         || (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_DIV_BUSY_MASK) && IS_HPM_BITMASK_SET(status, PLLCTLV2_PLL_DIV_RESPONSE_MASK)));
80006cc8:	cb89                	beqz	a5,80006cda <.L7>
80006cca:	47f2                	lw	a5,28(sp)
80006ccc:	0007c963          	bltz	a5,80006cde <.L8>
80006cd0:	4772                	lw	a4,28(sp)
80006cd2:	200007b7          	lui	a5,0x20000
80006cd6:	8ff9                	and	a5,a5,a4
80006cd8:	c399                	beqz	a5,80006cde <.L8>

80006cda <.L7>:
80006cda:	4785                	li	a5,1
80006cdc:	a011                	j	80006ce0 <.L9>

80006cde <.L8>:
80006cde:	4781                	li	a5,0

80006ce0 <.L9>:
80006ce0:	8b85                	andi	a5,a5,1
80006ce2:	0ff7f793          	zext.b	a5,a5
}
80006ce6:	853e                	mv	a0,a5
80006ce8:	6105                	addi	sp,sp,32
80006cea:	8082                	ret

Disassembly of section .text.pllctlv2_set_postdiv:

80006cec <pllctlv2_set_postdiv>:
        ptr->PLL[pll].CONFIG |= PLLCTLV2_PLL_CONFIG_SPREAD_MASK;
    }
}

void pllctlv2_set_postdiv(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk, pllctlv2_div_t div_value)
{
80006cec:	1101                	addi	sp,sp,-32
80006cee:	ce06                	sw	ra,28(sp)
80006cf0:	c62a                	sw	a0,12(sp)
80006cf2:	87ae                	mv	a5,a1
80006cf4:	8736                	mv	a4,a3
80006cf6:	00f105a3          	sb	a5,11(sp)
80006cfa:	87b2                	mv	a5,a2
80006cfc:	00f10523          	sb	a5,10(sp)
80006d00:	87ba                	mv	a5,a4
80006d02:	00f104a3          	sb	a5,9(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
80006d06:	47b2                	lw	a5,12(sp)
80006d08:	c7ad                	beqz	a5,80006d72 <.L32>
80006d0a:	00b14703          	lbu	a4,11(sp)
80006d0e:	4785                	li	a5,1
80006d10:	06e7e163          	bltu	a5,a4,80006d72 <.L32>
        ptr->PLL[pll].DIV[clk] =
            (ptr->PLL[pll].DIV[clk] & ~PLLCTLV2_PLL_DIV_DIV_MASK) | PLLCTLV2_PLL_DIV_DIV_SET(div_value);
80006d14:	00b14683          	lbu	a3,11(sp)
80006d18:	00a14783          	lbu	a5,10(sp)
80006d1c:	4732                	lw	a4,12(sp)
80006d1e:	0696                	slli	a3,a3,0x5
80006d20:	97b6                	add	a5,a5,a3
80006d22:	03078793          	addi	a5,a5,48 # 20000030 <_flash_size+0x1ff00030>
80006d26:	078a                	slli	a5,a5,0x2
80006d28:	97ba                	add	a5,a5,a4
80006d2a:	439c                	lw	a5,0(a5)
80006d2c:	fc07f693          	andi	a3,a5,-64
80006d30:	00914783          	lbu	a5,9(sp)
80006d34:	03f7f713          	andi	a4,a5,63
        ptr->PLL[pll].DIV[clk] =
80006d38:	00b14603          	lbu	a2,11(sp)
80006d3c:	00a14783          	lbu	a5,10(sp)
            (ptr->PLL[pll].DIV[clk] & ~PLLCTLV2_PLL_DIV_DIV_MASK) | PLLCTLV2_PLL_DIV_DIV_SET(div_value);
80006d40:	8f55                	or	a4,a4,a3
        ptr->PLL[pll].DIV[clk] =
80006d42:	46b2                	lw	a3,12(sp)
80006d44:	0616                	slli	a2,a2,0x5
80006d46:	97b2                	add	a5,a5,a2
80006d48:	03078793          	addi	a5,a5,48
80006d4c:	078a                	slli	a5,a5,0x2
80006d4e:	97b6                	add	a5,a5,a3
80006d50:	c398                	sw	a4,0(a5)

        while (!pllctlv2_pll_clk_is_stable(ptr, pll, clk)) {
80006d52:	a011                	j	80006d56 <.L30>

80006d54 <.L31>:
            NOP();
80006d54:	0001                	nop

80006d56 <.L30>:
        while (!pllctlv2_pll_clk_is_stable(ptr, pll, clk)) {
80006d56:	00a14703          	lbu	a4,10(sp)
80006d5a:	00b14783          	lbu	a5,11(sp)
80006d5e:	863a                	mv	a2,a4
80006d60:	85be                	mv	a1,a5
80006d62:	4532                	lw	a0,12(sp)
80006d64:	3f05                	jal	80006c94 <pllctlv2_pll_clk_is_stable>
80006d66:	87aa                	mv	a5,a0
80006d68:	0017c793          	xori	a5,a5,1
80006d6c:	0ff7f793          	zext.b	a5,a5
80006d70:	f3f5                	bnez	a5,80006d54 <.L31>

80006d72 <.L32>:
        }
    }
}
80006d72:	0001                	nop
80006d74:	40f2                	lw	ra,28(sp)
80006d76:	6105                	addi	sp,sp,32
80006d78:	8082                	ret

Disassembly of section .text.pllctlv2_get_pll_freq_in_hz:

80006d7a <pllctlv2_get_pll_freq_in_hz>:

uint32_t pllctlv2_get_pll_freq_in_hz(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll)
{
80006d7a:	7139                	addi	sp,sp,-64
80006d7c:	de06                	sw	ra,60(sp)
80006d7e:	c62a                	sw	a0,12(sp)
80006d80:	87ae                	mv	a5,a1
80006d82:	00f105a3          	sb	a5,11(sp)
    uint32_t freq = 0;
80006d86:	d602                	sw	zero,44(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
80006d88:	47b2                	lw	a5,12(sp)
80006d8a:	12078963          	beqz	a5,80006ebc <.L34>
80006d8e:	00b14703          	lbu	a4,11(sp)
80006d92:	4785                	li	a5,1
80006d94:	12e7e463          	bltu	a5,a4,80006ebc <.L34>

80006d98 <.LBB3>:
        uint32_t mfi = PLLCTLV2_PLL_MFI_MFI_GET(ptr->PLL[pll].MFI);
80006d98:	00b14783          	lbu	a5,11(sp)
80006d9c:	4732                	lw	a4,12(sp)
80006d9e:	0785                	addi	a5,a5,1
80006da0:	079e                	slli	a5,a5,0x7
80006da2:	97ba                	add	a5,a5,a4
80006da4:	439c                	lw	a5,0(a5)
80006da6:	07f7f793          	andi	a5,a5,127
80006daa:	d23e                	sw	a5,36(sp)
        uint32_t mfn = PLLCTLV2_PLL_MFN_MFN_GET(ptr->PLL[pll].MFN);
80006dac:	00b14783          	lbu	a5,11(sp)
80006db0:	4732                	lw	a4,12(sp)
80006db2:	0785                	addi	a5,a5,1
80006db4:	079e                	slli	a5,a5,0x7
80006db6:	97ba                	add	a5,a5,a4
80006db8:	43d8                	lw	a4,4(a5)
80006dba:	400007b7          	lui	a5,0x40000
80006dbe:	17fd                	addi	a5,a5,-1 # 3fffffff <_flash_size+0x3fefffff>
80006dc0:	8ff9                	and	a5,a5,a4
80006dc2:	d03e                	sw	a5,32(sp)
        uint32_t mfd = PLLCTLV2_PLL_MFD_MFD_GET(ptr->PLL[pll].MFD);
80006dc4:	00b14783          	lbu	a5,11(sp)
80006dc8:	4732                	lw	a4,12(sp)
80006dca:	0785                	addi	a5,a5,1
80006dcc:	079e                	slli	a5,a5,0x7
80006dce:	97ba                	add	a5,a5,a4
80006dd0:	4798                	lw	a4,8(a5)
80006dd2:	400007b7          	lui	a5,0x40000
80006dd6:	17fd                	addi	a5,a5,-1 # 3fffffff <_flash_size+0x3fefffff>
80006dd8:	8ff9                	and	a5,a5,a4
80006dda:	ce3e                	sw	a5,28(sp)
        /* Trade-off for avoiding the float computing.
         * Ensure both `mfd` and `PLLCTLV2_PLL_XTAL_FREQ` are n * `FREQ_1MHz`, n is a positive integer
         */
        assert((mfd / FREQ_1MHz) * FREQ_1MHz == mfd);
80006ddc:	4772                	lw	a4,28(sp)
80006dde:	431be7b7          	lui	a5,0x431be
80006de2:	e8378793          	addi	a5,a5,-381 # 431bde83 <_flash_size+0x430bde83>
80006de6:	02f737b3          	mulhu	a5,a4,a5
80006dea:	83c9                	srli	a5,a5,0x12
80006dec:	000f46b7          	lui	a3,0xf4
80006df0:	24068693          	addi	a3,a3,576 # f4240 <__DLM_segment_end__+0x54240>
80006df4:	02d787b3          	mul	a5,a5,a3
80006df8:	40f707b3          	sub	a5,a4,a5
80006dfc:	cb89                	beqz	a5,80006e0e <.L35>
80006dfe:	06f00613          	li	a2,111
80006e02:	12018593          	addi	a1,gp,288 # 800039b0 <.LC0>
80006e06:	18818513          	addi	a0,gp,392 # 80003a18 <.LC1>
80006e0a:	d0ffd0ef          	jal	80004b18 <__SEGGER_RTL_X_assert>

80006e0e <.L35>:
        assert((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * FREQ_1MHz == PLLCTLV2_PLL_XTAL_FREQ);

        uint32_t scaled_num;
        uint32_t scaled_denom;
        uint32_t shifted_mfn;
        uint32_t max_mfn = 0xFFFFFFFF / (PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz);
80006e0e:	0aaab7b7          	lui	a5,0xaaab
80006e12:	aaa78793          	addi	a5,a5,-1366 # aaaaaaa <_flash_size+0xa9aaaaa>
80006e16:	cc3e                	sw	a5,24(sp)
        if (mfn < max_mfn) {
80006e18:	5702                	lw	a4,32(sp)
80006e1a:	47e2                	lw	a5,24(sp)
80006e1c:	02f77f63          	bgeu	a4,a5,80006e5a <.L36>
            scaled_num =  (PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * mfn;
80006e20:	5702                	lw	a4,32(sp)
80006e22:	87ba                	mv	a5,a4
80006e24:	0786                	slli	a5,a5,0x1
80006e26:	97ba                	add	a5,a5,a4
80006e28:	078e                	slli	a5,a5,0x3
80006e2a:	c83e                	sw	a5,16(sp)
            scaled_denom = mfd / FREQ_1MHz;
80006e2c:	4772                	lw	a4,28(sp)
80006e2e:	431be7b7          	lui	a5,0x431be
80006e32:	e8378793          	addi	a5,a5,-381 # 431bde83 <_flash_size+0x430bde83>
80006e36:	02f737b3          	mulhu	a5,a4,a5
80006e3a:	83c9                	srli	a5,a5,0x12
80006e3c:	ca3e                	sw	a5,20(sp)
            freq = PLLCTLV2_PLL_XTAL_FREQ * mfi + scaled_num / scaled_denom;
80006e3e:	5712                	lw	a4,36(sp)
80006e40:	016e37b7          	lui	a5,0x16e3
80006e44:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80006e48:	02f70733          	mul	a4,a4,a5
80006e4c:	46c2                	lw	a3,16(sp)
80006e4e:	47d2                	lw	a5,20(sp)
80006e50:	02f6d7b3          	divu	a5,a3,a5
80006e54:	97ba                	add	a5,a5,a4
80006e56:	d63e                	sw	a5,44(sp)
80006e58:	a095                	j	80006ebc <.L34>

80006e5a <.L36>:
        } else {
            shifted_mfn = mfn;
80006e5a:	5782                	lw	a5,32(sp)
80006e5c:	d43e                	sw	a5,40(sp)
            while (shifted_mfn > max_mfn) {
80006e5e:	a021                	j	80006e66 <.L37>

80006e60 <.L38>:
                shifted_mfn >>= 1;
80006e60:	57a2                	lw	a5,40(sp)
80006e62:	8385                	srli	a5,a5,0x1
80006e64:	d43e                	sw	a5,40(sp)

80006e66 <.L37>:
            while (shifted_mfn > max_mfn) {
80006e66:	5722                	lw	a4,40(sp)
80006e68:	47e2                	lw	a5,24(sp)
80006e6a:	fee7ebe3          	bltu	a5,a4,80006e60 <.L38>
            }
            scaled_denom = mfd / FREQ_1MHz;
80006e6e:	4772                	lw	a4,28(sp)
80006e70:	431be7b7          	lui	a5,0x431be
80006e74:	e8378793          	addi	a5,a5,-381 # 431bde83 <_flash_size+0x430bde83>
80006e78:	02f737b3          	mulhu	a5,a4,a5
80006e7c:	83c9                	srli	a5,a5,0x12
80006e7e:	ca3e                	sw	a5,20(sp)
            freq = PLLCTLV2_PLL_XTAL_FREQ * mfi + ((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * shifted_mfn) / scaled_denom +  ((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * (mfn - shifted_mfn)) / scaled_denom;
80006e80:	5712                	lw	a4,36(sp)
80006e82:	016e37b7          	lui	a5,0x16e3
80006e86:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80006e8a:	02f706b3          	mul	a3,a4,a5
80006e8e:	5722                	lw	a4,40(sp)
80006e90:	87ba                	mv	a5,a4
80006e92:	0786                	slli	a5,a5,0x1
80006e94:	97ba                	add	a5,a5,a4
80006e96:	078e                	slli	a5,a5,0x3
80006e98:	873e                	mv	a4,a5
80006e9a:	47d2                	lw	a5,20(sp)
80006e9c:	02f757b3          	divu	a5,a4,a5
80006ea0:	96be                	add	a3,a3,a5
80006ea2:	5702                	lw	a4,32(sp)
80006ea4:	57a2                	lw	a5,40(sp)
80006ea6:	8f1d                	sub	a4,a4,a5
80006ea8:	87ba                	mv	a5,a4
80006eaa:	0786                	slli	a5,a5,0x1
80006eac:	97ba                	add	a5,a5,a4
80006eae:	078e                	slli	a5,a5,0x3
80006eb0:	873e                	mv	a4,a5
80006eb2:	47d2                	lw	a5,20(sp)
80006eb4:	02f757b3          	divu	a5,a4,a5
80006eb8:	97b6                	add	a5,a5,a3
80006eba:	d63e                	sw	a5,44(sp)

80006ebc <.L34>:
        }
    }
    return freq;
80006ebc:	57b2                	lw	a5,44(sp)
}
80006ebe:	853e                	mv	a0,a5
80006ec0:	50f2                	lw	ra,60(sp)
80006ec2:	6121                	addi	sp,sp,64
80006ec4:	8082                	ret

Disassembly of section .text.pllctlv2_get_pll_postdiv_freq_in_hz:

80006ec6 <pllctlv2_get_pll_postdiv_freq_in_hz>:

uint32_t pllctlv2_get_pll_postdiv_freq_in_hz(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk)
{
80006ec6:	7179                	addi	sp,sp,-48
80006ec8:	d606                	sw	ra,44(sp)
80006eca:	c62a                	sw	a0,12(sp)
80006ecc:	87ae                	mv	a5,a1
80006ece:	8732                	mv	a4,a2
80006ed0:	00f105a3          	sb	a5,11(sp)
80006ed4:	87ba                	mv	a5,a4
80006ed6:	00f10523          	sb	a5,10(sp)
    uint32_t postdiv_freq = 0;
80006eda:	ce02                	sw	zero,28(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
80006edc:	47b2                	lw	a5,12(sp)
80006ede:	cba5                	beqz	a5,80006f4e <.L41>
80006ee0:	00b14703          	lbu	a4,11(sp)
80006ee4:	4785                	li	a5,1
80006ee6:	06e7e463          	bltu	a5,a4,80006f4e <.L41>

80006eea <.LBB4>:
        uint32_t postdiv = PLLCTLV2_PLL_DIV_DIV_GET(ptr->PLL[pll].DIV[clk]);
80006eea:	00b14683          	lbu	a3,11(sp)
80006eee:	00a14783          	lbu	a5,10(sp)
80006ef2:	4732                	lw	a4,12(sp)
80006ef4:	0696                	slli	a3,a3,0x5
80006ef6:	97b6                	add	a5,a5,a3
80006ef8:	03078793          	addi	a5,a5,48
80006efc:	078a                	slli	a5,a5,0x2
80006efe:	97ba                	add	a5,a5,a4
80006f00:	439c                	lw	a5,0(a5)
80006f02:	03f7f793          	andi	a5,a5,63
80006f06:	cc3e                	sw	a5,24(sp)
        uint32_t pll_freq = pllctlv2_get_pll_freq_in_hz(ptr, pll);
80006f08:	00b14783          	lbu	a5,11(sp)
80006f0c:	85be                	mv	a1,a5
80006f0e:	4532                	lw	a0,12(sp)
80006f10:	35ad                	jal	80006d7a <pllctlv2_get_pll_freq_in_hz>
80006f12:	ca2a                	sw	a0,20(sp)
        postdiv_freq = (uint32_t) (pll_freq / (100 + postdiv * 100 / 5U) * 100);
80006f14:	4762                	lw	a4,24(sp)
80006f16:	87ba                	mv	a5,a4
80006f18:	078a                	slli	a5,a5,0x2
80006f1a:	97ba                	add	a5,a5,a4
80006f1c:	00279713          	slli	a4,a5,0x2
80006f20:	97ba                	add	a5,a5,a4
80006f22:	078a                	slli	a5,a5,0x2
80006f24:	873e                	mv	a4,a5
80006f26:	ccccd7b7          	lui	a5,0xccccd
80006f2a:	ccd78793          	addi	a5,a5,-819 # cccccccd <__FLASH_segment_end__+0x4cbccccd>
80006f2e:	02f737b3          	mulhu	a5,a4,a5
80006f32:	8389                	srli	a5,a5,0x2
80006f34:	06478793          	addi	a5,a5,100
80006f38:	4752                	lw	a4,20(sp)
80006f3a:	02f75733          	divu	a4,a4,a5
80006f3e:	87ba                	mv	a5,a4
80006f40:	078a                	slli	a5,a5,0x2
80006f42:	97ba                	add	a5,a5,a4
80006f44:	00279713          	slli	a4,a5,0x2
80006f48:	97ba                	add	a5,a5,a4
80006f4a:	078a                	slli	a5,a5,0x2
80006f4c:	ce3e                	sw	a5,28(sp)

80006f4e <.L41>:
    }

    return postdiv_freq;
80006f4e:	47f2                	lw	a5,28(sp)
}
80006f50:	853e                	mv	a0,a5
80006f52:	50b2                	lw	ra,44(sp)
80006f54:	6145                	addi	sp,sp,48
80006f56:	8082                	ret

Disassembly of section .text.pcfg_dcdc_set_voltage:

80006f58 <pcfg_dcdc_set_voltage>:

    return PCFG_DCDC_CURRENT_LEVEL_GET(ptr->DCDC_CURRENT) * PCFG_CURRENT_MEASUREMENT_STEP;
}

hpm_stat_t pcfg_dcdc_set_voltage(PCFG_Type *ptr, uint16_t mv)
{
80006f58:	1101                	addi	sp,sp,-32
80006f5a:	c62a                	sw	a0,12(sp)
80006f5c:	87ae                	mv	a5,a1
80006f5e:	00f11523          	sh	a5,10(sp)
    hpm_stat_t stat = status_success;
80006f62:	ce02                	sw	zero,28(sp)
    if ((mv < PCFG_SOC_DCDC_MIN_VOLTAGE_IN_MV) || (mv > PCFG_SOC_DCDC_MAX_VOLTAGE_IN_MV)) {
80006f64:	00a15703          	lhu	a4,10(sp)
80006f68:	25700793          	li	a5,599
80006f6c:	00e7f863          	bgeu	a5,a4,80006f7c <.L26>
80006f70:	00a15703          	lhu	a4,10(sp)
80006f74:	55f00793          	li	a5,1375
80006f78:	00e7f463          	bgeu	a5,a4,80006f80 <.L27>

80006f7c <.L26>:
        return status_invalid_argument;
80006f7c:	4789                	li	a5,2
80006f7e:	a831                	j	80006f9a <.L28>

80006f80 <.L27>:
    }
    ptr->DCDC_MODE = (ptr->DCDC_MODE & ~PCFG_DCDC_MODE_VOLT_MASK) | PCFG_DCDC_MODE_VOLT_SET(mv);
80006f80:	47b2                	lw	a5,12(sp)
80006f82:	4b98                	lw	a4,16(a5)
80006f84:	77fd                	lui	a5,0xfffff
80006f86:	8f7d                	and	a4,a4,a5
80006f88:	00a15683          	lhu	a3,10(sp)
80006f8c:	6785                	lui	a5,0x1
80006f8e:	17fd                	addi	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
80006f90:	8ff5                	and	a5,a5,a3
80006f92:	8f5d                	or	a4,a4,a5
80006f94:	47b2                	lw	a5,12(sp)
80006f96:	cb98                	sw	a4,16(a5)
    return stat;
80006f98:	47f2                	lw	a5,28(sp)

80006f9a <.L28>:
}
80006f9a:	853e                	mv	a0,a5
80006f9c:	6105                	addi	sp,sp,32
80006f9e:	8082                	ret

Disassembly of section .text.console_init:

80006fa0 <console_init>:
#include "hpm_uart_drv.h"

static UART_Type* g_console_uart = NULL;

hpm_stat_t console_init(console_config_t *cfg)
{
80006fa0:	7139                	addi	sp,sp,-64
80006fa2:	de06                	sw	ra,60(sp)
80006fa4:	c62a                	sw	a0,12(sp)
    hpm_stat_t stat = status_fail;
80006fa6:	4785                	li	a5,1
80006fa8:	d63e                	sw	a5,44(sp)

    /* disable buffer in standard library */
    setvbuf(stdin, NULL, _IONBF, 0);
80006faa:	000807b7          	lui	a5,0x80
80006fae:	3507a783          	lw	a5,848(a5) # 80350 <stdin>
80006fb2:	4681                	li	a3,0
80006fb4:	4609                	li	a2,2
80006fb6:	4581                	li	a1,0
80006fb8:	853e                	mv	a0,a5
80006fba:	24a9                	jal	80007204 <setvbuf>
    setvbuf(stdout, NULL, _IONBF, 0);
80006fbc:	000807b7          	lui	a5,0x80
80006fc0:	34c7a783          	lw	a5,844(a5) # 8034c <stdout>
80006fc4:	4681                	li	a3,0
80006fc6:	4609                	li	a2,2
80006fc8:	4581                	li	a1,0
80006fca:	853e                	mv	a0,a5
80006fcc:	2c25                	jal	80007204 <setvbuf>

    if (cfg->type == CONSOLE_TYPE_UART) {
80006fce:	47b2                	lw	a5,12(sp)
80006fd0:	439c                	lw	a5,0(a5)
80006fd2:	e7b9                	bnez	a5,80007020 <.L2>

80006fd4 <.LBB2>:
        uart_config_t config = {0};
80006fd4:	c802                	sw	zero,16(sp)
80006fd6:	ca02                	sw	zero,20(sp)
80006fd8:	cc02                	sw	zero,24(sp)
80006fda:	ce02                	sw	zero,28(sp)
80006fdc:	d002                	sw	zero,32(sp)
80006fde:	d202                	sw	zero,36(sp)
80006fe0:	d402                	sw	zero,40(sp)
        uart_default_config((UART_Type *)cfg->base, &config);
80006fe2:	47b2                	lw	a5,12(sp)
80006fe4:	43dc                	lw	a5,4(a5)
80006fe6:	873e                	mv	a4,a5
80006fe8:	081c                	addi	a5,sp,16
80006fea:	85be                	mv	a1,a5
80006fec:	853a                	mv	a0,a4
80006fee:	3e9d                	jal	80006b64 <uart_default_config>
        config.src_freq_in_hz = cfg->src_freq_in_hz;
80006ff0:	47b2                	lw	a5,12(sp)
80006ff2:	479c                	lw	a5,8(a5)
80006ff4:	c83e                	sw	a5,16(sp)
        config.baudrate = cfg->baudrate;
80006ff6:	47b2                	lw	a5,12(sp)
80006ff8:	47dc                	lw	a5,12(a5)
80006ffa:	ca3e                	sw	a5,20(sp)
        stat = uart_init((UART_Type *)cfg->base, &config);
80006ffc:	47b2                	lw	a5,12(sp)
80006ffe:	43dc                	lw	a5,4(a5)
80007000:	873e                	mv	a4,a5
80007002:	081c                	addi	a5,sp,16
80007004:	85be                	mv	a1,a5
80007006:	853a                	mv	a0,a4
80007008:	dccfd0ef          	jal	800045d4 <uart_init>
8000700c:	d62a                	sw	a0,44(sp)
        if (status_success == stat) {
8000700e:	57b2                	lw	a5,44(sp)
80007010:	eb81                	bnez	a5,80007020 <.L2>
            g_console_uart = (UART_Type *)cfg->base;
80007012:	47b2                	lw	a5,12(sp)
80007014:	43dc                	lw	a5,4(a5)
80007016:	873e                	mv	a4,a5
80007018:	000807b7          	lui	a5,0x80
8000701c:	32e7ae23          	sw	a4,828(a5) # 8033c <g_console_uart>

80007020 <.L2>:
        }
    }

    return stat;
80007020:	57b2                	lw	a5,44(sp)
}
80007022:	853e                	mv	a0,a5
80007024:	50f2                	lw	ra,60(sp)
80007026:	6121                	addi	sp,sp,64
80007028:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_write:

8000702a <__SEGGER_RTL_X_file_write>:
__attribute__((used)) FILE *stdin  = &__SEGGER_RTL_stdin_file;  /* NOTE: Provide implementation of stdin for RTL. */
__attribute__((used)) FILE *stdout = &__SEGGER_RTL_stdout_file; /* NOTE: Provide implementation of stdout for RTL. */
__attribute__((used)) FILE *stderr = &__SEGGER_RTL_stderr_file; /* NOTE: Provide implementation of stderr for RTL. */

__attribute__((used)) int __SEGGER_RTL_X_file_write(__SEGGER_RTL_FILE *file, const char *data, unsigned int size)
{
8000702a:	7179                	addi	sp,sp,-48
8000702c:	d606                	sw	ra,44(sp)
8000702e:	c62a                	sw	a0,12(sp)
80007030:	c42e                	sw	a1,8(sp)
80007032:	c232                	sw	a2,4(sp)
    unsigned int count;
    (void)file;
    for (count = 0; count < size; count++) {
80007034:	ce02                	sw	zero,28(sp)
80007036:	a0b9                	j	80007084 <.L13>

80007038 <.L17>:
        if (data[count] == '\n') {
80007038:	4722                	lw	a4,8(sp)
8000703a:	47f2                	lw	a5,28(sp)
8000703c:	97ba                	add	a5,a5,a4
8000703e:	0007c703          	lbu	a4,0(a5)
80007042:	47a9                	li	a5,10
80007044:	00f71d63          	bne	a4,a5,8000705e <.L20>
            while (status_success != uart_send_byte(g_console_uart, '\r')) {
80007048:	0001                	nop

8000704a <.L15>:
8000704a:	000807b7          	lui	a5,0x80
8000704e:	33c7a783          	lw	a5,828(a5) # 8033c <g_console_uart>
80007052:	45b5                	li	a1,13
80007054:	853e                	mv	a0,a5
80007056:	f48fd0ef          	jal	8000479e <uart_send_byte>
8000705a:	87aa                	mv	a5,a0
8000705c:	f7fd                	bnez	a5,8000704a <.L15>

8000705e <.L20>:
            }
        }
        while (status_success != uart_send_byte(g_console_uart, data[count])) {
8000705e:	0001                	nop

80007060 <.L16>:
80007060:	000807b7          	lui	a5,0x80
80007064:	33c7a683          	lw	a3,828(a5) # 8033c <g_console_uart>
80007068:	4722                	lw	a4,8(sp)
8000706a:	47f2                	lw	a5,28(sp)
8000706c:	97ba                	add	a5,a5,a4
8000706e:	0007c783          	lbu	a5,0(a5)
80007072:	85be                	mv	a1,a5
80007074:	8536                	mv	a0,a3
80007076:	f28fd0ef          	jal	8000479e <uart_send_byte>
8000707a:	87aa                	mv	a5,a0
8000707c:	f3f5                	bnez	a5,80007060 <.L16>
    for (count = 0; count < size; count++) {
8000707e:	47f2                	lw	a5,28(sp)
80007080:	0785                	addi	a5,a5,1
80007082:	ce3e                	sw	a5,28(sp)

80007084 <.L13>:
80007084:	4772                	lw	a4,28(sp)
80007086:	4792                	lw	a5,4(sp)
80007088:	faf768e3          	bltu	a4,a5,80007038 <.L17>
        }
    }
    while (status_success != uart_flush(g_console_uart)) {
8000708c:	0001                	nop

8000708e <.L18>:
8000708e:	000807b7          	lui	a5,0x80
80007092:	33c7a783          	lw	a5,828(a5) # 8033c <g_console_uart>
80007096:	853e                	mv	a0,a5
80007098:	3685                	jal	80006bf8 <uart_flush>
8000709a:	87aa                	mv	a5,a0
8000709c:	fbed                	bnez	a5,8000708e <.L18>
    }
    return count;
8000709e:	47f2                	lw	a5,28(sp)

}
800070a0:	853e                	mv	a0,a5
800070a2:	50b2                	lw	ra,44(sp)
800070a4:	6145                	addi	sp,sp,48
800070a6:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_stat:

800070a8 <__SEGGER_RTL_X_file_stat>:
    }
    return 1;
}

__attribute__((used)) int __SEGGER_RTL_X_file_stat(__SEGGER_RTL_FILE *stream)
{
800070a8:	1141                	addi	sp,sp,-16
800070aa:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 0;
800070ac:	4781                	li	a5,0
}
800070ae:	853e                	mv	a0,a5
800070b0:	0141                	addi	sp,sp,16
800070b2:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_bufsize:

800070b4 <__SEGGER_RTL_X_file_bufsize>:

__attribute__((used)) int __SEGGER_RTL_X_file_bufsize(__SEGGER_RTL_FILE *stream)
{
800070b4:	1141                	addi	sp,sp,-16
800070b6:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 1;
800070b8:	4785                	li	a5,1
}
800070ba:	853e                	mv	a0,a5
800070bc:	0141                	addi	sp,sp,16
800070be:	8082                	ret

Disassembly of section .text.libc.__riscv_save_12:

800070c0 <__riscv_save_12>:
800070c0:	7139                	addi	sp,sp,-64
800070c2:	4301                	li	t1,0
800070c4:	c66e                	sw	s11,12(sp)
800070c6:	a019                	j	800070cc <.L__riscv_save_s10_down>

800070c8 <__riscv_save_10>:
800070c8:	7139                	addi	sp,sp,-64
800070ca:	4341                	li	t1,16

800070cc <.L__riscv_save_s10_down>:
800070cc:	c86a                	sw	s10,16(sp)
800070ce:	ca66                	sw	s9,20(sp)
800070d0:	cc62                	sw	s8,24(sp)
800070d2:	ce5e                	sw	s7,28(sp)
800070d4:	a021                	j	800070dc <.L__riscv_save_s6_down>

800070d6 <__riscv_save_4>:
800070d6:	7139                	addi	sp,sp,-64
800070d8:	02000313          	li	t1,32

800070dc <.L__riscv_save_s6_down>:
800070dc:	d05a                	sw	s6,32(sp)
800070de:	d256                	sw	s5,36(sp)
800070e0:	d452                	sw	s4,40(sp)
800070e2:	d64e                	sw	s3,44(sp)
800070e4:	d84a                	sw	s2,48(sp)
800070e6:	da26                	sw	s1,52(sp)
800070e8:	dc22                	sw	s0,56(sp)
800070ea:	de06                	sw	ra,60(sp)
800070ec:	911a                	add	sp,sp,t1
800070ee:	8282                	jr	t0

Disassembly of section .text.libc.__riscv_restore_12:

800070f0 <__riscv_restore_12>:
800070f0:	4db2                	lw	s11,12(sp)
800070f2:	0141                	addi	sp,sp,16

800070f4 <__riscv_restore_11>:
800070f4:	4d02                	lw	s10,0(sp)

800070f6 <__riscv_restore_10>:
800070f6:	4c92                	lw	s9,4(sp)

800070f8 <__riscv_restore_9>:
800070f8:	4c22                	lw	s8,8(sp)

800070fa <__riscv_restore_8>:
800070fa:	4bb2                	lw	s7,12(sp)
800070fc:	0141                	addi	sp,sp,16

800070fe <__riscv_restore_7>:
800070fe:	4b02                	lw	s6,0(sp)

80007100 <__riscv_restore_6>:
80007100:	4a92                	lw	s5,4(sp)

80007102 <__riscv_restore_5>:
80007102:	4a22                	lw	s4,8(sp)

80007104 <__riscv_restore_4>:
80007104:	49b2                	lw	s3,12(sp)
80007106:	0141                	addi	sp,sp,16

80007108 <__riscv_restore_3>:
80007108:	4902                	lw	s2,0(sp)

8000710a <__riscv_restore_2>:
8000710a:	4492                	lw	s1,4(sp)

8000710c <__riscv_restore_1>:
8000710c:	4422                	lw	s0,8(sp)

8000710e <__riscv_restore_0>:
8000710e:	40b2                	lw	ra,12(sp)
80007110:	0141                	addi	sp,sp,16
80007112:	8082                	ret

Disassembly of section .text.libc.itoa:

80007114 <itoa>:
80007114:	1141                	addi	sp,sp,-16
80007116:	c606                	sw	ra,12(sp)
80007118:	c422                	sw	s0,8(sp)
8000711a:	842e                	mv	s0,a1
8000711c:	00055963          	bgez	a0,8000712e <itoa+0x1a>
80007120:	45a9                	li	a1,10
80007122:	00b61663          	bne	a2,a1,8000712e <itoa+0x1a>
80007126:	4629                	li	a2,10
80007128:	4685                	li	a3,1
8000712a:	85a2                	mv	a1,s0
8000712c:	a019                	j	80007132 <itoa+0x1e>
8000712e:	85a2                	mv	a1,s0
80007130:	4681                	li	a3,0
80007132:	97dfd0ef          	jal	80004aae <__SEGGER_RTL_xtoa>
80007136:	8522                	mv	a0,s0
80007138:	40b2                	lw	ra,12(sp)
8000713a:	4422                	lw	s0,8(sp)
8000713c:	0141                	addi	sp,sp,16
8000713e:	8082                	ret

Disassembly of section .text.libc.abort:

80007140 <abort>:
80007140:	1141                	addi	sp,sp,-16
80007142:	c606                	sw	ra,12(sp)
80007144:	4501                	li	a0,0
80007146:	2011                	jal	8000714a <raise>
80007148:	bff5                	j	80007144 <abort+0x4>

Disassembly of section .text.libc.raise:

8000714a <raise>:
8000714a:	1141                	addi	sp,sp,-16
8000714c:	c606                	sw	ra,12(sp)
8000714e:	4615                	li	a2,5
80007150:	55fd                	li	a1,-1
80007152:	02a66f63          	bltu	a2,a0,80007190 <raise+0x46>
80007156:	00251693          	slli	a3,a0,0x2
8000715a:	00080637          	lui	a2,0x80
8000715e:	31460613          	addi	a2,a2,788 # 80314 <__SEGGER_RTL_aSigTab>
80007162:	96b2                	add	a3,a3,a2
80007164:	4290                	lw	a2,0(a3)
80007166:	80005737          	lui	a4,0x80005
8000716a:	b6a70713          	addi	a4,a4,-1174 # 80004b6a <__SEGGER_RTL_SIGNAL_SIG_IGN>
8000716e:	c298                	sw	a4,0(a3)
80007170:	c605                	beqz	a2,80007198 <raise+0x4e>
80007172:	11e18793          	addi	a5,gp,286 # 800039ae <__SEGGER_RTL_SIGNAL_SIG_ERR>
80007176:	00f60d63          	beq	a2,a5,80007190 <raise+0x46>
8000717a:	00e60a63          	beq	a2,a4,8000718e <raise+0x44>
8000717e:	800035b7          	lui	a1,0x80003
80007182:	06658593          	addi	a1,a1,102 # 80003066 <__SEGGER_RTL_SIGNAL_SIG_DFL>
80007186:	00b60963          	beq	a2,a1,80007198 <raise+0x4e>
8000718a:	c28c                	sw	a1,0(a3)
8000718c:	9602                	jalr	a2
8000718e:	4581                	li	a1,0
80007190:	852e                	mv	a0,a1
80007192:	40b2                	lw	ra,12(sp)
80007194:	0141                	addi	sp,sp,16
80007196:	8082                	ret
80007198:	4505                	li	a0,1
8000719a:	ec1fb0ef          	jal	8000305a <exit>

Disassembly of section .text.libc.__SEGGER_RTL_puts_no_nl:

8000719e <__SEGGER_RTL_puts_no_nl>:
8000719e:	1141                	addi	sp,sp,-16
800071a0:	c606                	sw	ra,12(sp)
800071a2:	c422                	sw	s0,8(sp)
800071a4:	c226                	sw	s1,4(sp)
800071a6:	000805b7          	lui	a1,0x80
800071aa:	34c5a403          	lw	s0,844(a1) # 8034c <stdout>
800071ae:	84aa                	mv	s1,a0
800071b0:	69b000ef          	jal	8000804a <strlen>
800071b4:	862a                	mv	a2,a0
800071b6:	8522                	mv	a0,s0
800071b8:	85a6                	mv	a1,s1
800071ba:	40b2                	lw	ra,12(sp)
800071bc:	4422                	lw	s0,8(sp)
800071be:	4492                	lw	s1,4(sp)
800071c0:	0141                	addi	sp,sp,16
800071c2:	b5a5                	j	8000702a <__SEGGER_RTL_X_file_write>

Disassembly of section .text.libc.fwrite:

800071c4 <fwrite>:
800071c4:	1101                	addi	sp,sp,-32
800071c6:	ce06                	sw	ra,28(sp)
800071c8:	cc22                	sw	s0,24(sp)
800071ca:	ca26                	sw	s1,20(sp)
800071cc:	c84a                	sw	s2,16(sp)
800071ce:	c64e                	sw	s3,12(sp)
800071d0:	84b6                	mv	s1,a3
800071d2:	89b2                	mv	s3,a2
800071d4:	842e                	mv	s0,a1
800071d6:	892a                	mv	s2,a0
800071d8:	8536                	mv	a0,a3
800071da:	35f9                	jal	800070a8 <__SEGGER_RTL_X_file_stat>
800071dc:	00054663          	bltz	a0,800071e8 <fwrite+0x24>
800071e0:	02898633          	mul	a2,s3,s0
800071e4:	00867463          	bgeu	a2,s0,800071ec <fwrite+0x28>
800071e8:	4501                	li	a0,0
800071ea:	a031                	j	800071f6 <fwrite+0x32>
800071ec:	8526                	mv	a0,s1
800071ee:	85ca                	mv	a1,s2
800071f0:	3d2d                	jal	8000702a <__SEGGER_RTL_X_file_write>
800071f2:	02855533          	divu	a0,a0,s0
800071f6:	40f2                	lw	ra,28(sp)
800071f8:	4462                	lw	s0,24(sp)
800071fa:	44d2                	lw	s1,20(sp)
800071fc:	4942                	lw	s2,16(sp)
800071fe:	49b2                	lw	s3,12(sp)
80007200:	6105                	addi	sp,sp,32
80007202:	8082                	ret

Disassembly of section .text.libc.setvbuf:

80007204 <setvbuf>:
80007204:	4501                	li	a0,0
80007206:	8082                	ret

Disassembly of section .text.libc.__mulsf3:

80007208 <__mulsf3>:
80007208:	80000737          	lui	a4,0x80000
8000720c:	0ff00293          	li	t0,255
80007210:	00b547b3          	xor	a5,a0,a1
80007214:	8ff9                	and	a5,a5,a4
80007216:	00151613          	slli	a2,a0,0x1
8000721a:	8261                	srli	a2,a2,0x18
8000721c:	00159693          	slli	a3,a1,0x1
80007220:	82e1                	srli	a3,a3,0x18
80007222:	ce29                	beqz	a2,8000727c <.L__mulsf3_lhs_zero_or_subnormal>
80007224:	c6bd                	beqz	a3,80007292 <.L__mulsf3_rhs_zero_or_subnormal>
80007226:	04560f63          	beq	a2,t0,80007284 <.L__mulsf3_lhs_inf_or_nan>
8000722a:	06568963          	beq	a3,t0,8000729c <.L__mulsf3_rhs_inf_or_nan>
8000722e:	9636                	add	a2,a2,a3
80007230:	0522                	slli	a0,a0,0x8
80007232:	8d59                	or	a0,a0,a4
80007234:	05a2                	slli	a1,a1,0x8
80007236:	8dd9                	or	a1,a1,a4
80007238:	02b506b3          	mul	a3,a0,a1
8000723c:	02b53533          	mulhu	a0,a0,a1
80007240:	00d036b3          	snez	a3,a3
80007244:	8d55                	or	a0,a0,a3
80007246:	00054463          	bltz	a0,8000724e <.L__mulsf3_normalized>
8000724a:	0506                	slli	a0,a0,0x1
8000724c:	167d                	addi	a2,a2,-1

8000724e <.L__mulsf3_normalized>:
8000724e:	f8160613          	addi	a2,a2,-127
80007252:	04064863          	bltz	a2,800072a2 <.L__mulsf3_zero_or_underflow>
80007256:	12fd                	addi	t0,t0,-1 # ffffffff <__AHB_SRAM_segment_end__+0xfbf7fff>
80007258:	00565f63          	bge	a2,t0,80007276 <.L__mulsf3_inf>
8000725c:	01851693          	slli	a3,a0,0x18
80007260:	8121                	srli	a0,a0,0x8
80007262:	065e                	slli	a2,a2,0x17
80007264:	9532                	add	a0,a0,a2
80007266:	0006d663          	bgez	a3,80007272 <.L__mulsf3_apply_sign>
8000726a:	0505                	addi	a0,a0,1 # f00d0001 <__FLASH_segment_end__+0x6ffd0001>
8000726c:	0686                	slli	a3,a3,0x1
8000726e:	e291                	bnez	a3,80007272 <.L__mulsf3_apply_sign>
80007270:	9979                	andi	a0,a0,-2

80007272 <.L__mulsf3_apply_sign>:
80007272:	8d5d                	or	a0,a0,a5
80007274:	8082                	ret

80007276 <.L__mulsf3_inf>:
80007276:	7f800537          	lui	a0,0x7f800
8000727a:	bfe5                	j	80007272 <.L__mulsf3_apply_sign>

8000727c <.L__mulsf3_lhs_zero_or_subnormal>:
8000727c:	00568d63          	beq	a3,t0,80007296 <.L__mulsf3_nan>

80007280 <.L__mulsf3_signed_zero>:
80007280:	853e                	mv	a0,a5
80007282:	8082                	ret

80007284 <.L__mulsf3_lhs_inf_or_nan>:
80007284:	0526                	slli	a0,a0,0x9
80007286:	e901                	bnez	a0,80007296 <.L__mulsf3_nan>
80007288:	fe5697e3          	bne	a3,t0,80007276 <.L__mulsf3_inf>
8000728c:	05a6                	slli	a1,a1,0x9
8000728e:	e581                	bnez	a1,80007296 <.L__mulsf3_nan>
80007290:	b7dd                	j	80007276 <.L__mulsf3_inf>

80007292 <.L__mulsf3_rhs_zero_or_subnormal>:
80007292:	fe5617e3          	bne	a2,t0,80007280 <.L__mulsf3_signed_zero>

80007296 <.L__mulsf3_nan>:
80007296:	7fc00537          	lui	a0,0x7fc00
8000729a:	8082                	ret

8000729c <.L__mulsf3_rhs_inf_or_nan>:
8000729c:	05a6                	slli	a1,a1,0x9
8000729e:	fde5                	bnez	a1,80007296 <.L__mulsf3_nan>
800072a0:	bfd9                	j	80007276 <.L__mulsf3_inf>

800072a2 <.L__mulsf3_zero_or_underflow>:
800072a2:	0605                	addi	a2,a2,1
800072a4:	fe71                	bnez	a2,80007280 <.L__mulsf3_signed_zero>
800072a6:	8521                	srai	a0,a0,0x8
800072a8:	00150293          	addi	t0,a0,1 # 7fc00001 <_flash_size+0x7fb00001>
800072ac:	0509                	addi	a0,a0,2
800072ae:	fc0299e3          	bnez	t0,80007280 <.L__mulsf3_signed_zero>
800072b2:	00800537          	lui	a0,0x800
800072b6:	bf75                	j	80007272 <.L__mulsf3_apply_sign>

Disassembly of section .text.libc.__divsf3:

800072b8 <__divsf3>:
800072b8:	0ff00293          	li	t0,255
800072bc:	00151713          	slli	a4,a0,0x1
800072c0:	8361                	srli	a4,a4,0x18
800072c2:	00159793          	slli	a5,a1,0x1
800072c6:	83e1                	srli	a5,a5,0x18
800072c8:	00b54333          	xor	t1,a0,a1
800072cc:	01f35313          	srli	t1,t1,0x1f
800072d0:	037e                	slli	t1,t1,0x1f
800072d2:	cf4d                	beqz	a4,8000738c <.L__divsf3_lhs_zero_or_subnormal>
800072d4:	cbe9                	beqz	a5,800073a6 <.L__divsf3_rhs_zero_or_subnormal>
800072d6:	0c570363          	beq	a4,t0,8000739c <.L__divsf3_lhs_inf_or_nan>
800072da:	0c578b63          	beq	a5,t0,800073b0 <.L__divsf3_rhs_inf_or_nan>
800072de:	8f1d                	sub	a4,a4,a5

800072e0 <.Lpcrel_hi0>:
800072e0:	d0018293          	addi	t0,gp,-768 # 80003590 <__SEGGER_RTL_fdiv_reciprocal_table>
800072e4:	00f5d693          	srli	a3,a1,0xf
800072e8:	0fc6f693          	andi	a3,a3,252
800072ec:	9696                	add	a3,a3,t0
800072ee:	429c                	lw	a5,0(a3)
800072f0:	4187d613          	srai	a2,a5,0x18
800072f4:	00f59693          	slli	a3,a1,0xf
800072f8:	82e1                	srli	a3,a3,0x18
800072fa:	0016f293          	andi	t0,a3,1
800072fe:	8285                	srli	a3,a3,0x1
80007300:	fc068693          	addi	a3,a3,-64
80007304:	9696                	add	a3,a3,t0
80007306:	02d60633          	mul	a2,a2,a3
8000730a:	07a2                	slli	a5,a5,0x8
8000730c:	83a1                	srli	a5,a5,0x8
8000730e:	963e                	add	a2,a2,a5
80007310:	05a2                	slli	a1,a1,0x8
80007312:	81a1                	srli	a1,a1,0x8
80007314:	008007b7          	lui	a5,0x800
80007318:	8ddd                	or	a1,a1,a5
8000731a:	02c586b3          	mul	a3,a1,a2
8000731e:	0522                	slli	a0,a0,0x8
80007320:	8121                	srli	a0,a0,0x8
80007322:	8d5d                	or	a0,a0,a5
80007324:	02c697b3          	mulh	a5,a3,a2
80007328:	00b532b3          	sltu	t0,a0,a1
8000732c:	00551533          	sll	a0,a0,t0
80007330:	40570733          	sub	a4,a4,t0
80007334:	01465693          	srli	a3,a2,0x14
80007338:	8a85                	andi	a3,a3,1
8000733a:	0016c693          	xori	a3,a3,1
8000733e:	062e                	slli	a2,a2,0xb
80007340:	8e1d                	sub	a2,a2,a5
80007342:	8e15                	sub	a2,a2,a3
80007344:	050a                	slli	a0,a0,0x2
80007346:	02a617b3          	mulh	a5,a2,a0
8000734a:	07e70613          	addi	a2,a4,126 # 8000007e <_flash_size+0x7ff0007e>
8000734e:	055a                	slli	a0,a0,0x16
80007350:	8d0d                	sub	a0,a0,a1
80007352:	02b786b3          	mul	a3,a5,a1
80007356:	0fe00293          	li	t0,254
8000735a:	00567f63          	bgeu	a2,t0,80007378 <.L__divsf3_underflow_or_overflow>
8000735e:	40a68533          	sub	a0,a3,a0
80007362:	000522b3          	sltz	t0,a0
80007366:	9796                	add	a5,a5,t0
80007368:	0017f513          	andi	a0,a5,1
8000736c:	8385                	srli	a5,a5,0x1
8000736e:	953e                	add	a0,a0,a5
80007370:	065e                	slli	a2,a2,0x17
80007372:	9532                	add	a0,a0,a2
80007374:	951a                	add	a0,a0,t1
80007376:	8082                	ret

80007378 <.L__divsf3_underflow_or_overflow>:
80007378:	851a                	mv	a0,t1
8000737a:	00564563          	blt	a2,t0,80007384 <.L__divsf3_done>
8000737e:	7f800337          	lui	t1,0x7f800

80007382 <.L__divsf3_apply_sign>:
80007382:	951a                	add	a0,a0,t1

80007384 <.L__divsf3_done>:
80007384:	8082                	ret

80007386 <.L__divsf3_inf>:
80007386:	7f800537          	lui	a0,0x7f800
8000738a:	bfe5                	j	80007382 <.L__divsf3_apply_sign>

8000738c <.L__divsf3_lhs_zero_or_subnormal>:
8000738c:	c789                	beqz	a5,80007396 <.L__divsf3_nan>
8000738e:	02579363          	bne	a5,t0,800073b4 <.L__divsf3_signed_zero>
80007392:	05a6                	slli	a1,a1,0x9
80007394:	c185                	beqz	a1,800073b4 <.L__divsf3_signed_zero>

80007396 <.L__divsf3_nan>:
80007396:	7fc00537          	lui	a0,0x7fc00
8000739a:	8082                	ret

8000739c <.L__divsf3_lhs_inf_or_nan>:
8000739c:	0526                	slli	a0,a0,0x9
8000739e:	fd65                	bnez	a0,80007396 <.L__divsf3_nan>
800073a0:	fe5793e3          	bne	a5,t0,80007386 <.L__divsf3_inf>
800073a4:	bfcd                	j	80007396 <.L__divsf3_nan>

800073a6 <.L__divsf3_rhs_zero_or_subnormal>:
800073a6:	fe5710e3          	bne	a4,t0,80007386 <.L__divsf3_inf>
800073aa:	0526                	slli	a0,a0,0x9
800073ac:	f56d                	bnez	a0,80007396 <.L__divsf3_nan>
800073ae:	bfe1                	j	80007386 <.L__divsf3_inf>

800073b0 <.L__divsf3_rhs_inf_or_nan>:
800073b0:	05a6                	slli	a1,a1,0x9
800073b2:	f1f5                	bnez	a1,80007396 <.L__divsf3_nan>

800073b4 <.L__divsf3_signed_zero>:
800073b4:	851a                	mv	a0,t1
800073b6:	8082                	ret

Disassembly of section .text.libc.__eqsf2:

800073b8 <__eqsf2>:
800073b8:	ff000637          	lui	a2,0xff000
800073bc:	00151693          	slli	a3,a0,0x1
800073c0:	02d66063          	bltu	a2,a3,800073e0 <.L__eqsf2_one>
800073c4:	00159693          	slli	a3,a1,0x1
800073c8:	00d66c63          	bltu	a2,a3,800073e0 <.L__eqsf2_one>
800073cc:	00b56633          	or	a2,a0,a1
800073d0:	0606                	slli	a2,a2,0x1
800073d2:	c609                	beqz	a2,800073dc <.L__eqsf2_zero>
800073d4:	8d0d                	sub	a0,a0,a1
800073d6:	00a03533          	snez	a0,a0
800073da:	8082                	ret

800073dc <.L__eqsf2_zero>:
800073dc:	4501                	li	a0,0
800073de:	8082                	ret

800073e0 <.L__eqsf2_one>:
800073e0:	4505                	li	a0,1
800073e2:	8082                	ret

Disassembly of section .text.libc.__fixunssfdi:

800073e4 <__fixunssfdi>:
800073e4:	04054a63          	bltz	a0,80007438 <.L__fixunssfdi_zero_result>
800073e8:	00151613          	slli	a2,a0,0x1
800073ec:	8261                	srli	a2,a2,0x18
800073ee:	f8160613          	addi	a2,a2,-127 # feffff81 <__AHB_SRAM_segment_end__+0xebf7f81>
800073f2:	04064363          	bltz	a2,80007438 <.L__fixunssfdi_zero_result>
800073f6:	800006b7          	lui	a3,0x80000
800073fa:	02000293          	li	t0,32
800073fe:	00565b63          	bge	a2,t0,80007414 <.L__fixunssfdi_long_shift>
80007402:	40c00633          	neg	a2,a2
80007406:	067d                	addi	a2,a2,31
80007408:	0522                	slli	a0,a0,0x8
8000740a:	8d55                	or	a0,a0,a3
8000740c:	00c55533          	srl	a0,a0,a2
80007410:	4581                	li	a1,0
80007412:	8082                	ret

80007414 <.L__fixunssfdi_long_shift>:
80007414:	40c00633          	neg	a2,a2
80007418:	03f60613          	addi	a2,a2,63
8000741c:	02064163          	bltz	a2,8000743e <.L__fixunssfdi_overflow_result>
80007420:	00851593          	slli	a1,a0,0x8
80007424:	8dd5                	or	a1,a1,a3
80007426:	4501                	li	a0,0
80007428:	c619                	beqz	a2,80007436 <.L__fixunssfdi_shift_32>
8000742a:	40c006b3          	neg	a3,a2
8000742e:	00d59533          	sll	a0,a1,a3
80007432:	00c5d5b3          	srl	a1,a1,a2

80007436 <.L__fixunssfdi_shift_32>:
80007436:	8082                	ret

80007438 <.L__fixunssfdi_zero_result>:
80007438:	4501                	li	a0,0
8000743a:	4581                	li	a1,0
8000743c:	8082                	ret

8000743e <.L__fixunssfdi_overflow_result>:
8000743e:	557d                	li	a0,-1
80007440:	55fd                	li	a1,-1
80007442:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ldouble_to_double:

80007444 <__SEGGER_RTL_ldouble_to_double>:
80007444:	00169793          	slli	a5,a3,0x1
80007448:	453d                	li	a0,15
8000744a:	83c5                	srli	a5,a5,0x11
8000744c:	052a                	slli	a0,a0,0xa
8000744e:	80000837          	lui	a6,0x80000
80007452:	00f56663          	bltu	a0,a5,8000745e <__SEGGER_RTL_ldouble_to_double+0x1a>
80007456:	4501                	li	a0,0
80007458:	0106f5b3          	and	a1,a3,a6
8000745c:	8082                	ret
8000745e:	5545                	li	a0,-15
80007460:	6711                	lui	a4,0x4
80007462:	052a                	slli	a0,a0,0xa
80007464:	953e                	add	a0,a0,a5
80007466:	3ff70713          	addi	a4,a4,1023 # 43ff <__HEAPSIZE__+0x3ff>
8000746a:	83a9                	srli	a5,a5,0xa
8000746c:	00e50963          	beq	a0,a4,8000747e <__SEGGER_RTL_ldouble_to_double+0x3a>
80007470:	0117b713          	sltiu	a4,a5,17
80007474:	40e00733          	neg	a4,a4
80007478:	8ef9                	and	a3,a3,a4
8000747a:	8e79                	and	a2,a2,a4
8000747c:	8df9                	and	a1,a1,a4
8000747e:	4741                	li	a4,16
80007480:	00f77463          	bgeu	a4,a5,80007488 <__SEGGER_RTL_ldouble_to_double+0x44>
80007484:	7ff00513          	li	a0,2047
80007488:	0106f733          	and	a4,a3,a6
8000748c:	0552                	slli	a0,a0,0x14
8000748e:	8d59                	or	a0,a0,a4
80007490:	01c65713          	srli	a4,a2,0x1c
80007494:	0692                	slli	a3,a3,0x4
80007496:	0612                	slli	a2,a2,0x4
80007498:	01c5d793          	srli	a5,a1,0x1c
8000749c:	8ed9                	or	a3,a3,a4
8000749e:	06b2                	slli	a3,a3,0xc
800074a0:	00c6d593          	srli	a1,a3,0xc
800074a4:	8dc9                	or	a1,a1,a0
800074a6:	00f66533          	or	a0,a2,a5
800074aa:	8082                	ret

Disassembly of section .text.libc.__trunctfsf2:

800074ac <__trunctfsf2>:
800074ac:	1141                	addi	sp,sp,-16
800074ae:	c606                	sw	ra,12(sp)
800074b0:	4118                	lw	a4,0(a0)
800074b2:	414c                	lw	a1,4(a0)
800074b4:	4510                	lw	a2,8(a0)
800074b6:	4554                	lw	a3,12(a0)
800074b8:	853a                	mv	a0,a4
800074ba:	3769                	jal	80007444 <__SEGGER_RTL_ldouble_to_double>
800074bc:	9bbfd0ef          	jal	80004e76 <__truncdfsf2>
800074c0:	40b2                	lw	ra,12(sp)
800074c2:	0141                	addi	sp,sp,16
800074c4:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnan:

800074c6 <__SEGGER_RTL_float32_isnan>:
800074c6:	0506                	slli	a0,a0,0x1
800074c8:	ff0005b7          	lui	a1,0xff000
800074cc:	00a5b533          	sltu	a0,a1,a0
800074d0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isinf:

800074d2 <__SEGGER_RTL_float32_isinf>:
800074d2:	0506                	slli	a0,a0,0x1
800074d4:	8105                	srli	a0,a0,0x1
800074d6:	7f8005b7          	lui	a1,0x7f800
800074da:	8d2d                	xor	a0,a0,a1
800074dc:	00153513          	seqz	a0,a0
800074e0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnormal:

800074e2 <__SEGGER_RTL_float32_isnormal>:
800074e2:	00151593          	slli	a1,a0,0x1
800074e6:	7f800637          	lui	a2,0x7f800
800074ea:	81e1                	srli	a1,a1,0x18
800074ec:	8d71                	and	a0,a0,a2
800074ee:	0ff5b593          	sltiu	a1,a1,255
800074f2:	00a03533          	snez	a0,a0
800074f6:	8d6d                	and	a0,a0,a1
800074f8:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_signbit:

800074fa <__SEGGER_RTL_float32_signbit>:
800074fa:	817d                	srli	a0,a0,0x1f
800074fc:	8082                	ret

Disassembly of section .text.libc.ldexpf:

800074fe <ldexpf>:
800074fe:	00151613          	slli	a2,a0,0x1
80007502:	8261                	srli	a2,a2,0x18
80007504:	f0160693          	addi	a3,a2,-255 # 7f7fff01 <_flash_size+0x7f6fff01>
80007508:	f0200713          	li	a4,-254
8000750c:	02e6ea63          	bltu	a3,a4,80007540 <ldexpf+0x42>
80007510:	95b2                	add	a1,a1,a2
80007512:	fff58613          	addi	a2,a1,-1 # 7f7fffff <_flash_size+0x7f6fffff>
80007516:	0fd00693          	li	a3,253
8000751a:	00c6e963          	bltu	a3,a2,8000752c <ldexpf+0x2e>
8000751e:	80800637          	lui	a2,0x80800
80007522:	167d                	addi	a2,a2,-1 # 807fffff <__FLASH_segment_end__+0x6fffff>
80007524:	8d71                	and	a0,a0,a2
80007526:	05de                	slli	a1,a1,0x17
80007528:	8d4d                	or	a0,a0,a1
8000752a:	8082                	ret
8000752c:	0015a593          	slti	a1,a1,1
80007530:	80000637          	lui	a2,0x80000
80007534:	8d71                	and	a0,a0,a2
80007536:	15fd                	addi	a1,a1,-1
80007538:	7f800637          	lui	a2,0x7f800
8000753c:	8df1                	and	a1,a1,a2
8000753e:	8d4d                	or	a0,a0,a1
80007540:	8082                	ret

Disassembly of section .text.libc.fmodf:

80007542 <fmodf>:
80007542:	b95ff2ef          	jal	t0,800070d6 <__riscv_save_4>
80007546:	84aa                	mv	s1,a0
80007548:	01755993          	srli	s3,a0,0x17
8000754c:	fff98513          	addi	a0,s3,-1
80007550:	0fd00613          	li	a2,253
80007554:	0ea66363          	bltu	a2,a0,8000763a <fmodf+0xf8>
80007558:	0175d513          	srli	a0,a1,0x17
8000755c:	f0150513          	addi	a0,a0,-255 # 7fbfff01 <_flash_size+0x7fafff01>
80007560:	f0200613          	li	a2,-254
80007564:	0cc56b63          	bltu	a0,a2,8000763a <fmodf+0xf8>
80007568:	00149413          	slli	s0,s1,0x1
8000756c:	8005                	srli	s0,s0,0x1
8000756e:	80000537          	lui	a0,0x80000
80007572:	00a4f933          	and	s2,s1,a0
80007576:	1085f063          	bgeu	a1,s0,80007676 <fmodf+0x134>
8000757a:	00800637          	lui	a2,0x800
8000757e:	0ff9f513          	zext.b	a0,s3
80007582:	fff60693          	addi	a3,a2,-1 # 7fffff <_flash_size+0x6fffff>
80007586:	c509                	beqz	a0,80007590 <fmodf+0x4e>
80007588:	00d4f433          	and	s0,s1,a3
8000758c:	8c51                	or	s0,s0,a2
8000758e:	a831                	j	800075aa <fmodf+0x68>
80007590:	01745513          	srli	a0,s0,0x17
80007594:	e911                	bnez	a0,800075a8 <fmodf+0x66>
80007596:	8622                	mv	a2,s0
80007598:	00161413          	slli	s0,a2,0x1
8000759c:	01665713          	srli	a4,a2,0x16
800075a0:	157d                	addi	a0,a0,-1 # 7fffffff <_flash_size+0x7fefffff>
800075a2:	8622                	mv	a2,s0
800075a4:	db75                	beqz	a4,80007598 <fmodf+0x56>
800075a6:	a011                	j	800075aa <fmodf+0x68>
800075a8:	4501                	li	a0,0
800075aa:	00159613          	slli	a2,a1,0x1
800075ae:	8261                	srli	a2,a2,0x18
800075b0:	ca01                	beqz	a2,800075c0 <fmodf+0x7e>
800075b2:	8df5                	and	a1,a1,a3
800075b4:	008006b7          	lui	a3,0x800
800075b8:	8dd5                	or	a1,a1,a3
800075ba:	02a64063          	blt	a2,a0,800075da <fmodf+0x98>
800075be:	a081                	j	800075fe <fmodf+0xbc>
800075c0:	0175d613          	srli	a2,a1,0x17
800075c4:	ea15                	bnez	a2,800075f8 <fmodf+0xb6>
800075c6:	86ae                	mv	a3,a1
800075c8:	00169593          	slli	a1,a3,0x1
800075cc:	0166d713          	srli	a4,a3,0x16
800075d0:	167d                	addi	a2,a2,-1
800075d2:	86ae                	mv	a3,a1
800075d4:	db75                	beqz	a4,800075c8 <fmodf+0x86>
800075d6:	02a65463          	bge	a2,a0,800075fe <fmodf+0xbc>
800075da:	40b406b3          	sub	a3,s0,a1
800075de:	0006c563          	bltz	a3,800075e8 <fmodf+0xa6>
800075e2:	04b40a63          	beq	s0,a1,80007636 <fmodf+0xf4>
800075e6:	a011                	j	800075ea <fmodf+0xa8>
800075e8:	86a2                	mv	a3,s0
800075ea:	157d                	addi	a0,a0,-1
800075ec:	00169413          	slli	s0,a3,0x1
800075f0:	fea645e3          	blt	a2,a0,800075da <fmodf+0x98>
800075f4:	8532                	mv	a0,a2
800075f6:	a021                	j	800075fe <fmodf+0xbc>
800075f8:	4601                	li	a2,0
800075fa:	fea040e3          	bgtz	a0,800075da <fmodf+0x98>
800075fe:	40b40633          	sub	a2,s0,a1
80007602:	00064563          	bltz	a2,8000760c <fmodf+0xca>
80007606:	00b41463          	bne	s0,a1,8000760e <fmodf+0xcc>
8000760a:	a035                	j	80007636 <fmodf+0xf4>
8000760c:	8622                	mv	a2,s0
8000760e:	01765593          	srli	a1,a2,0x17
80007612:	e989                	bnez	a1,80007624 <fmodf+0xe2>
80007614:	00161593          	slli	a1,a2,0x1
80007618:	01665693          	srli	a3,a2,0x16
8000761c:	157d                	addi	a0,a0,-1
8000761e:	862e                	mv	a2,a1
80007620:	daf5                	beqz	a3,80007614 <fmodf+0xd2>
80007622:	a011                	j	80007626 <fmodf+0xe4>
80007624:	85b2                	mv	a1,a2
80007626:	04a05c63          	blez	a0,8000767e <fmodf+0x13c>
8000762a:	fff50613          	addi	a2,a0,-1
8000762e:	065e                	slli	a2,a2,0x17
80007630:	964a                	add	a2,a2,s2
80007632:	00c58933          	add	s2,a1,a2
80007636:	854a                	mv	a0,s2
80007638:	b4e9                	j	80007102 <__riscv_restore_5>
8000763a:	00149413          	slli	s0,s1,0x1
8000763e:	ff000537          	lui	a0,0xff000
80007642:	02856c63          	bltu	a0,s0,8000767a <fmodf+0x138>
80007646:	00159a13          	slli	s4,a1,0x1
8000764a:	05456063          	bltu	a0,s4,8000768a <fmodf+0x148>
8000764e:	8005                	srli	s0,s0,0x1
80007650:	7f800537          	lui	a0,0x7f800
80007654:	7fc00937          	lui	s2,0x7fc00
80007658:	fca40fe3          	beq	s0,a0,80007636 <fmodf+0xf4>
8000765c:	e409                	bnez	s0,80007666 <fmodf+0x124>
8000765e:	852e                	mv	a0,a1
80007660:	4581                	li	a1,0
80007662:	3b99                	jal	800073b8 <__eqsf2>
80007664:	e919                	bnez	a0,8000767a <fmodf+0x138>
80007666:	001a5593          	srli	a1,s4,0x1
8000766a:	d5f1                	beqz	a1,80007636 <fmodf+0xf4>
8000766c:	7f800537          	lui	a0,0x7f800
80007670:	eea59fe3          	bne	a1,a0,8000756e <fmodf+0x2c>
80007674:	a019                	j	8000767a <fmodf+0x138>
80007676:	fc8580e3          	beq	a1,s0,80007636 <fmodf+0xf4>
8000767a:	8926                	mv	s2,s1
8000767c:	bf6d                	j	80007636 <fmodf+0xf4>
8000767e:	4601                	li	a2,0
80007680:	4685                	li	a3,1
80007682:	8e89                	sub	a3,a3,a0
80007684:	00d5d5b3          	srl	a1,a1,a3
80007688:	b75d                	j	8000762e <fmodf+0xec>
8000768a:	892e                	mv	s2,a1
8000768c:	b76d                	j	80007636 <fmodf+0xf4>

Disassembly of section .text.libc.floorf:

8000768e <floorf>:
8000768e:	00151593          	slli	a1,a0,0x1
80007692:	81e1                	srli	a1,a1,0x18
80007694:	fff58613          	addi	a2,a1,-1
80007698:	0fe00693          	li	a3,254
8000769c:	04d67963          	bgeu	a2,a3,800076ee <floorf+0x60>
800076a0:	07e00613          	li	a2,126
800076a4:	00b66763          	bltu	a2,a1,800076b2 <floorf+0x24>
800076a8:	857d                	srai	a0,a0,0x1f
800076aa:	bf8005b7          	lui	a1,0xbf800
800076ae:	8d6d                	and	a0,a0,a1
800076b0:	8082                	ret
800076b2:	09500613          	li	a2,149
800076b6:	02b66b63          	bltu	a2,a1,800076ec <floorf+0x5e>
800076ba:	f8158593          	addi	a1,a1,-127 # bf7fff81 <__FLASH_segment_end__+0x3f6fff81>
800076be:	ff800637          	lui	a2,0xff800
800076c2:	00052693          	slti	a3,a0,0
800076c6:	40b65633          	sra	a2,a2,a1
800076ca:	8e69                	and	a2,a2,a0
800076cc:	00b51533          	sll	a0,a0,a1
800076d0:	0016c693          	xori	a3,a3,1
800076d4:	0526                	slli	a0,a0,0x9
800076d6:	8125                	srli	a0,a0,0x9
800076d8:	00153513          	seqz	a0,a0
800076dc:	8d55                	or	a0,a0,a3
800076de:	008006b7          	lui	a3,0x800
800076e2:	00b6d5b3          	srl	a1,a3,a1
800076e6:	157d                	addi	a0,a0,-1 # 7f7fffff <_flash_size+0x7f6fffff>
800076e8:	8d6d                	and	a0,a0,a1
800076ea:	9532                	add	a0,a0,a2
800076ec:	8082                	ret
800076ee:	fdfd                	bnez	a1,800076ec <floorf+0x5e>
800076f0:	800005b7          	lui	a1,0x80000
800076f4:	bf6d                	j	800076ae <floorf+0x20>

Disassembly of section .text.libc.__udivdi3:

800076f6 <__udivdi3>:
800076f6:	872e                	mv	a4,a1
800076f8:	e2b1                	bnez	a3,8000773c <__udivdi3+0x46>
800076fa:	2a070863          	beqz	a4,800079aa <__udivdi3+0x2b4>
800076fe:	01865793          	srli	a5,a2,0x18
80007702:	8fd5                	or	a5,a5,a3
80007704:	ef85                	bnez	a5,8000773c <__udivdi3+0x46>
80007706:	00563813          	sltiu	a6,a2,5
8000770a:	0016b793          	seqz	a5,a3
8000770e:	0107f7b3          	and	a5,a5,a6
80007712:	3c078363          	beqz	a5,80007ad8 <__udivdi3+0x3e2>
80007716:	4689                	li	a3,2
80007718:	3ec6ce63          	blt	a3,a2,80007b14 <__udivdi3+0x41e>
8000771c:	4785                	li	a5,1
8000771e:	86aa                	mv	a3,a0
80007720:	28f60f63          	beq	a2,a5,800079be <__udivdi3+0x2c8>
80007724:	4681                	li	a3,0
80007726:	4789                	li	a5,2
80007728:	4701                	li	a4,0
8000772a:	28f61a63          	bne	a2,a5,800079be <__udivdi3+0x2c8>
8000772e:	8105                	srli	a0,a0,0x1
80007730:	01f59693          	slli	a3,a1,0x1f
80007734:	8ec9                	or	a3,a3,a0
80007736:	0015d713          	srli	a4,a1,0x1
8000773a:	a451                	j	800079be <__udivdi3+0x2c8>
8000773c:	14068e63          	beqz	a3,80007898 <__udivdi3+0x1a2>
80007740:	0106d813          	srli	a6,a3,0x10
80007744:	00155293          	srli	t0,a0,0x1
80007748:	01f59713          	slli	a4,a1,0x1f
8000774c:	0015d893          	srli	a7,a1,0x1
80007750:	00165313          	srli	t1,a2,0x1
80007754:	800083b7          	lui	t2,0x80008
80007758:	be238393          	addi	t2,t2,-1054 # 80007be2 <__SEGGER_RTL_Moeller_inverse_lut>
8000775c:	00183793          	seqz	a5,a6
80007760:	00e2e2b3          	or	t0,t0,a4
80007764:	00479813          	slli	a6,a5,0x4
80007768:	010697b3          	sll	a5,a3,a6
8000776c:	0187d713          	srli	a4,a5,0x18
80007770:	00173713          	seqz	a4,a4
80007774:	070e                	slli	a4,a4,0x3
80007776:	00e79e33          	sll	t3,a5,a4
8000777a:	00e86833          	or	a6,a6,a4
8000777e:	01ce5793          	srli	a5,t3,0x1c
80007782:	0017b793          	seqz	a5,a5
80007786:	078a                	slli	a5,a5,0x2
80007788:	00fe1e33          	sll	t3,t3,a5
8000778c:	00f86833          	or	a6,a6,a5
80007790:	01ee5713          	srli	a4,t3,0x1e
80007794:	00173713          	seqz	a4,a4
80007798:	0706                	slli	a4,a4,0x1
8000779a:	00ee17b3          	sll	a5,t3,a4
8000779e:	00e86733          	or	a4,a6,a4
800077a2:	fff7c793          	not	a5,a5
800077a6:	83fd                	srli	a5,a5,0x1f
800077a8:	8f5d                	or	a4,a4,a5
800077aa:	00e697b3          	sll	a5,a3,a4
800077ae:	01f74813          	xori	a6,a4,31
800077b2:	01035733          	srl	a4,t1,a6
800077b6:	00e7efb3          	or	t6,a5,a4
800077ba:	001ff313          	andi	t1,t6,1
800077be:	016fd713          	srli	a4,t6,0x16
800077c2:	0706                	slli	a4,a4,0x1
800077c4:	971e                	add	a4,a4,t2
800077c6:	c0075383          	lhu	t2,-1024(a4)
800077ca:	00bfd713          	srli	a4,t6,0xb
800077ce:	001fde13          	srli	t3,t6,0x1
800077d2:	00170e93          	addi	t4,a4,1
800077d6:	02738733          	mul	a4,t2,t2
800077da:	03d73eb3          	mulhu	t4,a4,t4
800077de:	8f7e                	mv	t5,t6
800077e0:	9e1a                	add	t3,t3,t1
800077e2:	40600333          	neg	t1,t1
800077e6:	0392                	slli	t2,t2,0x4
800077e8:	fffec713          	not	a4,t4
800077ec:	93ba                	add	t2,t2,a4
800077ee:	0013d713          	srli	a4,t2,0x1
800077f2:	00e37333          	and	t1,t1,a4
800077f6:	87fe                	mv	a5,t6
800077f8:	03c38733          	mul	a4,t2,t3
800077fc:	40e30733          	sub	a4,t1,a4
80007800:	00f39313          	slli	t1,t2,0xf
80007804:	02e3b733          	mulhu	a4,t2,a4
80007808:	8305                	srli	a4,a4,0x1
8000780a:	00e30e33          	add	t3,t1,a4
8000780e:	03fe0333          	mul	t1,t3,t6
80007812:	03fe33b3          	mulhu	t2,t3,t6
80007816:	9f1a                	add	t5,t5,t1
80007818:	006f3733          	sltu	a4,t5,t1
8000781c:	97ba                	add	a5,a5,a4
8000781e:	979e                	add	a5,a5,t2
80007820:	40fe0733          	sub	a4,t3,a5
80007824:	03173333          	mulhu	t1,a4,a7
80007828:	03170733          	mul	a4,a4,a7
8000782c:	00e283b3          	add	t2,t0,a4
80007830:	0053b7b3          	sltu	a5,t2,t0
80007834:	989a                	add	a7,a7,t1
80007836:	00f88333          	add	t1,a7,a5
8000783a:	00130893          	addi	a7,t1,1 # 7f800001 <_flash_size+0x7f700001>
8000783e:	03f887b3          	mul	a5,a7,t6
80007842:	40f287b3          	sub	a5,t0,a5
80007846:	00f3b733          	sltu	a4,t2,a5
8000784a:	40e00733          	neg	a4,a4
8000784e:	01f772b3          	and	t0,a4,t6
80007852:	92be                	add	t0,t0,a5
80007854:	00f3e363          	bltu	t2,a5,8000785a <__udivdi3+0x164>
80007858:	8346                	mv	t1,a7
8000785a:	01f2b733          	sltu	a4,t0,t6
8000785e:	00174713          	xori	a4,a4,1
80007862:	971a                	add	a4,a4,t1
80007864:	01075733          	srl	a4,a4,a6
80007868:	fff70793          	addi	a5,a4,-1
8000786c:	00f73733          	sltu	a4,a4,a5
80007870:	177d                	addi	a4,a4,-1
80007872:	8ff9                	and	a5,a5,a4
80007874:	02f68833          	mul	a6,a3,a5
80007878:	02f638b3          	mulhu	a7,a2,a5
8000787c:	02f60733          	mul	a4,a2,a5
80007880:	9846                	add	a6,a6,a7
80007882:	41058833          	sub	a6,a1,a6
80007886:	00e535b3          	sltu	a1,a0,a4
8000788a:	40b805b3          	sub	a1,a6,a1
8000788e:	12d58163          	beq	a1,a3,800079b0 <__udivdi3+0x2ba>
80007892:	00d5b533          	sltu	a0,a1,a3
80007896:	a205                	j	800079b6 <__udivdi3+0x2c0>
80007898:	10070963          	beqz	a4,800079aa <__udivdi3+0x2b4>
8000789c:	12c77463          	bgeu	a4,a2,800079c4 <__udivdi3+0x2ce>
800078a0:	01065693          	srli	a3,a2,0x10
800078a4:	00155893          	srli	a7,a0,0x1
800078a8:	80008837          	lui	a6,0x80008
800078ac:	be280813          	addi	a6,a6,-1054 # 80007be2 <__SEGGER_RTL_Moeller_inverse_lut>
800078b0:	0016b693          	seqz	a3,a3
800078b4:	0692                	slli	a3,a3,0x4
800078b6:	00d61733          	sll	a4,a2,a3
800078ba:	01875793          	srli	a5,a4,0x18
800078be:	0017b793          	seqz	a5,a5
800078c2:	078e                	slli	a5,a5,0x3
800078c4:	00f71733          	sll	a4,a4,a5
800078c8:	8edd                	or	a3,a3,a5
800078ca:	01c75793          	srli	a5,a4,0x1c
800078ce:	0017b793          	seqz	a5,a5
800078d2:	078a                	slli	a5,a5,0x2
800078d4:	00f71733          	sll	a4,a4,a5
800078d8:	8edd                	or	a3,a3,a5
800078da:	01e75793          	srli	a5,a4,0x1e
800078de:	0017b793          	seqz	a5,a5
800078e2:	0786                	slli	a5,a5,0x1
800078e4:	00f71733          	sll	a4,a4,a5
800078e8:	8edd                	or	a3,a3,a5
800078ea:	fff74713          	not	a4,a4
800078ee:	837d                	srli	a4,a4,0x1f
800078f0:	8ed9                	or	a3,a3,a4
800078f2:	00d59733          	sll	a4,a1,a3
800078f6:	01f6c793          	xori	a5,a3,31
800078fa:	00d512b3          	sll	t0,a0,a3
800078fe:	00d616b3          	sll	a3,a2,a3
80007902:	00f8d633          	srl	a2,a7,a5
80007906:	0016f593          	andi	a1,a3,1
8000790a:	00b6d793          	srli	a5,a3,0xb
8000790e:	0166d513          	srli	a0,a3,0x16
80007912:	0506                	slli	a0,a0,0x1
80007914:	9542                	add	a0,a0,a6
80007916:	c0055503          	lhu	a0,-1024(a0)
8000791a:	0016d813          	srli	a6,a3,0x1
8000791e:	00c768b3          	or	a7,a4,a2
80007922:	0785                	addi	a5,a5,1 # 800001 <_flash_size+0x700001>
80007924:	02a50733          	mul	a4,a0,a0
80007928:	02f73733          	mulhu	a4,a4,a5
8000792c:	87b6                	mv	a5,a3
8000792e:	982e                	add	a6,a6,a1
80007930:	40b005b3          	neg	a1,a1
80007934:	0512                	slli	a0,a0,0x4
80007936:	fff74713          	not	a4,a4
8000793a:	953a                	add	a0,a0,a4
8000793c:	00155713          	srli	a4,a0,0x1
80007940:	8df9                	and	a1,a1,a4
80007942:	8736                	mv	a4,a3
80007944:	03050633          	mul	a2,a0,a6
80007948:	8d91                	sub	a1,a1,a2
8000794a:	00f51613          	slli	a2,a0,0xf
8000794e:	02b53533          	mulhu	a0,a0,a1
80007952:	8105                	srli	a0,a0,0x1
80007954:	9532                	add	a0,a0,a2
80007956:	02d505b3          	mul	a1,a0,a3
8000795a:	02d53633          	mulhu	a2,a0,a3
8000795e:	97ae                	add	a5,a5,a1
80007960:	00b7b5b3          	sltu	a1,a5,a1
80007964:	972e                	add	a4,a4,a1
80007966:	9732                	add	a4,a4,a2
80007968:	8d19                	sub	a0,a0,a4
8000796a:	031535b3          	mulhu	a1,a0,a7
8000796e:	03150533          	mul	a0,a0,a7
80007972:	00a28733          	add	a4,t0,a0
80007976:	00573533          	sltu	a0,a4,t0
8000797a:	95c6                	add	a1,a1,a7
8000797c:	952e                	add	a0,a0,a1
8000797e:	00150613          	addi	a2,a0,1
80007982:	02d605b3          	mul	a1,a2,a3
80007986:	40b287b3          	sub	a5,t0,a1
8000798a:	00f735b3          	sltu	a1,a4,a5
8000798e:	40b005b3          	neg	a1,a1
80007992:	8df5                	and	a1,a1,a3
80007994:	95be                	add	a1,a1,a5
80007996:	00f76363          	bltu	a4,a5,8000799c <__udivdi3+0x2a6>
8000799a:	8532                	mv	a0,a2
8000799c:	4701                	li	a4,0
8000799e:	00d5b5b3          	sltu	a1,a1,a3
800079a2:	0015c693          	xori	a3,a1,1
800079a6:	96aa                	add	a3,a3,a0
800079a8:	a819                	j	800079be <__udivdi3+0x2c8>
800079aa:	02c556b3          	divu	a3,a0,a2
800079ae:	a801                	j	800079be <__udivdi3+0x2c8>
800079b0:	8d19                	sub	a0,a0,a4
800079b2:	00c53533          	sltu	a0,a0,a2
800079b6:	4701                	li	a4,0
800079b8:	00154693          	xori	a3,a0,1
800079bc:	96be                	add	a3,a3,a5
800079be:	8536                	mv	a0,a3
800079c0:	85ba                	mv	a1,a4
800079c2:	8082                	ret
800079c4:	02c758b3          	divu	a7,a4,a2
800079c8:	01065693          	srli	a3,a2,0x10
800079cc:	00155293          	srli	t0,a0,0x1
800079d0:	80008837          	lui	a6,0x80008
800079d4:	be280813          	addi	a6,a6,-1054 # 80007be2 <__SEGGER_RTL_Moeller_inverse_lut>
800079d8:	0016b693          	seqz	a3,a3
800079dc:	02c885b3          	mul	a1,a7,a2
800079e0:	0692                	slli	a3,a3,0x4
800079e2:	8f0d                	sub	a4,a4,a1
800079e4:	00d617b3          	sll	a5,a2,a3
800079e8:	0187d593          	srli	a1,a5,0x18
800079ec:	0015b593          	seqz	a1,a1
800079f0:	058e                	slli	a1,a1,0x3
800079f2:	00b797b3          	sll	a5,a5,a1
800079f6:	8dd5                	or	a1,a1,a3
800079f8:	01c7d693          	srli	a3,a5,0x1c
800079fc:	0016b693          	seqz	a3,a3
80007a00:	068a                	slli	a3,a3,0x2
80007a02:	00d797b3          	sll	a5,a5,a3
80007a06:	8dd5                	or	a1,a1,a3
80007a08:	01e7d693          	srli	a3,a5,0x1e
80007a0c:	0016b693          	seqz	a3,a3
80007a10:	0686                	slli	a3,a3,0x1
80007a12:	00d797b3          	sll	a5,a5,a3
80007a16:	8dd5                	or	a1,a1,a3
80007a18:	fff7c693          	not	a3,a5
80007a1c:	82fd                	srli	a3,a3,0x1f
80007a1e:	8dd5                	or	a1,a1,a3
80007a20:	00b71733          	sll	a4,a4,a1
80007a24:	01f5c793          	xori	a5,a1,31
80007a28:	00b51333          	sll	t1,a0,a1
80007a2c:	00b61633          	sll	a2,a2,a1
80007a30:	00f2d5b3          	srl	a1,t0,a5
80007a34:	00167693          	andi	a3,a2,1
80007a38:	00b65793          	srli	a5,a2,0xb
80007a3c:	01665513          	srli	a0,a2,0x16
80007a40:	0506                	slli	a0,a0,0x1
80007a42:	9542                	add	a0,a0,a6
80007a44:	c0055503          	lhu	a0,-1024(a0)
80007a48:	00165813          	srli	a6,a2,0x1
80007a4c:	00b762b3          	or	t0,a4,a1
80007a50:	0785                	addi	a5,a5,1
80007a52:	02a50733          	mul	a4,a0,a0
80007a56:	02f73733          	mulhu	a4,a4,a5
80007a5a:	87b2                	mv	a5,a2
80007a5c:	9836                	add	a6,a6,a3
80007a5e:	40d006b3          	neg	a3,a3
80007a62:	0512                	slli	a0,a0,0x4
80007a64:	fff74713          	not	a4,a4
80007a68:	953a                	add	a0,a0,a4
80007a6a:	00155713          	srli	a4,a0,0x1
80007a6e:	8ef9                	and	a3,a3,a4
80007a70:	8732                	mv	a4,a2
80007a72:	030505b3          	mul	a1,a0,a6
80007a76:	8e8d                	sub	a3,a3,a1
80007a78:	00f51593          	slli	a1,a0,0xf
80007a7c:	02d53533          	mulhu	a0,a0,a3
80007a80:	8105                	srli	a0,a0,0x1
80007a82:	952e                	add	a0,a0,a1
80007a84:	02c505b3          	mul	a1,a0,a2
80007a88:	02c536b3          	mulhu	a3,a0,a2
80007a8c:	97ae                	add	a5,a5,a1
80007a8e:	00b7b5b3          	sltu	a1,a5,a1
80007a92:	972e                	add	a4,a4,a1
80007a94:	9736                	add	a4,a4,a3
80007a96:	8d19                	sub	a0,a0,a4
80007a98:	025535b3          	mulhu	a1,a0,t0
80007a9c:	02550533          	mul	a0,a0,t0
80007aa0:	00a307b3          	add	a5,t1,a0
80007aa4:	0067b533          	sltu	a0,a5,t1
80007aa8:	9596                	add	a1,a1,t0
80007aaa:	952e                	add	a0,a0,a1
80007aac:	00150713          	addi	a4,a0,1
80007ab0:	02c705b3          	mul	a1,a4,a2
80007ab4:	40b305b3          	sub	a1,t1,a1
80007ab8:	00b7b6b3          	sltu	a3,a5,a1
80007abc:	40d006b3          	neg	a3,a3
80007ac0:	8ef1                	and	a3,a3,a2
80007ac2:	96ae                	add	a3,a3,a1
80007ac4:	00b7e363          	bltu	a5,a1,80007aca <__udivdi3+0x3d4>
80007ac8:	853a                	mv	a0,a4
80007aca:	00c6b5b3          	sltu	a1,a3,a2
80007ace:	0015c693          	xori	a3,a1,1
80007ad2:	96aa                	add	a3,a3,a0
80007ad4:	8746                	mv	a4,a7
80007ad6:	b5e5                	j	800079be <__udivdi3+0x2c8>
80007ad8:	01065793          	srli	a5,a2,0x10
80007adc:	02c5d733          	divu	a4,a1,a2
80007ae0:	8edd                	or	a3,a3,a5
80007ae2:	02c707b3          	mul	a5,a4,a2
80007ae6:	8d9d                	sub	a1,a1,a5
80007ae8:	e6a9                	bnez	a3,80007b32 <__udivdi3+0x43c>
80007aea:	01055693          	srli	a3,a0,0x10
80007aee:	05c2                	slli	a1,a1,0x10
80007af0:	0542                	slli	a0,a0,0x10
80007af2:	8dd5                	or	a1,a1,a3
80007af4:	8141                	srli	a0,a0,0x10
80007af6:	02c5d5b3          	divu	a1,a1,a2
80007afa:	02c587b3          	mul	a5,a1,a2
80007afe:	8e9d                	sub	a3,a3,a5
80007b00:	06c2                	slli	a3,a3,0x10
80007b02:	8d55                	or	a0,a0,a3
80007b04:	02c556b3          	divu	a3,a0,a2
80007b08:	05c2                	slli	a1,a1,0x10
80007b0a:	96ae                	add	a3,a3,a1
80007b0c:	00b6b533          	sltu	a0,a3,a1
80007b10:	972a                	add	a4,a4,a0
80007b12:	b575                	j	800079be <__udivdi3+0x2c8>
80007b14:	468d                	li	a3,3
80007b16:	06d60d63          	beq	a2,a3,80007b90 <__udivdi3+0x49a>
80007b1a:	4681                	li	a3,0
80007b1c:	4791                	li	a5,4
80007b1e:	4701                	li	a4,0
80007b20:	e8f61fe3          	bne	a2,a5,800079be <__udivdi3+0x2c8>
80007b24:	8109                	srli	a0,a0,0x2
80007b26:	01e59693          	slli	a3,a1,0x1e
80007b2a:	8ec9                	or	a3,a3,a0
80007b2c:	0025d713          	srli	a4,a1,0x2
80007b30:	b579                	j	800079be <__udivdi3+0x2c8>
80007b32:	01855813          	srli	a6,a0,0x18
80007b36:	05a2                	slli	a1,a1,0x8
80007b38:	00851793          	slli	a5,a0,0x8
80007b3c:	01051693          	slli	a3,a0,0x10
80007b40:	0ff57893          	zext.b	a7,a0
80007b44:	0105e5b3          	or	a1,a1,a6
80007b48:	83e1                	srli	a5,a5,0x18
80007b4a:	0186d813          	srli	a6,a3,0x18
80007b4e:	02c5d533          	divu	a0,a1,a2
80007b52:	02c506b3          	mul	a3,a0,a2
80007b56:	0562                	slli	a0,a0,0x18
80007b58:	8d95                	sub	a1,a1,a3
80007b5a:	05a2                	slli	a1,a1,0x8
80007b5c:	8ddd                	or	a1,a1,a5
80007b5e:	02c5d6b3          	divu	a3,a1,a2
80007b62:	02c687b3          	mul	a5,a3,a2
80007b66:	06c2                	slli	a3,a3,0x10
80007b68:	8d9d                	sub	a1,a1,a5
80007b6a:	9536                	add	a0,a0,a3
80007b6c:	05a2                	slli	a1,a1,0x8
80007b6e:	0105e5b3          	or	a1,a1,a6
80007b72:	02c5d6b3          	divu	a3,a1,a2
80007b76:	02c687b3          	mul	a5,a3,a2
80007b7a:	06a2                	slli	a3,a3,0x8
80007b7c:	8d9d                	sub	a1,a1,a5
80007b7e:	05a2                	slli	a1,a1,0x8
80007b80:	0115e5b3          	or	a1,a1,a7
80007b84:	02c5d5b3          	divu	a1,a1,a2
80007b88:	9536                	add	a0,a0,a3
80007b8a:	00b506b3          	add	a3,a0,a1
80007b8e:	bd05                	j	800079be <__udivdi3+0x2c8>
80007b90:	555555b7          	lui	a1,0x55555
80007b94:	55558593          	addi	a1,a1,1365 # 55555555 <_flash_size+0x55455555>
80007b98:	02a5b633          	mulhu	a2,a1,a0
80007b9c:	02a58533          	mul	a0,a1,a0
80007ba0:	02e5b6b3          	mulhu	a3,a1,a4
80007ba4:	02e585b3          	mul	a1,a1,a4
80007ba8:	962e                	add	a2,a2,a1
80007baa:	00b635b3          	sltu	a1,a2,a1
80007bae:	9532                	add	a0,a0,a2
80007bb0:	95b6                	add	a1,a1,a3
80007bb2:	00c536b3          	sltu	a3,a0,a2
80007bb6:	96ae                	add	a3,a3,a1
80007bb8:	00d60733          	add	a4,a2,a3
80007bbc:	9536                	add	a0,a0,a3
80007bbe:	00c73633          	sltu	a2,a4,a2
80007bc2:	00d536b3          	sltu	a3,a0,a3
80007bc6:	0505                	addi	a0,a0,1
80007bc8:	95b2                	add	a1,a1,a2
80007bca:	00d70633          	add	a2,a4,a3
80007bce:	00153693          	seqz	a3,a0
80007bd2:	00e63533          	sltu	a0,a2,a4
80007bd6:	96b2                	add	a3,a3,a2
80007bd8:	952e                	add	a0,a0,a1
80007bda:	00c6b733          	sltu	a4,a3,a2
80007bde:	972a                	add	a4,a4,a0
80007be0:	bbf9                	j	800079be <__udivdi3+0x2c8>

Disassembly of section .text.libc.memset:

80007fe2 <memset>:
80007fe2:	872a                	mv	a4,a0
80007fe4:	c22d                	beqz	a2,80008046 <.Lmemset_memset_end>

80007fe6 <.Lmemset_unaligned_byte_set_loop>:
80007fe6:	01e51693          	slli	a3,a0,0x1e
80007fea:	c699                	beqz	a3,80007ff8 <.Lmemset_fast_set>
80007fec:	00b50023          	sb	a1,0(a0)
80007ff0:	0505                	addi	a0,a0,1
80007ff2:	167d                	addi	a2,a2,-1 # ff7fffff <__AHB_SRAM_segment_end__+0xf3f7fff>
80007ff4:	fa6d                	bnez	a2,80007fe6 <.Lmemset_unaligned_byte_set_loop>
80007ff6:	a881                	j	80008046 <.Lmemset_memset_end>

80007ff8 <.Lmemset_fast_set>:
80007ff8:	0ff5f593          	zext.b	a1,a1
80007ffc:	00859693          	slli	a3,a1,0x8
80008000:	8dd5                	or	a1,a1,a3
80008002:	01059693          	slli	a3,a1,0x10
80008006:	8dd5                	or	a1,a1,a3
80008008:	02000693          	li	a3,32
8000800c:	00d66f63          	bltu	a2,a3,8000802a <.Lmemset_word_set>

80008010 <.Lmemset_fast_set_loop>:
80008010:	c10c                	sw	a1,0(a0)
80008012:	c14c                	sw	a1,4(a0)
80008014:	c50c                	sw	a1,8(a0)
80008016:	c54c                	sw	a1,12(a0)
80008018:	c90c                	sw	a1,16(a0)
8000801a:	c94c                	sw	a1,20(a0)
8000801c:	cd0c                	sw	a1,24(a0)
8000801e:	cd4c                	sw	a1,28(a0)
80008020:	9536                	add	a0,a0,a3
80008022:	8e15                	sub	a2,a2,a3
80008024:	fed676e3          	bgeu	a2,a3,80008010 <.Lmemset_fast_set_loop>
80008028:	ce19                	beqz	a2,80008046 <.Lmemset_memset_end>

8000802a <.Lmemset_word_set>:
8000802a:	4691                	li	a3,4
8000802c:	00d66863          	bltu	a2,a3,8000803c <.Lmemset_byte_set_loop>

80008030 <.Lmemset_word_set_loop>:
80008030:	c10c                	sw	a1,0(a0)
80008032:	9536                	add	a0,a0,a3
80008034:	8e15                	sub	a2,a2,a3
80008036:	fed67de3          	bgeu	a2,a3,80008030 <.Lmemset_word_set_loop>
8000803a:	c611                	beqz	a2,80008046 <.Lmemset_memset_end>

8000803c <.Lmemset_byte_set_loop>:
8000803c:	00b50023          	sb	a1,0(a0)
80008040:	0505                	addi	a0,a0,1
80008042:	167d                	addi	a2,a2,-1
80008044:	fe65                	bnez	a2,8000803c <.Lmemset_byte_set_loop>

80008046 <.Lmemset_memset_end>:
80008046:	853a                	mv	a0,a4
80008048:	8082                	ret

Disassembly of section .text.libc.strlen:

8000804a <strlen>:
8000804a:	85aa                	mv	a1,a0
8000804c:	00357693          	andi	a3,a0,3
80008050:	c29d                	beqz	a3,80008076 <.Lstrlen_aligned>
80008052:	00054603          	lbu	a2,0(a0)
80008056:	ce21                	beqz	a2,800080ae <.Lstrlen_done>
80008058:	0505                	addi	a0,a0,1
8000805a:	00357693          	andi	a3,a0,3
8000805e:	ce81                	beqz	a3,80008076 <.Lstrlen_aligned>
80008060:	00054603          	lbu	a2,0(a0)
80008064:	c629                	beqz	a2,800080ae <.Lstrlen_done>
80008066:	0505                	addi	a0,a0,1
80008068:	00357693          	andi	a3,a0,3
8000806c:	c689                	beqz	a3,80008076 <.Lstrlen_aligned>
8000806e:	00054603          	lbu	a2,0(a0)
80008072:	ce15                	beqz	a2,800080ae <.Lstrlen_done>
80008074:	0505                	addi	a0,a0,1

80008076 <.Lstrlen_aligned>:
80008076:	01010637          	lui	a2,0x1010
8000807a:	10160613          	addi	a2,a2,257 # 1010101 <_flash_size+0xf10101>
8000807e:	00761693          	slli	a3,a2,0x7

80008082 <.Lstrlen_wordstrlen>:
80008082:	4118                	lw	a4,0(a0)
80008084:	0511                	addi	a0,a0,4
80008086:	40c707b3          	sub	a5,a4,a2
8000808a:	fff74713          	not	a4,a4
8000808e:	8ff9                	and	a5,a5,a4
80008090:	8ff5                	and	a5,a5,a3
80008092:	dbe5                	beqz	a5,80008082 <.Lstrlen_wordstrlen>
80008094:	1571                	addi	a0,a0,-4
80008096:	01879713          	slli	a4,a5,0x18
8000809a:	eb11                	bnez	a4,800080ae <.Lstrlen_done>
8000809c:	0505                	addi	a0,a0,1
8000809e:	01079713          	slli	a4,a5,0x10
800080a2:	e711                	bnez	a4,800080ae <.Lstrlen_done>
800080a4:	0505                	addi	a0,a0,1
800080a6:	00879713          	slli	a4,a5,0x8
800080aa:	e311                	bnez	a4,800080ae <.Lstrlen_done>
800080ac:	0505                	addi	a0,a0,1

800080ae <.Lstrlen_done>:
800080ae:	8d0d                	sub	a0,a0,a1
800080b0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pow10f:

800080b2 <__SEGGER_RTL_pow10f>:
800080b2:	1101                	addi	sp,sp,-32
800080b4:	ce06                	sw	ra,28(sp)
800080b6:	cc22                	sw	s0,24(sp)
800080b8:	ca26                	sw	s1,20(sp)
800080ba:	c84a                	sw	s2,16(sp)
800080bc:	c64e                	sw	s3,12(sp)
800080be:	892a                	mv	s2,a0
800080c0:	c515                	beqz	a0,800080ec <__SEGGER_RTL_pow10f+0x3a>
800080c2:	41f95513          	srai	a0,s2,0x1f
800080c6:	e0018413          	addi	s0,gp,-512 # 80003690 <__SEGGER_RTL_aPower2f>
800080ca:	00a944b3          	xor	s1,s2,a0
800080ce:	8c89                	sub	s1,s1,a0
800080d0:	3f8009b7          	lui	s3,0x3f800
800080d4:	0014f513          	andi	a0,s1,1
800080d8:	c511                	beqz	a0,800080e4 <__SEGGER_RTL_pow10f+0x32>
800080da:	400c                	lw	a1,0(s0)
800080dc:	854e                	mv	a0,s3
800080de:	92aff0ef          	jal	80007208 <__mulsf3>
800080e2:	89aa                	mv	s3,a0
800080e4:	8085                	srli	s1,s1,0x1
800080e6:	0411                	addi	s0,s0,4
800080e8:	f4f5                	bnez	s1,800080d4 <__SEGGER_RTL_pow10f+0x22>
800080ea:	a019                	j	800080f0 <__SEGGER_RTL_pow10f+0x3e>
800080ec:	3f8009b7          	lui	s3,0x3f800
800080f0:	3f800537          	lui	a0,0x3f800
800080f4:	85ce                	mv	a1,s3
800080f6:	9c2ff0ef          	jal	800072b8 <__divsf3>
800080fa:	00094363          	bltz	s2,80008100 <__SEGGER_RTL_pow10f+0x4e>
800080fe:	854e                	mv	a0,s3
80008100:	40f2                	lw	ra,28(sp)
80008102:	4462                	lw	s0,24(sp)
80008104:	44d2                	lw	s1,20(sp)
80008106:	4942                	lw	s2,16(sp)
80008108:	49b2                	lw	s3,12(sp)
8000810a:	6105                	addi	sp,sp,32
8000810c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_current_locale:

8000810e <__SEGGER_RTL_current_locale>:
8000810e:	00080537          	lui	a0,0x80
80008112:	32c52503          	lw	a0,812(a0) # 8032c <__SEGGER_RTL_locale_ptr>
80008116:	e509                	bnez	a0,80008120 <__SEGGER_RTL_current_locale+0x12>
80008118:	00080537          	lui	a0,0x80
8000811c:	30050513          	addi	a0,a0,768 # 80300 <__RAL_global_locale>
80008120:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_mbtowc:

80008122 <__SEGGER_RTL_ascii_mbtowc>:
80008122:	4701                	li	a4,0
80008124:	c19d                	beqz	a1,8000814a <__SEGGER_RTL_ascii_mbtowc+0x28>
80008126:	c215                	beqz	a2,8000814a <__SEGGER_RTL_ascii_mbtowc+0x28>
80008128:	0005c603          	lbu	a2,0(a1)
8000812c:	01861593          	slli	a1,a2,0x18
80008130:	0005cc63          	bltz	a1,80008148 <__SEGGER_RTL_ascii_mbtowc+0x26>
80008134:	85e1                	srai	a1,a1,0x18
80008136:	c111                	beqz	a0,8000813a <__SEGGER_RTL_ascii_mbtowc+0x18>
80008138:	c110                	sw	a2,0(a0)
8000813a:	0006a023          	sw	zero,0(a3) # 800000 <_flash_size+0x700000>
8000813e:	0006a223          	sw	zero,4(a3)
80008142:	00b03733          	snez	a4,a1
80008146:	a011                	j	8000814a <__SEGGER_RTL_ascii_mbtowc+0x28>
80008148:	5779                	li	a4,-2
8000814a:	853a                	mv	a0,a4
8000814c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_wctomb:

8000814e <__SEGGER_RTL_ascii_wctomb>:
8000814e:	07f00613          	li	a2,127
80008152:	00b67463          	bgeu	a2,a1,8000815a <__SEGGER_RTL_ascii_wctomb+0xc>
80008156:	5579                	li	a0,-2
80008158:	8082                	ret
8000815a:	00b50023          	sb	a1,0(a0)
8000815e:	4505                	li	a0,1
80008160:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_isctype:

80008162 <__SEGGER_RTL_ascii_isctype>:
80008162:	07f00613          	li	a2,127
80008166:	02a66263          	bltu	a2,a0,8000818a <__SEGGER_RTL_ascii_isctype+0x28>
8000816a:	80008637          	lui	a2,0x80008
8000816e:	32860613          	addi	a2,a2,808 # 80008328 <__SEGGER_RTL_ascii_ctype_map>
80008172:	9532                	add	a0,a0,a2
80008174:	80008637          	lui	a2,0x80008
80008178:	2f360613          	addi	a2,a2,755 # 800082f3 <__SEGGER_RTL_ascii_ctype_mask>
8000817c:	95b2                	add	a1,a1,a2
8000817e:	00054503          	lbu	a0,0(a0)
80008182:	0005c583          	lbu	a1,0(a1)
80008186:	8d6d                	and	a0,a0,a1
80008188:	8082                	ret
8000818a:	4501                	li	a0,0
8000818c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_iswctype:

8000818e <__SEGGER_RTL_ascii_iswctype>:
8000818e:	07f00613          	li	a2,127
80008192:	02a66263          	bltu	a2,a0,800081b6 <__SEGGER_RTL_ascii_iswctype+0x28>
80008196:	80008637          	lui	a2,0x80008
8000819a:	32860613          	addi	a2,a2,808 # 80008328 <__SEGGER_RTL_ascii_ctype_map>
8000819e:	9532                	add	a0,a0,a2
800081a0:	80008637          	lui	a2,0x80008
800081a4:	2f360613          	addi	a2,a2,755 # 800082f3 <__SEGGER_RTL_ascii_ctype_mask>
800081a8:	95b2                	add	a1,a1,a2
800081aa:	00054503          	lbu	a0,0(a0)
800081ae:	0005c583          	lbu	a1,0(a1)
800081b2:	8d6d                	and	a0,a0,a1
800081b4:	8082                	ret
800081b6:	4501                	li	a0,0
800081b8:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_zero:

80008854 <__SEGGER_init_zero>:
80008854:	4008                	lw	a0,0(s0)
80008856:	404c                	lw	a1,4(s0)
80008858:	0421                	addi	s0,s0,8
8000885a:	c591                	beqz	a1,80008866 <.L__SEGGER_init_zero_Done>

8000885c <.L__SEGGER_init_zero_Loop>:
8000885c:	00050023          	sb	zero,0(a0)
80008860:	0505                	addi	a0,a0,1
80008862:	15fd                	addi	a1,a1,-1
80008864:	fde5                	bnez	a1,8000885c <.L__SEGGER_init_zero_Loop>

80008866 <.L__SEGGER_init_zero_Done>:
80008866:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_copy:

80008868 <__SEGGER_init_copy>:
80008868:	4008                	lw	a0,0(s0)
8000886a:	404c                	lw	a1,4(s0)
8000886c:	4410                	lw	a2,8(s0)
8000886e:	0431                	addi	s0,s0,12
80008870:	ca09                	beqz	a2,80008882 <.L__SEGGER_init_copy_Done>

80008872 <.L__SEGGER_init_copy_Loop>:
80008872:	00058683          	lb	a3,0(a1)
80008876:	00d50023          	sb	a3,0(a0)
8000887a:	0505                	addi	a0,a0,1
8000887c:	0585                	addi	a1,a1,1
8000887e:	167d                	addi	a2,a2,-1
80008880:	fa6d                	bnez	a2,80008872 <.L__SEGGER_init_copy_Loop>

80008882 <.L__SEGGER_init_copy_Done>:
80008882:	8082                	ret
