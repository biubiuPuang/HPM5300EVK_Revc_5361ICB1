
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
80003008:	80008237          	lui	tp,0x80008
        addi    tp, tp, %lo(__thread_pointer$)
8000300c:	2e020213          	addi	tp,tp,736 # 800082e0 <__thread_pointer$>
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
80003020:	56b000ef          	jal	80003d8a <l1c_ic_enable>
#endif
#ifdef CONFIG_NOT_ENABLE_DCACHE
        call    l1c_dc_invalidate_all
        call    l1c_dc_disable
#else
        call    l1c_dc_enable
80003024:	533000ef          	jal	80003d56 <l1c_dc_enable>
        call    l1c_dc_invalidate_all
80003028:	1ba030ef          	jal	800061e2 <l1c_dc_invalidate_all>

#ifndef __NO_SYSTEM_INIT
        //
        // Call _init
        //
        call    _init
8000302c:	477020ef          	jal	80005ca2 <_init>

80003030 <.Lpcrel_hi0>:
        // Call linker init functions which in turn performs the following:
        // * Perform segment init
        // * Perform heap init (if used)
        // * Call constructors of global Objects (if any exist)
        //
        la      s0, __SEGGER_init_table__       // Set table pointer to start of initialization table
80003030:	80008437          	lui	s0,0x80008
80003034:	d7c40413          	addi	s0,s0,-644 # 80007d7c <__SEGGER_RTL_ascii_ctype_map+0x82>

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
80003040:	2fc9                	jal	80003812 <_clean_up>

80003042 <.Lpcrel_hi1>:
    #define HANDLER_S_TRAP irq_handler_s_trap
#endif

#if !defined(USE_NONVECTOR_MODE) || (USE_NONVECTOR_MODE == 0)
    /* Initial machine trap-vector Base */
    la t0, __vector_table
80003042:	000002b7          	lui	t0,0x0
80003046:	00028293          	mv	t0,t0
    csrw mtvec, t0
8000304a:	30529073          	csrw	mtvec,t0

    /* Enable vectored external PLIC interrupt */
    csrsi CSR_MMISC_CTL, 2
8000304e:	7d016073          	csrsi	0x7d0,2

80003052 <start>:
        //
        // In a real embedded application ("Free-standing environment"),
        // main() does not get any arguments,
        // which means it is not necessary to init a0 and a1.
        //
        call    APP_ENTRY_POINT
80003052:	439020ef          	jal	80005c8a <reset_handler>
        tail    exit
80003056:	a009                	j	80003058 <exit>

80003058 <exit>:
MARK_FUNC exit
        //
        // In a free-standing environment, if returned from application:
        // Loop forever.
        //
        j       .
80003058:	a001                	j	80003058 <exit>
        la      a1, args
        call    debug_getargs
        li      a0, ARGSSPACE
        la      a1, args
#else
        li      a0, 0
8000305a:	4501                	li	a0,0
        li      a1, 0
8000305c:	4581                	li	a1,0
#endif

        call    APP_ENTRY_POINT
8000305e:	42d020ef          	jal	80005c8a <reset_handler>
        tail    exit
80003062:	bfdd                	j	80003058 <exit>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_DFL:

80003066 <__SEGGER_RTL_SIGNAL_SIG_DFL>:
80003066:	8082                	ret

Disassembly of section .text.main:

80003804 <main>:
 */

#include "board.h"

int main(void)
{
80003804:	1141                	addi	sp,sp,-16
80003806:	c606                	sw	ra,12(sp)
    board_init();
80003808:	341020ef          	jal	80006348 <board_init>

8000380c <.L2>:

    while (1);
8000380c:	a001                	j	8000380c <.L2>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_ERR:

8000380e <__SEGGER_RTL_SIGNAL_SIG_ERR>:
8000380e:	8082                	ret

Disassembly of section .text._clean_up:

80003812 <_clean_up>:
#define MAIN_ENTRY main
#endif
extern int MAIN_ENTRY(void);

__attribute__((weak)) void _clean_up(void)
{
80003812:	7139                	addi	sp,sp,-64

80003814 <.LBB18>:
 * @brief   Disable IRQ from interrupt controller
 *
 */
ATTR_ALWAYS_INLINE static inline void disable_irq_from_intc(void)
{
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80003814:	28b01793          	bseti	a5,zero,0xb
80003818:	3047b073          	csrc	mie,a5
}
8000381c:	0001                	nop
8000381e:	da02                	sw	zero,52(sp)
80003820:	d802                	sw	zero,48(sp)
80003822:	e40007b7          	lui	a5,0xe4000
80003826:	d63e                	sw	a5,44(sp)
80003828:	57d2                	lw	a5,52(sp)
8000382a:	d43e                	sw	a5,40(sp)
8000382c:	57c2                	lw	a5,48(sp)
8000382e:	d23e                	sw	a5,36(sp)

80003830 <.LBB20>:
                                                           uint32_t target,
                                                           uint32_t threshold)
{
    volatile uint32_t *threshold_ptr = (volatile uint32_t *) (base +
                                                              HPM_PLIC_THRESHOLD_OFFSET +
                                                              (target << HPM_PLIC_THRESHOLD_SHIFT_PER_TARGET));
80003830:	57a2                	lw	a5,40(sp)
80003832:	00c79713          	slli	a4,a5,0xc
                                                              HPM_PLIC_THRESHOLD_OFFSET +
80003836:	57b2                	lw	a5,44(sp)
80003838:	973e                	add	a4,a4,a5
8000383a:	002007b7          	lui	a5,0x200
8000383e:	97ba                	add	a5,a5,a4
    volatile uint32_t *threshold_ptr = (volatile uint32_t *) (base +
80003840:	d03e                	sw	a5,32(sp)
    *threshold_ptr = threshold;
80003842:	5782                	lw	a5,32(sp)
80003844:	5712                	lw	a4,36(sp)
80003846:	c398                	sw	a4,0(a5)
}
80003848:	0001                	nop

8000384a <.LBE22>:
 * @param[in] threshold Threshold of IRQ can be serviced
 */
ATTR_ALWAYS_INLINE static inline void intc_set_threshold(uint32_t target, uint32_t threshold)
{
    __plic_set_threshold(HPM_PLIC_BASE, target, threshold);
}
8000384a:	0001                	nop

8000384c <.LBB24>:
    /* clean up plic, it will help while debugging */
    disable_irq_from_intc();
    intc_m_set_threshold(0);
    for (uint32_t irq = 0; irq < 128; irq++) {
8000384c:	de02                	sw	zero,60(sp)
8000384e:	a82d                	j	80003888 <.L2>

80003850 <.L3>:
80003850:	ce02                	sw	zero,28(sp)
80003852:	57f2                	lw	a5,60(sp)
80003854:	cc3e                	sw	a5,24(sp)
80003856:	e40007b7          	lui	a5,0xe4000
8000385a:	ca3e                	sw	a5,20(sp)
8000385c:	47f2                	lw	a5,28(sp)
8000385e:	c83e                	sw	a5,16(sp)
80003860:	47e2                	lw	a5,24(sp)
80003862:	c63e                	sw	a5,12(sp)

80003864 <.LBB25>:
                                                          uint32_t target,
                                                          uint32_t irq)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *) (base +
                                                           HPM_PLIC_CLAIM_OFFSET +
                                                           (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
80003864:	47c2                	lw	a5,16(sp)
80003866:	00c79713          	slli	a4,a5,0xc
                                                           HPM_PLIC_CLAIM_OFFSET +
8000386a:	47d2                	lw	a5,20(sp)
8000386c:	973e                	add	a4,a4,a5
8000386e:	002007b7          	lui	a5,0x200
80003872:	0791                	addi	a5,a5,4 # 200004 <_flash_size+0x100004>
80003874:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *) (base +
80003876:	c43e                	sw	a5,8(sp)
    *claim_addr = irq;
80003878:	47a2                	lw	a5,8(sp)
8000387a:	4732                	lw	a4,12(sp)
8000387c:	c398                	sw	a4,0(a5)
}
8000387e:	0001                	nop

80003880 <.LBE27>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_complete_irq(uint32_t target, uint32_t irq)
{
    __plic_complete_irq(HPM_PLIC_BASE, target, irq);
}
80003880:	0001                	nop

80003882 <.LBE25>:
80003882:	57f2                	lw	a5,60(sp)
80003884:	0785                	addi	a5,a5,1
80003886:	de3e                	sw	a5,60(sp)

80003888 <.L2>:
80003888:	5772                	lw	a4,60(sp)
8000388a:	07f00793          	li	a5,127
8000388e:	fce7f1e3          	bgeu	a5,a4,80003850 <.L3>

80003892 <.LBB29>:
        intc_m_complete_irq(irq);
    }
    /* clear any bits left in plic enable register */
    for (uint32_t i = 0; i < 4; i++) {
80003892:	dc02                	sw	zero,56(sp)
80003894:	a821                	j	800038ac <.L4>

80003896 <.L5>:
        *(volatile uint32_t *)(HPM_PLIC_BASE + HPM_PLIC_ENABLE_OFFSET + (i << 2)) = 0;
80003896:	57e2                	lw	a5,56(sp)
80003898:	00279713          	slli	a4,a5,0x2
8000389c:	e40027b7          	lui	a5,0xe4002
800038a0:	97ba                	add	a5,a5,a4
800038a2:	0007a023          	sw	zero,0(a5) # e4002000 <__FLASH_segment_end__+0x63f02000>
    for (uint32_t i = 0; i < 4; i++) {
800038a6:	57e2                	lw	a5,56(sp)
800038a8:	0785                	addi	a5,a5,1
800038aa:	dc3e                	sw	a5,56(sp)

800038ac <.L4>:
800038ac:	5762                	lw	a4,56(sp)
800038ae:	478d                	li	a5,3
800038b0:	fee7f3e3          	bgeu	a5,a4,80003896 <.L5>

800038b4 <.LBE29>:
    }
}
800038b4:	0001                	nop
800038b6:	0001                	nop
800038b8:	6121                	addi	sp,sp,64
800038ba:	8082                	ret

Disassembly of section .text.syscall_handler:

80003950 <syscall_handler>:
__attribute__((weak)) void swi_isr(void)
{
}

__attribute__((weak)) void syscall_handler(long n, long a0, long a1, long a2, long a3)
{
80003950:	1101                	addi	sp,sp,-32
80003952:	ce2a                	sw	a0,28(sp)
80003954:	cc2e                	sw	a1,24(sp)
80003956:	ca32                	sw	a2,20(sp)
80003958:	c836                	sw	a3,16(sp)
8000395a:	c63a                	sw	a4,12(sp)
    (void) n;
    (void) a0;
    (void) a1;
    (void) a2;
    (void) a3;
}
8000395c:	0001                	nop
8000395e:	6105                	addi	sp,sp,32
80003960:	8082                	ret

Disassembly of section .text.system_init:

80003962 <system_init>:
#endif
    __plic_set_feature(HPM_PLIC_BASE, plic_feature);
}

__attribute__((weak)) void system_init(void)
{
80003962:	7179                	addi	sp,sp,-48
80003964:	d606                	sw	ra,44(sp)

80003966 <.LBB16>:
#ifndef CONFIG_NOT_ENALBE_ACCESS_TO_CYCLE_CSR
    uint32_t mcounteren = read_csr(CSR_MCOUNTEREN);
80003966:	306027f3          	csrr	a5,mcounteren
8000396a:	ce3e                	sw	a5,28(sp)
8000396c:	47f2                	lw	a5,28(sp)

8000396e <.LBE16>:
8000396e:	cc3e                	sw	a5,24(sp)
    write_csr(CSR_MCOUNTEREN, mcounteren | 1); /* Enable MCYCLE */
80003970:	47e2                	lw	a5,24(sp)
80003972:	0017e793          	ori	a5,a5,1
80003976:	30679073          	csrw	mcounteren,a5
8000397a:	47a1                	li	a5,8
8000397c:	c83e                	sw	a5,16(sp)

8000397e <.LBB17>:
    return read_clear_csr(CSR_MSTATUS, mask);
8000397e:	c602                	sw	zero,12(sp)
80003980:	47c2                	lw	a5,16(sp)
80003982:	3007b7f3          	csrrc	a5,mstatus,a5
80003986:	c63e                	sw	a5,12(sp)
80003988:	47b2                	lw	a5,12(sp)

8000398a <.LBE19>:
8000398a:	0001                	nop

8000398c <.LBB20>:
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
8000398c:	28b01793          	bseti	a5,zero,0xb
80003990:	3047b073          	csrc	mie,a5
}
80003994:	0001                	nop

80003996 <.LBE20>:
#endif

    disable_global_irq(CSR_MSTATUS_MIE_MASK);
    disable_irq_from_intc();

    enable_plic_feature();
80003996:	340020ef          	jal	80005cd6 <enable_plic_feature>

8000399a <.LBB22>:
    set_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
8000399a:	28b01793          	bseti	a5,zero,0xb
8000399e:	3047a073          	csrs	mie,a5
}
800039a2:	0001                	nop
800039a4:	47a1                	li	a5,8
800039a6:	ca3e                	sw	a5,20(sp)

800039a8 <.LBB24>:
    set_csr(CSR_MSTATUS, mask);
800039a8:	47d2                	lw	a5,20(sp)
800039aa:	3007a073          	csrs	mstatus,a5
}
800039ae:	0001                	nop

800039b0 <.LBE24>:
    enable_irq_from_intc();

#if !CONFIG_DISABLE_GLOBAL_IRQ_ON_STARTUP
    enable_global_irq(CSR_MSTATUS_MIE_MASK);
#endif
}
800039b0:	0001                	nop
800039b2:	50b2                	lw	ra,44(sp)
800039b4:	6145                	addi	sp,sp,48
800039b6:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

800039b8 <sysctl_resource_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] resource target resource index
 * @return true if target resource is busy
 */
static inline bool sysctl_resource_target_is_busy(SYSCTL_Type *ptr, sysctl_resource_t resource)
{
800039b8:	1141                	addi	sp,sp,-16
800039ba:	c62a                	sw	a0,12(sp)
800039bc:	87ae                	mv	a5,a1
800039be:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
800039c2:	00a15783          	lhu	a5,10(sp)
800039c6:	4732                	lw	a4,12(sp)
800039c8:	078a                	slli	a5,a5,0x2
800039ca:	97ba                	add	a5,a5,a4
800039cc:	4398                	lw	a4,0(a5)
800039ce:	400007b7          	lui	a5,0x40000
800039d2:	8ff9                	and	a5,a5,a4
800039d4:	00f037b3          	snez	a5,a5
800039d8:	0ff7f793          	zext.b	a5,a5
}
800039dc:	853e                	mv	a0,a5
800039de:	0141                	addi	sp,sp,16
800039e0:	8082                	ret

Disassembly of section .text.sysctl_cpu_clock_any_is_busy:

800039e2 <sysctl_cpu_clock_any_is_busy>:
 *
 * @param[in] ptr SYSCTL_Type base address
 * @return true if any clock is busy
 */
static inline bool sysctl_cpu_clock_any_is_busy(SYSCTL_Type *ptr)
{
800039e2:	1141                	addi	sp,sp,-16
800039e4:	c62a                	sw	a0,12(sp)
    return ptr->CLOCK_CPU[0] & SYSCTL_CLOCK_CPU_GLB_BUSY_MASK;
800039e6:	4732                	lw	a4,12(sp)
800039e8:	6789                	lui	a5,0x2
800039ea:	97ba                	add	a5,a5,a4
800039ec:	8007a703          	lw	a4,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
800039f0:	800007b7          	lui	a5,0x80000
800039f4:	8ff9                	and	a5,a5,a4
800039f6:	00f037b3          	snez	a5,a5
800039fa:	0ff7f793          	zext.b	a5,a5
}
800039fe:	853e                	mv	a0,a5
80003a00:	0141                	addi	sp,sp,16
80003a02:	8082                	ret

Disassembly of section .text.sysctl_clock_target_is_busy:

80003a04 <sysctl_clock_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] clock target clock
 * @return true if target clock is busy
 */
static inline bool sysctl_clock_target_is_busy(SYSCTL_Type *ptr, clock_node_t clock)
{
80003a04:	1141                	addi	sp,sp,-16
80003a06:	c62a                	sw	a0,12(sp)
80003a08:	87ae                	mv	a5,a1
80003a0a:	00f105a3          	sb	a5,11(sp)
    return ptr->CLOCK[clock] & SYSCTL_CLOCK_LOC_BUSY_MASK;
80003a0e:	00b14783          	lbu	a5,11(sp)
80003a12:	4732                	lw	a4,12(sp)
80003a14:	60078793          	addi	a5,a5,1536 # 80000600 <__NOR_CFG_OPTION_segment_used_end__+0x1f0>
80003a18:	078a                	slli	a5,a5,0x2
80003a1a:	97ba                	add	a5,a5,a4
80003a1c:	43d8                	lw	a4,4(a5)
80003a1e:	400007b7          	lui	a5,0x40000
80003a22:	8ff9                	and	a5,a5,a4
80003a24:	00f037b3          	snez	a5,a5
80003a28:	0ff7f793          	zext.b	a5,a5
}
80003a2c:	853e                	mv	a0,a5
80003a2e:	0141                	addi	sp,sp,16
80003a30:	8082                	ret

Disassembly of section .text.sysctl_config_clock:

80003a32 <sysctl_config_clock>:
    }
    return status_success;
}

hpm_stat_t sysctl_config_clock(SYSCTL_Type *ptr, clock_node_t node, clock_source_t source, uint32_t divide_by)
{
80003a32:	1101                	addi	sp,sp,-32
80003a34:	ce06                	sw	ra,28(sp)
80003a36:	c62a                	sw	a0,12(sp)
80003a38:	87ae                	mv	a5,a1
80003a3a:	8732                	mv	a4,a2
80003a3c:	c236                	sw	a3,4(sp)
80003a3e:	00f105a3          	sb	a5,11(sp)
80003a42:	87ba                	mv	a5,a4
80003a44:	00f10523          	sb	a5,10(sp)
    if (node >= clock_node_adc_start) {
80003a48:	00b14703          	lbu	a4,11(sp)
80003a4c:	02300793          	li	a5,35
80003a50:	00e7f463          	bgeu	a5,a4,80003a58 <.L81>
        return status_invalid_argument;
80003a54:	4789                	li	a5,2
80003a56:	a8b1                	j	80003ab2 <.L82>

80003a58 <.L81>:
    }

    if (source >= clock_source_general_source_end) {
80003a58:	00a14703          	lbu	a4,10(sp)
80003a5c:	479d                	li	a5,7
80003a5e:	00e7f463          	bgeu	a5,a4,80003a66 <.L83>
        return status_invalid_argument;
80003a62:	4789                	li	a5,2
80003a64:	a0b9                	j	80003ab2 <.L82>

80003a66 <.L83>:
    }
    ptr->CLOCK[node] = (ptr->CLOCK[node] & ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK)) |
80003a66:	00b14783          	lbu	a5,11(sp)
80003a6a:	4732                	lw	a4,12(sp)
80003a6c:	60078793          	addi	a5,a5,1536 # 40000600 <_flash_size+0x3ff00600>
80003a70:	078a                	slli	a5,a5,0x2
80003a72:	97ba                	add	a5,a5,a4
80003a74:	43dc                	lw	a5,4(a5)
80003a76:	8007f693          	andi	a3,a5,-2048
        (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
80003a7a:	00a14783          	lbu	a5,10(sp)
80003a7e:	07a2                	slli	a5,a5,0x8
80003a80:	7007f713          	andi	a4,a5,1792
80003a84:	4792                	lw	a5,4(sp)
80003a86:	17fd                	addi	a5,a5,-1
80003a88:	0ff7f793          	zext.b	a5,a5
80003a8c:	8f5d                	or	a4,a4,a5
    ptr->CLOCK[node] = (ptr->CLOCK[node] & ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK)) |
80003a8e:	00b14783          	lbu	a5,11(sp)
80003a92:	8f55                	or	a4,a4,a3
80003a94:	46b2                	lw	a3,12(sp)
80003a96:	60078793          	addi	a5,a5,1536
80003a9a:	078a                	slli	a5,a5,0x2
80003a9c:	97b6                	add	a5,a5,a3
80003a9e:	c3d8                	sw	a4,4(a5)
    while (sysctl_clock_target_is_busy(ptr, node)) {
80003aa0:	0001                	nop

80003aa2 <.L84>:
80003aa2:	00b14783          	lbu	a5,11(sp)
80003aa6:	85be                	mv	a1,a5
80003aa8:	4532                	lw	a0,12(sp)
80003aaa:	3fa9                	jal	80003a04 <sysctl_clock_target_is_busy>
80003aac:	87aa                	mv	a5,a0
80003aae:	fbf5                	bnez	a5,80003aa2 <.L84>
    }
    return status_success;
80003ab0:	4781                	li	a5,0

80003ab2 <.L82>:
}
80003ab2:	853e                	mv	a0,a5
80003ab4:	40f2                	lw	ra,28(sp)
80003ab6:	6105                	addi	sp,sp,32
80003ab8:	8082                	ret

Disassembly of section .text.get_frequency_for_source:

80003aba <get_frequency_for_source>:
    }
    return clk_freq;
}

uint32_t get_frequency_for_source(clock_source_t source)
{
80003aba:	7179                	addi	sp,sp,-48
80003abc:	d606                	sw	ra,44(sp)
80003abe:	87aa                	mv	a5,a0
80003ac0:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80003ac4:	ce02                	sw	zero,28(sp)
    switch (source) {
80003ac6:	00f14783          	lbu	a5,15(sp)
80003aca:	471d                	li	a4,7
80003acc:	08f76763          	bltu	a4,a5,80003b5a <.L30>
80003ad0:	00279713          	slli	a4,a5,0x2
80003ad4:	8f018793          	addi	a5,gp,-1808 # 80003180 <.L32>
80003ad8:	97ba                	add	a5,a5,a4
80003ada:	439c                	lw	a5,0(a5)
80003adc:	8782                	jr	a5

80003ade <.L39>:
    case clock_source_osc0_clk0:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
80003ade:	016e37b7          	lui	a5,0x16e3
80003ae2:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80003ae6:	ce3e                	sw	a5,28(sp)
        break;
80003ae8:	a89d                	j	80003b5e <.L40>

80003aea <.L38>:
    case clock_source_pll0_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk0);
80003aea:	4601                	li	a2,0
80003aec:	4581                	li	a1,0
80003aee:	f40c0537          	lui	a0,0xf40c0
80003af2:	5a3020ef          	jal	80006894 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003af6:	ce2a                	sw	a0,28(sp)
        break;
80003af8:	a09d                	j	80003b5e <.L40>

80003afa <.L37>:
    case clock_source_pll0_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk1);
80003afa:	4605                	li	a2,1
80003afc:	4581                	li	a1,0
80003afe:	f40c0537          	lui	a0,0xf40c0
80003b02:	593020ef          	jal	80006894 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003b06:	ce2a                	sw	a0,28(sp)
        break;
80003b08:	a899                	j	80003b5e <.L40>

80003b0a <.L36>:
    case clock_source_pll0_clk2:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk2);
80003b0a:	4609                	li	a2,2
80003b0c:	4581                	li	a1,0
80003b0e:	f40c0537          	lui	a0,0xf40c0
80003b12:	583020ef          	jal	80006894 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003b16:	ce2a                	sw	a0,28(sp)
        break;
80003b18:	a099                	j	80003b5e <.L40>

80003b1a <.L35>:
    case clock_source_pll1_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk0);
80003b1a:	4601                	li	a2,0
80003b1c:	4585                	li	a1,1
80003b1e:	f40c0537          	lui	a0,0xf40c0
80003b22:	573020ef          	jal	80006894 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003b26:	ce2a                	sw	a0,28(sp)
        break;
80003b28:	a81d                	j	80003b5e <.L40>

80003b2a <.L34>:
    case clock_source_pll1_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk1);
80003b2a:	4605                	li	a2,1
80003b2c:	4585                	li	a1,1
80003b2e:	f40c0537          	lui	a0,0xf40c0
80003b32:	563020ef          	jal	80006894 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003b36:	ce2a                	sw	a0,28(sp)
        break;
80003b38:	a01d                	j	80003b5e <.L40>

80003b3a <.L33>:
    case clock_source_pll1_clk2:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk2);
80003b3a:	4609                	li	a2,2
80003b3c:	4585                	li	a1,1
80003b3e:	f40c0537          	lui	a0,0xf40c0
80003b42:	553020ef          	jal	80006894 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003b46:	ce2a                	sw	a0,28(sp)
        break;
80003b48:	a819                	j	80003b5e <.L40>

80003b4a <.L31>:
    case clock_source_pll1_clk3:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk3);
80003b4a:	460d                	li	a2,3
80003b4c:	4585                	li	a1,1
80003b4e:	f40c0537          	lui	a0,0xf40c0
80003b52:	543020ef          	jal	80006894 <pllctlv2_get_pll_postdiv_freq_in_hz>
80003b56:	ce2a                	sw	a0,28(sp)
        break;
80003b58:	a019                	j	80003b5e <.L40>

80003b5a <.L30>:
    default:
        clk_freq = 0UL;
80003b5a:	ce02                	sw	zero,28(sp)
        break;
80003b5c:	0001                	nop

80003b5e <.L40>:
    }

    return clk_freq;
80003b5e:	47f2                	lw	a5,28(sp)
}
80003b60:	853e                	mv	a0,a5
80003b62:	50b2                	lw	ra,44(sp)
80003b64:	6145                	addi	sp,sp,48
80003b66:	8082                	ret

Disassembly of section .text.get_frequency_for_ip_in_common_group:

80003b68 <get_frequency_for_ip_in_common_group>:

static uint32_t get_frequency_for_ip_in_common_group(clock_node_t node)
{
80003b68:	7139                	addi	sp,sp,-64
80003b6a:	de06                	sw	ra,60(sp)
80003b6c:	87aa                	mv	a5,a0
80003b6e:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80003b72:	d602                	sw	zero,44(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(node);
80003b74:	00f14783          	lbu	a5,15(sp)
80003b78:	d43e                	sw	a5,40(sp)

    if (node_or_instance < clock_node_end) {
80003b7a:	5722                	lw	a4,40(sp)
80003b7c:	02700793          	li	a5,39
80003b80:	04e7e563          	bltu	a5,a4,80003bca <.L43>

80003b84 <.LBB6>:
        uint32_t clk_node = (uint32_t) node_or_instance;
80003b84:	57a2                	lw	a5,40(sp)
80003b86:	d23e                	sw	a5,36(sp)

        uint32_t clk_div = 1UL + SYSCTL_CLOCK_DIV_GET(HPM_SYSCTL->CLOCK[clk_node]);
80003b88:	f4000737          	lui	a4,0xf4000
80003b8c:	5792                	lw	a5,36(sp)
80003b8e:	60078793          	addi	a5,a5,1536
80003b92:	078a                	slli	a5,a5,0x2
80003b94:	97ba                	add	a5,a5,a4
80003b96:	43dc                	lw	a5,4(a5)
80003b98:	0ff7f793          	zext.b	a5,a5
80003b9c:	0785                	addi	a5,a5,1
80003b9e:	d03e                	sw	a5,32(sp)
        clock_source_t clk_mux = (clock_source_t) SYSCTL_CLOCK_MUX_GET(HPM_SYSCTL->CLOCK[clk_node]);
80003ba0:	f4000737          	lui	a4,0xf4000
80003ba4:	5792                	lw	a5,36(sp)
80003ba6:	60078793          	addi	a5,a5,1536
80003baa:	078a                	slli	a5,a5,0x2
80003bac:	97ba                	add	a5,a5,a4
80003bae:	43dc                	lw	a5,4(a5)
80003bb0:	83a1                	srli	a5,a5,0x8
80003bb2:	8b9d                	andi	a5,a5,7
80003bb4:	00f10fa3          	sb	a5,31(sp)
        clk_freq = get_frequency_for_source(clk_mux) / clk_div;
80003bb8:	01f14783          	lbu	a5,31(sp)
80003bbc:	853e                	mv	a0,a5
80003bbe:	3df5                	jal	80003aba <get_frequency_for_source>
80003bc0:	872a                	mv	a4,a0
80003bc2:	5782                	lw	a5,32(sp)
80003bc4:	02f757b3          	divu	a5,a4,a5
80003bc8:	d63e                	sw	a5,44(sp)

80003bca <.L43>:
    }
    return clk_freq;
80003bca:	57b2                	lw	a5,44(sp)
}
80003bcc:	853e                	mv	a0,a5
80003bce:	50f2                	lw	ra,60(sp)
80003bd0:	6121                	addi	sp,sp,64
80003bd2:	8082                	ret

Disassembly of section .text.get_frequency_for_adc:

80003bd4 <get_frequency_for_adc>:

static uint32_t get_frequency_for_adc(uint32_t clk_src_type, uint32_t instance)
{
80003bd4:	7179                	addi	sp,sp,-48
80003bd6:	d606                	sw	ra,44(sp)
80003bd8:	c62a                	sw	a0,12(sp)
80003bda:	c42e                	sw	a1,8(sp)
    uint32_t clk_freq = 0UL;
80003bdc:	ce02                	sw	zero,28(sp)
    bool is_mux_valid = false;
80003bde:	00010da3          	sb	zero,27(sp)
    clock_node_t node = clock_node_end;
80003be2:	02800793          	li	a5,40
80003be6:	00f10d23          	sb	a5,26(sp)
    uint32_t adc_index = instance;
80003bea:	47a2                	lw	a5,8(sp)
80003bec:	ca3e                	sw	a5,20(sp)

    (void) clk_src_type;

    if (adc_index < ADC_INSTANCE_NUM) {
80003bee:	4752                	lw	a4,20(sp)
80003bf0:	4785                	li	a5,1
80003bf2:	02e7ee63          	bltu	a5,a4,80003c2e <.L46>

80003bf6 <.LBB7>:
        uint32_t mux_in_reg = SYSCTL_ADCCLK_MUX_GET(HPM_SYSCTL->ADCCLK[adc_index]);
80003bf6:	f4000737          	lui	a4,0xf4000
80003bfa:	47d2                	lw	a5,20(sp)
80003bfc:	70078793          	addi	a5,a5,1792
80003c00:	078a                	slli	a5,a5,0x2
80003c02:	97ba                	add	a5,a5,a4
80003c04:	439c                	lw	a5,0(a5)
80003c06:	83a1                	srli	a5,a5,0x8
80003c08:	8b85                	andi	a5,a5,1
80003c0a:	c83e                	sw	a5,16(sp)
        if (mux_in_reg < ARRAY_SIZE(s_adc_clk_mux_node)) {
80003c0c:	4742                	lw	a4,16(sp)
80003c0e:	4785                	li	a5,1
80003c10:	00e7ef63          	bltu	a5,a4,80003c2e <.L46>
            node = s_adc_clk_mux_node[mux_in_reg];
80003c14:	800037b7          	lui	a5,0x80003
80003c18:	06478713          	addi	a4,a5,100 # 80003064 <s_adc_clk_mux_node>
80003c1c:	47c2                	lw	a5,16(sp)
80003c1e:	97ba                	add	a5,a5,a4
80003c20:	0007c783          	lbu	a5,0(a5)
80003c24:	00f10d23          	sb	a5,26(sp)
            is_mux_valid = true;
80003c28:	4785                	li	a5,1
80003c2a:	00f10da3          	sb	a5,27(sp)

80003c2e <.L46>:
        }
    }

    if (is_mux_valid) {
80003c2e:	01b14783          	lbu	a5,27(sp)
80003c32:	cb85                	beqz	a5,80003c62 <.L47>
        if (node != clock_node_ahb) {
80003c34:	01a14703          	lbu	a4,26(sp)
80003c38:	0fe00793          	li	a5,254
80003c3c:	02f70063          	beq	a4,a5,80003c5c <.L48>
            node += instance;
80003c40:	47a2                	lw	a5,8(sp)
80003c42:	0ff7f793          	zext.b	a5,a5
80003c46:	01a14703          	lbu	a4,26(sp)
80003c4a:	97ba                	add	a5,a5,a4
80003c4c:	00f10d23          	sb	a5,26(sp)
            clk_freq = get_frequency_for_ip_in_common_group(node);
80003c50:	01a14783          	lbu	a5,26(sp)
80003c54:	853e                	mv	a0,a5
80003c56:	3f09                	jal	80003b68 <get_frequency_for_ip_in_common_group>
80003c58:	ce2a                	sw	a0,28(sp)
80003c5a:	a021                	j	80003c62 <.L47>

80003c5c <.L48>:
        } else {
            clk_freq = get_frequency_for_ahb();
80003c5c:	3e8020ef          	jal	80006044 <get_frequency_for_ahb>
80003c60:	ce2a                	sw	a0,28(sp)

80003c62 <.L47>:
        }
    }
    return clk_freq;
80003c62:	47f2                	lw	a5,28(sp)
}
80003c64:	853e                	mv	a0,a5
80003c66:	50b2                	lw	ra,44(sp)
80003c68:	6145                	addi	sp,sp,48
80003c6a:	8082                	ret

Disassembly of section .text.get_frequency_for_ewdg:

80003c6c <get_frequency_for_ewdg>:

    return clk_freq;
}

static uint32_t get_frequency_for_ewdg(uint32_t instance)
{
80003c6c:	7179                	addi	sp,sp,-48
80003c6e:	d606                	sw	ra,44(sp)
80003c70:	c62a                	sw	a0,12(sp)
    uint32_t freq_in_hz;
    if (EWDG_CTRL0_CLK_SEL_GET(s_wdgs[instance]->CTRL0) == 0) {
80003c72:	8b818713          	addi	a4,gp,-1864 # 80003148 <s_wdgs>
80003c76:	47b2                	lw	a5,12(sp)
80003c78:	078a                	slli	a5,a5,0x2
80003c7a:	97ba                	add	a5,a5,a4
80003c7c:	439c                	lw	a5,0(a5)
80003c7e:	4398                	lw	a4,0(a5)
80003c80:	200007b7          	lui	a5,0x20000
80003c84:	8ff9                	and	a5,a5,a4
80003c86:	e789                	bnez	a5,80003c90 <.L56>
        freq_in_hz = get_frequency_for_ahb();
80003c88:	3bc020ef          	jal	80006044 <get_frequency_for_ahb>
80003c8c:	ce2a                	sw	a0,28(sp)
80003c8e:	a019                	j	80003c94 <.L57>

80003c90 <.L56>:
    } else {
        freq_in_hz = FREQ_32KHz;
80003c90:	67a1                	lui	a5,0x8
80003c92:	ce3e                	sw	a5,28(sp)

80003c94 <.L57>:
    }

    return freq_in_hz;
80003c94:	47f2                	lw	a5,28(sp)
}
80003c96:	853e                	mv	a0,a5
80003c98:	50b2                	lw	ra,44(sp)
80003c9a:	6145                	addi	sp,sp,48
80003c9c:	8082                	ret

Disassembly of section .text.get_frequency_for_cpu:

80003c9e <get_frequency_for_cpu>:

    return freq_in_hz;
}

static uint32_t get_frequency_for_cpu(void)
{
80003c9e:	1101                	addi	sp,sp,-32
80003ca0:	ce06                	sw	ra,28(sp)
    uint32_t mux = SYSCTL_CLOCK_CPU_MUX_GET(HPM_SYSCTL->CLOCK_CPU[0]);
80003ca2:	f4000737          	lui	a4,0xf4000
80003ca6:	6789                	lui	a5,0x2
80003ca8:	97ba                	add	a5,a5,a4
80003caa:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
80003cae:	83a1                	srli	a5,a5,0x8
80003cb0:	8b9d                	andi	a5,a5,7
80003cb2:	c63e                	sw	a5,12(sp)
    uint32_t div = SYSCTL_CLOCK_CPU_DIV_GET(HPM_SYSCTL->CLOCK_CPU[0]) + 1U;
80003cb4:	f4000737          	lui	a4,0xf4000
80003cb8:	6789                	lui	a5,0x2
80003cba:	97ba                	add	a5,a5,a4
80003cbc:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
80003cc0:	0ff7f793          	zext.b	a5,a5
80003cc4:	0785                	addi	a5,a5,1
80003cc6:	c43e                	sw	a5,8(sp)
    return (get_frequency_for_source(mux) / div);
80003cc8:	47b2                	lw	a5,12(sp)
80003cca:	0ff7f793          	zext.b	a5,a5
80003cce:	853e                	mv	a0,a5
80003cd0:	33ed                	jal	80003aba <get_frequency_for_source>
80003cd2:	872a                	mv	a4,a0
80003cd4:	47a2                	lw	a5,8(sp)
80003cd6:	02f757b3          	divu	a5,a4,a5
}
80003cda:	853e                	mv	a0,a5
80003cdc:	40f2                	lw	ra,28(sp)
80003cde:	6105                	addi	sp,sp,32
80003ce0:	8082                	ret

Disassembly of section .text.clock_add_to_group:

80003ce2 <clock_add_to_group>:
{
    switch_ip_clock(clock_name, CLOCK_OFF);
}

void clock_add_to_group(clock_name_t clock_name, uint32_t group)
{
80003ce2:	7179                	addi	sp,sp,-48
80003ce4:	d606                	sw	ra,44(sp)
80003ce6:	c62a                	sw	a0,12(sp)
80003ce8:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80003cea:	47b2                	lw	a5,12(sp)
80003cec:	83c1                	srli	a5,a5,0x10
80003cee:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
80003cf0:	4772                	lw	a4,28(sp)
80003cf2:	13600793          	li	a5,310
80003cf6:	00e7ef63          	bltu	a5,a4,80003d14 <.L155>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, true);
80003cfa:	47a2                	lw	a5,8(sp)
80003cfc:	0ff7f793          	zext.b	a5,a5
80003d00:	4772                	lw	a4,28(sp)
80003d02:	08074733          	zext.h	a4,a4
80003d06:	4685                	li	a3,1
80003d08:	863a                	mv	a2,a4
80003d0a:	85be                	mv	a1,a5
80003d0c:	f4000537          	lui	a0,0xf4000
80003d10:	7f3010ef          	jal	80005d02 <sysctl_enable_group_resource>

80003d14 <.L155>:
    }
}
80003d14:	0001                	nop
80003d16:	50b2                	lw	ra,44(sp)
80003d18:	6145                	addi	sp,sp,48
80003d1a:	8082                	ret

Disassembly of section .text.clock_remove_from_group:

80003d1c <clock_remove_from_group>:

void clock_remove_from_group(clock_name_t clock_name, uint32_t group)
{
80003d1c:	7179                	addi	sp,sp,-48
80003d1e:	d606                	sw	ra,44(sp)
80003d20:	c62a                	sw	a0,12(sp)
80003d22:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80003d24:	47b2                	lw	a5,12(sp)
80003d26:	83c1                	srli	a5,a5,0x10
80003d28:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
80003d2a:	4772                	lw	a4,28(sp)
80003d2c:	13600793          	li	a5,310
80003d30:	00e7ef63          	bltu	a5,a4,80003d4e <.L158>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, false);
80003d34:	47a2                	lw	a5,8(sp)
80003d36:	0ff7f793          	zext.b	a5,a5
80003d3a:	4772                	lw	a4,28(sp)
80003d3c:	08074733          	zext.h	a4,a4
80003d40:	4681                	li	a3,0
80003d42:	863a                	mv	a2,a4
80003d44:	85be                	mv	a1,a5
80003d46:	f4000537          	lui	a0,0xf4000
80003d4a:	7b9010ef          	jal	80005d02 <sysctl_enable_group_resource>

80003d4e <.L158>:
    }
}
80003d4e:	0001                	nop
80003d50:	50b2                	lw	ra,44(sp)
80003d52:	6145                	addi	sp,sp,48
80003d54:	8082                	ret

Disassembly of section .text.l1c_dc_enable:

80003d56 <l1c_dc_enable>:
    }
#endif
}

void l1c_dc_enable(void)
{
80003d56:	1101                	addi	sp,sp,-32
80003d58:	ce06                	sw	ra,28(sp)

80003d5a <.LBB48>:
#endif

/* get cache control register value */
ATTR_ALWAYS_INLINE static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
80003d5a:	7ca027f3          	csrr	a5,0x7ca
80003d5e:	c63e                	sw	a5,12(sp)
80003d60:	47b2                	lw	a5,12(sp)

80003d62 <.LBE52>:
80003d62:	0001                	nop

80003d64 <.LBE50>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_dc_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
80003d64:	8b89                	andi	a5,a5,2
80003d66:	00f037b3          	snez	a5,a5
80003d6a:	0ff7f793          	zext.b	a5,a5

80003d6e <.LBE48>:
    if (!l1c_dc_is_enabled()) {
80003d6e:	0017c793          	xori	a5,a5,1
80003d72:	0ff7f793          	zext.b	a5,a5
80003d76:	c791                	beqz	a5,80003d82 <.L11>
#ifdef L1C_DC_DISABLE_WRITEAROUND_ON_ENABLE
        l1c_dc_disable_writearound();
#else
        l1c_dc_enable_writearound();
80003d78:	2081                	jal	80003db8 <l1c_dc_enable_writearound>
#endif
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DPREF_EN_MASK | HPM_MCACHE_CTL_DC_EN_MASK);
80003d7a:	40200793          	li	a5,1026
80003d7e:	7ca7a073          	csrs	0x7ca,a5

80003d82 <.L11>:
    }
}
80003d82:	0001                	nop
80003d84:	40f2                	lw	ra,28(sp)
80003d86:	6105                	addi	sp,sp,32
80003d88:	8082                	ret

Disassembly of section .text.l1c_ic_enable:

80003d8a <l1c_ic_enable>:
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    }
}

void l1c_ic_enable(void)
{
80003d8a:	1141                	addi	sp,sp,-16

80003d8c <.LBB58>:
    return read_csr(CSR_MCACHE_CTL);
80003d8c:	7ca027f3          	csrr	a5,0x7ca
80003d90:	c63e                	sw	a5,12(sp)
80003d92:	47b2                	lw	a5,12(sp)

80003d94 <.LBE62>:
80003d94:	0001                	nop

80003d96 <.LBE60>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_ic_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
80003d96:	8b85                	andi	a5,a5,1
80003d98:	00f037b3          	snez	a5,a5
80003d9c:	0ff7f793          	zext.b	a5,a5

80003da0 <.LBE58>:
    if (!l1c_ic_is_enabled()) {
80003da0:	0017c793          	xori	a5,a5,1
80003da4:	0ff7f793          	zext.b	a5,a5
80003da8:	c789                	beqz	a5,80003db2 <.L21>
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IPREF_EN_MASK
80003daa:	30100793          	li	a5,769
80003dae:	7ca7a073          	csrs	0x7ca,a5

80003db2 <.L21>:
                              | HPM_MCACHE_CTL_CCTL_SUEN_MASK
                              | HPM_MCACHE_CTL_IC_EN_MASK);
    }
}
80003db2:	0001                	nop
80003db4:	0141                	addi	sp,sp,16
80003db6:	8082                	ret

Disassembly of section .text.l1c_dc_enable_writearound:

80003db8 <l1c_dc_enable_writearound>:
    l1c_op(HPM_L1C_CCTL_CMD_L1I_VA_UNLOCK, address, size);
}

void l1c_dc_enable_writearound(void)
{
    set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_WAROUND_MASK);
80003db8:	6799                	lui	a5,0x6
80003dba:	7ca7a073          	csrs	0x7ca,a5
}
80003dbe:	0001                	nop
80003dc0:	8082                	ret

Disassembly of section .text.init_uart2_pins:

80003dc2 <init_uart2_pins>:
    HPM_IOC->PAD[IOC_PAD_PA01].FUNC_CTL = IOC_PA01_FUNC_CTL_UART0_RXD;
}

void init_uart2_pins(void)
{
    HPM_IOC->PAD[IOC_PAD_PB08].FUNC_CTL = IOC_PB08_FUNC_CTL_UART2_TXD;
80003dc2:	f40407b7          	lui	a5,0xf4040
80003dc6:	4709                	li	a4,2
80003dc8:	14e7a023          	sw	a4,320(a5) # f4040140 <__AHB_SRAM_segment_end__+0x3c38140>

    HPM_IOC->PAD[IOC_PAD_PB09].FUNC_CTL = IOC_PB09_FUNC_CTL_UART2_RXD;
80003dcc:	f40407b7          	lui	a5,0xf4040
80003dd0:	4709                	li	a4,2
80003dd2:	14e7a423          	sw	a4,328(a5) # f4040148 <__AHB_SRAM_segment_end__+0x3c38148>

    HPM_IOC->PAD[IOC_PAD_PB10].FUNC_CTL = IOC_PB10_FUNC_CTL_UART2_DE;
80003dd6:	f40407b7          	lui	a5,0xf4040
80003dda:	4709                	li	a4,2
80003ddc:	14e7a823          	sw	a4,336(a5) # f4040150 <__AHB_SRAM_segment_end__+0x3c38150>
}
80003de0:	0001                	nop
80003de2:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

80003de4 <sysctl_resource_target_is_busy>:
{
80003de4:	1141                	addi	sp,sp,-16
80003de6:	c62a                	sw	a0,12(sp)
80003de8:	87ae                	mv	a5,a1
80003dea:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
80003dee:	00a15783          	lhu	a5,10(sp)
80003df2:	4732                	lw	a4,12(sp)
80003df4:	078a                	slli	a5,a5,0x2
80003df6:	97ba                	add	a5,a5,a4
80003df8:	4398                	lw	a4,0(a5)
80003dfa:	400007b7          	lui	a5,0x40000
80003dfe:	8ff9                	and	a5,a5,a4
80003e00:	00f037b3          	snez	a5,a5
80003e04:	0ff7f793          	zext.b	a5,a5
}
80003e08:	853e                	mv	a0,a5
80003e0a:	0141                	addi	sp,sp,16
80003e0c:	8082                	ret

Disassembly of section .text.sysctl_resource_target_set_mode:

80003e0e <sysctl_resource_target_set_mode>:
{
80003e0e:	1141                	addi	sp,sp,-16
80003e10:	c62a                	sw	a0,12(sp)
80003e12:	87ae                	mv	a5,a1
80003e14:	8732                	mv	a4,a2
80003e16:	00f11523          	sh	a5,10(sp)
80003e1a:	87ba                	mv	a5,a4
80003e1c:	00f104a3          	sb	a5,9(sp)
        (ptr->RESOURCE[resource] & ~SYSCTL_RESOURCE_MODE_MASK) |
80003e20:	00a15783          	lhu	a5,10(sp)
80003e24:	4732                	lw	a4,12(sp)
80003e26:	078a                	slli	a5,a5,0x2
80003e28:	97ba                	add	a5,a5,a4
80003e2a:	439c                	lw	a5,0(a5)
80003e2c:	ffc7f693          	andi	a3,a5,-4
        SYSCTL_RESOURCE_MODE_SET(mode);
80003e30:	00914783          	lbu	a5,9(sp)
80003e34:	0037f713          	andi	a4,a5,3
    ptr->RESOURCE[resource] =
80003e38:	00a15783          	lhu	a5,10(sp)
        (ptr->RESOURCE[resource] & ~SYSCTL_RESOURCE_MODE_MASK) |
80003e3c:	8f55                	or	a4,a4,a3
    ptr->RESOURCE[resource] =
80003e3e:	46b2                	lw	a3,12(sp)
80003e40:	078a                	slli	a5,a5,0x2
80003e42:	97b6                	add	a5,a5,a3
80003e44:	c398                	sw	a4,0(a5)
}
80003e46:	0001                	nop
80003e48:	0141                	addi	sp,sp,16
80003e4a:	8082                	ret

Disassembly of section .text.sysctl_resource_target_get_mode:

80003e4c <sysctl_resource_target_get_mode>:
{
80003e4c:	1141                	addi	sp,sp,-16
80003e4e:	c62a                	sw	a0,12(sp)
80003e50:	87ae                	mv	a5,a1
80003e52:	00f11523          	sh	a5,10(sp)
    return SYSCTL_RESOURCE_MODE_GET(ptr->RESOURCE[resource]);
80003e56:	00a15783          	lhu	a5,10(sp)
80003e5a:	4732                	lw	a4,12(sp)
80003e5c:	078a                	slli	a5,a5,0x2
80003e5e:	97ba                	add	a5,a5,a4
80003e60:	439c                	lw	a5,0(a5)
80003e62:	0ff7f793          	zext.b	a5,a5
80003e66:	8b8d                	andi	a5,a5,3
80003e68:	0ff7f793          	zext.b	a5,a5
}
80003e6c:	853e                	mv	a0,a5
80003e6e:	0141                	addi	sp,sp,16
80003e70:	8082                	ret

Disassembly of section .text.sysctl_clock_set_preset:

80003e72 <sysctl_clock_set_preset>:
 *
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] preset preset
 */
static inline void sysctl_clock_set_preset(SYSCTL_Type *ptr, sysctl_preset_t preset)
{
80003e72:	1141                	addi	sp,sp,-16
80003e74:	c62a                	sw	a0,12(sp)
80003e76:	87ae                	mv	a5,a1
80003e78:	00f105a3          	sb	a5,11(sp)
    ptr->GLOBAL00 = (ptr->GLOBAL00 & ~SYSCTL_GLOBAL00_MUX_MASK) | SYSCTL_GLOBAL00_MUX_SET(preset);
80003e7c:	4732                	lw	a4,12(sp)
80003e7e:	6789                	lui	a5,0x2
80003e80:	97ba                	add	a5,a5,a4
80003e82:	439c                	lw	a5,0(a5)
80003e84:	f007f713          	andi	a4,a5,-256
80003e88:	00b14783          	lbu	a5,11(sp)
80003e8c:	8f5d                	or	a4,a4,a5
80003e8e:	46b2                	lw	a3,12(sp)
80003e90:	6789                	lui	a5,0x2
80003e92:	97b6                	add	a5,a5,a3
80003e94:	c398                	sw	a4,0(a5)
}
80003e96:	0001                	nop
80003e98:	0141                	addi	sp,sp,16
80003e9a:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_is_stable:

80003e9c <pllctlv2_xtal_is_stable>:
 * @brief Checks the stability status of the external crystal oscillator
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @return true if the external crystal oscillator is stable and ready for use
 */
static inline bool pllctlv2_xtal_is_stable(PLLCTLV2_Type *ptr)
{
80003e9c:	1101                	addi	sp,sp,-32
80003e9e:	c62a                	sw	a0,12(sp)
    uint32_t status = ptr->XTAL;
80003ea0:	47b2                	lw	a5,12(sp)
80003ea2:	439c                	lw	a5,0(a5)
80003ea4:	ce3e                	sw	a5,28(sp)
    return (IS_HPM_BITMASK_CLR(status, PLLCTLV2_XTAL_ENABLE_MASK)
80003ea6:	4772                	lw	a4,28(sp)
80003ea8:	100007b7          	lui	a5,0x10000
80003eac:	8ff9                	and	a5,a5,a4
         || (IS_HPM_BITMASK_CLR(status, PLLCTLV2_XTAL_BUSY_MASK) && IS_HPM_BITMASK_SET(status, PLLCTLV2_XTAL_RESPONSE_MASK)));
80003eae:	cb89                	beqz	a5,80003ec0 <.L30>
80003eb0:	47f2                	lw	a5,28(sp)
80003eb2:	0007c963          	bltz	a5,80003ec4 <.L31>
80003eb6:	4772                	lw	a4,28(sp)
80003eb8:	200007b7          	lui	a5,0x20000
80003ebc:	8ff9                	and	a5,a5,a4
80003ebe:	c399                	beqz	a5,80003ec4 <.L31>

80003ec0 <.L30>:
80003ec0:	4785                	li	a5,1
80003ec2:	a011                	j	80003ec6 <.L32>

80003ec4 <.L31>:
80003ec4:	4781                	li	a5,0

80003ec6 <.L32>:
80003ec6:	8b85                	andi	a5,a5,1
80003ec8:	0ff7f793          	zext.b	a5,a5
}
80003ecc:	853e                	mv	a0,a5
80003ece:	6105                	addi	sp,sp,32
80003ed0:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_set_rampup_time:

80003ed2 <pllctlv2_xtal_set_rampup_time>:
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @param [in] rc24m_cycles Number of RC24M clock cycles for the ramp-up period
 * @note The ramp-up time affects how quickly the crystal oscillator reaches stable operation
 */
static inline void pllctlv2_xtal_set_rampup_time(PLLCTLV2_Type *ptr, uint32_t rc24m_cycles)
{
80003ed2:	1141                	addi	sp,sp,-16
80003ed4:	c62a                	sw	a0,12(sp)
80003ed6:	c42e                	sw	a1,8(sp)
    ptr->XTAL = (ptr->XTAL & ~PLLCTLV2_XTAL_RAMP_TIME_MASK) | PLLCTLV2_XTAL_RAMP_TIME_SET(rc24m_cycles);
80003ed8:	47b2                	lw	a5,12(sp)
80003eda:	4398                	lw	a4,0(a5)
80003edc:	fff007b7          	lui	a5,0xfff00
80003ee0:	8f7d                	and	a4,a4,a5
80003ee2:	46a2                	lw	a3,8(sp)
80003ee4:	001007b7          	lui	a5,0x100
80003ee8:	17fd                	addi	a5,a5,-1 # fffff <__FLASH_segment_size__+0x2fff>
80003eea:	8ff5                	and	a5,a5,a3
80003eec:	8f5d                	or	a4,a4,a5
80003eee:	47b2                	lw	a5,12(sp)
80003ef0:	c398                	sw	a4,0(a5)
}
80003ef2:	0001                	nop
80003ef4:	0141                	addi	sp,sp,16
80003ef6:	8082                	ret

Disassembly of section .text.board_print_banner:

80003ef8 <board_print_banner>:
#endif
#endif
}

void board_print_banner(void)
{
80003ef8:	d8010113          	addi	sp,sp,-640
80003efc:	26112e23          	sw	ra,636(sp)
    const uint8_t banner[] = "\n"
80003f00:	95c18713          	addi	a4,gp,-1700 # 800031ec <.LC0>
80003f04:	878a                	mv	a5,sp
80003f06:	86ba                	mv	a3,a4
80003f08:	26f00713          	li	a4,623
80003f0c:	863a                	mv	a2,a4
80003f0e:	85b6                	mv	a1,a3
80003f10:	853e                	mv	a0,a5
80003f12:	3fb000ef          	jal	80004b0c <memcpy>
"$$ |  $$ |$$ |      $$ |\\$  /$$ |$$ |$$ |      $$ |      $$ |  $$ |\n"
"$$ |  $$ |$$ |      $$ | \\_/ $$ |$$ |\\$$$$$$$\\ $$ |      \\$$$$$$  |\n"
"\\__|  \\__|\\__|      \\__|     \\__|\\__| \\_______|\\__|       \\______/\n"
"----------------------------------------------------------------------\n";
#ifdef SDK_VERSION_STRING
    printf("hpm_sdk: %s\n", SDK_VERSION_STRING);
80003f16:	94018593          	addi	a1,gp,-1728 # 800031d0 <.LC1>
80003f1a:	94818513          	addi	a0,gp,-1720 # 800031d8 <.LC2>
80003f1e:	6c1000ef          	jal	80004dde <printf>
#endif
    printf("%s", banner);
80003f22:	878a                	mv	a5,sp
80003f24:	85be                	mv	a1,a5
80003f26:	95818513          	addi	a0,gp,-1704 # 800031e8 <.LC3>
80003f2a:	6b5000ef          	jal	80004dde <printf>
}
80003f2e:	0001                	nop
80003f30:	27c12083          	lw	ra,636(sp)
80003f34:	28010113          	addi	sp,sp,640
80003f38:	8082                	ret

Disassembly of section .text.board_print_clock_freq:

80003f3a <board_print_clock_freq>:

void board_print_clock_freq(void)
{
80003f3a:	1141                	addi	sp,sp,-16
80003f3c:	c606                	sw	ra,12(sp)
    printf("==============================\n");
80003f3e:	bcc18513          	addi	a0,gp,-1076 # 8000345c <.LC4>
80003f42:	69d000ef          	jal	80004dde <printf>
    printf(" %s clock summary\n", BOARD_NAME);
80003f46:	bec18593          	addi	a1,gp,-1044 # 8000347c <.LC5>
80003f4a:	bf818513          	addi	a0,gp,-1032 # 80003488 <.LC6>
80003f4e:	691000ef          	jal	80004dde <printf>
    printf("==============================\n");
80003f52:	bcc18513          	addi	a0,gp,-1076 # 8000345c <.LC4>
80003f56:	689000ef          	jal	80004dde <printf>
    printf("cpu0:\t\t %luHz\n", clock_get_frequency(clock_cpu0));
80003f5a:	6785                	lui	a5,0x1
80003f5c:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x6a6>
80003f60:	791010ef          	jal	80005ef0 <clock_get_frequency>
80003f64:	87aa                	mv	a5,a0
80003f66:	85be                	mv	a1,a5
80003f68:	c0c18513          	addi	a0,gp,-1012 # 8000349c <.LC7>
80003f6c:	673000ef          	jal	80004dde <printf>
    printf("ahb:\t\t %luHz\n", clock_get_frequency(clock_ahb));
80003f70:	fffd07b7          	lui	a5,0xfffd0
80003f74:	5fe78513          	addi	a0,a5,1534 # fffd05fe <__AHB_SRAM_segment_end__+0xfbc85fe>
80003f78:	779010ef          	jal	80005ef0 <clock_get_frequency>
80003f7c:	87aa                	mv	a5,a0
80003f7e:	85be                	mv	a1,a5
80003f80:	c1c18513          	addi	a0,gp,-996 # 800034ac <.LC8>
80003f84:	65b000ef          	jal	80004dde <printf>
    printf("mchtmr0:\t %luHz\n", clock_get_frequency(clock_mchtmr0));
80003f88:	01020537          	lui	a0,0x1020
80003f8c:	765010ef          	jal	80005ef0 <clock_get_frequency>
80003f90:	87aa                	mv	a5,a0
80003f92:	85be                	mv	a1,a5
80003f94:	c2c18513          	addi	a0,gp,-980 # 800034bc <.LC9>
80003f98:	647000ef          	jal	80004dde <printf>
    printf("xpi0:\t\t %luHz\n", clock_get_frequency(clock_xpi0));
80003f9c:	013307b7          	lui	a5,0x1330
80003fa0:	01d78513          	addi	a0,a5,29 # 133001d <_flash_size+0x123001d>
80003fa4:	74d010ef          	jal	80005ef0 <clock_get_frequency>
80003fa8:	87aa                	mv	a5,a0
80003faa:	85be                	mv	a1,a5
80003fac:	c4018513          	addi	a0,gp,-960 # 800034d0 <.LC10>
80003fb0:	62f000ef          	jal	80004dde <printf>
    printf("==============================\n");
80003fb4:	bcc18513          	addi	a0,gp,-1076 # 8000345c <.LC4>
80003fb8:	627000ef          	jal	80004dde <printf>
}
80003fbc:	0001                	nop
80003fbe:	40b2                	lw	ra,12(sp)
80003fc0:	0141                	addi	sp,sp,16
80003fc2:	8082                	ret

Disassembly of section .text.board_init_usb_dp_dm_pins:

80003fc4 <board_init_usb_dp_dm_pins>:
    board_print_banner();
#endif
}

void board_init_usb_dp_dm_pins(void)
{
80003fc4:	1101                	addi	sp,sp,-32
80003fc6:	ce06                	sw	ra,28(sp)
    /* Disconnect usb dp/dm pins pull down 45ohm resistance */

    while (sysctl_resource_any_is_busy(HPM_SYSCTL)) {
80003fc8:	0001                	nop

80003fca <.L50>:
80003fca:	f4000537          	lui	a0,0xf4000
80003fce:	2a0020ef          	jal	8000626e <sysctl_resource_any_is_busy>
80003fd2:	87aa                	mv	a5,a0
80003fd4:	fbfd                	bnez	a5,80003fca <.L50>
        ;
    }
    if (pllctlv2_xtal_is_stable(HPM_PLLCTLV2) && pllctlv2_xtal_is_enabled(HPM_PLLCTLV2)) {
80003fd6:	f40c0537          	lui	a0,0xf40c0
80003fda:	35c9                	jal	80003e9c <pllctlv2_xtal_is_stable>
80003fdc:	87aa                	mv	a5,a0
80003fde:	c7b1                	beqz	a5,8000402a <.L51>
80003fe0:	f40c0537          	lui	a0,0xf40c0
80003fe4:	2fe020ef          	jal	800062e2 <pllctlv2_xtal_is_enabled>
80003fe8:	87aa                	mv	a5,a0
80003fea:	c3a1                	beqz	a5,8000402a <.L51>
        if (clock_check_in_group(clock_usb0, 0)) {
80003fec:	4581                	li	a1,0
80003fee:	013407b7          	lui	a5,0x1340
80003ff2:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80003ff6:	178020ef          	jal	8000616e <clock_check_in_group>
80003ffa:	87aa                	mv	a5,a0
80003ffc:	c791                	beqz	a5,80004008 <.L52>
            usb_phy_disable_dp_dm_pulldown(HPM_USB0);
80003ffe:	f300c537          	lui	a0,0xf300c
80004002:	2c0020ef          	jal	800062c2 <usb_phy_disable_dp_dm_pulldown>
        if (clock_check_in_group(clock_usb0, 0)) {
80004006:	a049                	j	80004088 <.L54>

80004008 <.L52>:
        } else {
            clock_add_to_group(clock_usb0, 0);
80004008:	4581                	li	a1,0
8000400a:	013407b7          	lui	a5,0x1340
8000400e:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80004012:	39c1                	jal	80003ce2 <clock_add_to_group>
            usb_phy_disable_dp_dm_pulldown(HPM_USB0);
80004014:	f300c537          	lui	a0,0xf300c
80004018:	2aa020ef          	jal	800062c2 <usb_phy_disable_dp_dm_pulldown>
            clock_remove_from_group(clock_usb0, 0);
8000401c:	4581                	li	a1,0
8000401e:	013407b7          	lui	a5,0x1340
80004022:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80004026:	39dd                	jal	80003d1c <clock_remove_from_group>
        if (clock_check_in_group(clock_usb0, 0)) {
80004028:	a085                	j	80004088 <.L54>

8000402a <.L51>:
        }
    } else {
        uint8_t tmp;
        tmp = sysctl_resource_target_get_mode(HPM_SYSCTL, sysctl_resource_xtal);
8000402a:	02000593          	li	a1,32
8000402e:	f4000537          	lui	a0,0xf4000
80004032:	3d29                	jal	80003e4c <sysctl_resource_target_get_mode>
80004034:	87aa                	mv	a5,a0
80004036:	00f107a3          	sb	a5,15(sp)
        sysctl_resource_target_set_mode(HPM_SYSCTL, sysctl_resource_xtal, 0x03);    /* NOLINT */
8000403a:	460d                	li	a2,3
8000403c:	02000593          	li	a1,32
80004040:	f4000537          	lui	a0,0xf4000
80004044:	33e9                	jal	80003e0e <sysctl_resource_target_set_mode>
        clock_add_to_group(clock_usb0, 0);
80004046:	4581                	li	a1,0
80004048:	013407b7          	lui	a5,0x1340
8000404c:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80004050:	3949                	jal	80003ce2 <clock_add_to_group>
        usb_phy_disable_dp_dm_pulldown(HPM_USB0);
80004052:	f300c537          	lui	a0,0xf300c
80004056:	26c020ef          	jal	800062c2 <usb_phy_disable_dp_dm_pulldown>
        clock_remove_from_group(clock_usb0, 0);
8000405a:	4581                	li	a1,0
8000405c:	013407b7          	lui	a5,0x1340
80004060:	50d78513          	addi	a0,a5,1293 # 134050d <_flash_size+0x124050d>
80004064:	3965                	jal	80003d1c <clock_remove_from_group>
        while (sysctl_resource_target_is_busy(HPM_SYSCTL, sysctl_resource_usb0)) {
80004066:	0001                	nop

80004068 <.L55>:
80004068:	13400593          	li	a1,308
8000406c:	f4000537          	lui	a0,0xf4000
80004070:	3b95                	jal	80003de4 <sysctl_resource_target_is_busy>
80004072:	87aa                	mv	a5,a0
80004074:	fbf5                	bnez	a5,80004068 <.L55>
            ;
        }
        sysctl_resource_target_set_mode(HPM_SYSCTL, sysctl_resource_xtal, tmp);
80004076:	00f14783          	lbu	a5,15(sp)
8000407a:	863e                	mv	a2,a5
8000407c:	02000593          	li	a1,32
80004080:	f4000537          	lui	a0,0xf4000
80004084:	3369                	jal	80003e0e <sysctl_resource_target_set_mode>

80004086 <.LBE14>:
    }
}
80004086:	0001                	nop

80004088 <.L54>:
80004088:	0001                	nop
8000408a:	40f2                	lw	ra,28(sp)
8000408c:	6105                	addi	sp,sp,32
8000408e:	8082                	ret

Disassembly of section .text.uart_calculate_baudrate:

80004090 <uart_calculate_baudrate>:
    config->rx_enable = true;
#endif
}

static bool uart_calculate_baudrate(uint32_t freq, uint32_t baudrate, uint16_t *div_out, uint8_t *osc_out)
{
80004090:	711d                	addi	sp,sp,-96
80004092:	ce86                	sw	ra,92(sp)
80004094:	cca2                	sw	s0,88(sp)
80004096:	caa6                	sw	s1,84(sp)
80004098:	c8ca                	sw	s2,80(sp)
8000409a:	c6ce                	sw	s3,76(sp)
8000409c:	c4d2                	sw	s4,72(sp)
8000409e:	c2d6                	sw	s5,68(sp)
800040a0:	c0da                	sw	s6,64(sp)
800040a2:	de5e                	sw	s7,60(sp)
800040a4:	dc62                	sw	s8,56(sp)
800040a6:	da66                	sw	s9,52(sp)
800040a8:	c62a                	sw	a0,12(sp)
800040aa:	c42e                	sw	a1,8(sp)
800040ac:	c232                	sw	a2,4(sp)
800040ae:	c036                	sw	a3,0(sp)
    uint32_t div, osc, delta;
    uint64_t tmp;
    if ((div_out == NULL) || (!freq) || (!baudrate)
800040b0:	4692                	lw	a3,4(sp)
800040b2:	ca9d                	beqz	a3,800040e8 <.L6>
800040b4:	46b2                	lw	a3,12(sp)
800040b6:	ca8d                	beqz	a3,800040e8 <.L6>
800040b8:	46a2                	lw	a3,8(sp)
800040ba:	c69d                	beqz	a3,800040e8 <.L6>
            || (baudrate < HPM_UART_MINIMUM_BAUDRATE)
800040bc:	4622                	lw	a2,8(sp)
800040be:	0c700693          	li	a3,199
800040c2:	02c6f363          	bgeu	a3,a2,800040e8 <.L6>
            || (freq / HPM_UART_BAUDRATE_DIV_MIN < baudrate * HPM_UART_OSC_MIN)
800040c6:	46a2                	lw	a3,8(sp)
800040c8:	068e                	slli	a3,a3,0x3
800040ca:	4632                	lw	a2,12(sp)
800040cc:	00d66e63          	bltu	a2,a3,800040e8 <.L6>
            || (freq / HPM_UART_BAUDRATE_DIV_MAX > (baudrate * HPM_UART_OSC_MAX))) {
800040d0:	4632                	lw	a2,12(sp)
800040d2:	800086b7          	lui	a3,0x80008
800040d6:	0685                	addi	a3,a3,1 # 80008001 <__SEGGER_init_data__+0x231>
800040d8:	02d636b3          	mulhu	a3,a2,a3
800040dc:	00f6d613          	srli	a2,a3,0xf
800040e0:	46a2                	lw	a3,8(sp)
800040e2:	0696                	slli	a3,a3,0x5
800040e4:	00c6f463          	bgeu	a3,a2,800040ec <.L7>

800040e8 <.L6>:
        return 0;
800040e8:	4781                	li	a5,0
800040ea:	a2f5                	j	800042d6 <.L8>

800040ec <.L7>:
    }

    tmp = ((uint64_t)freq * HPM_UART_BAUDRATE_SCALE) / baudrate;
800040ec:	46b2                	lw	a3,12(sp)
800040ee:	8736                	mv	a4,a3
800040f0:	4781                	li	a5,0
800040f2:	3e800693          	li	a3,1000
800040f6:	02d78633          	mul	a2,a5,a3
800040fa:	4681                	li	a3,0
800040fc:	02d706b3          	mul	a3,a4,a3
80004100:	9636                	add	a2,a2,a3
80004102:	3e800693          	li	a3,1000
80004106:	02d705b3          	mul	a1,a4,a3
8000410a:	02d738b3          	mulhu	a7,a4,a3
8000410e:	882e                	mv	a6,a1
80004110:	011607b3          	add	a5,a2,a7
80004114:	88be                	mv	a7,a5
80004116:	47a2                	lw	a5,8(sp)
80004118:	833e                	mv	t1,a5
8000411a:	4381                	li	t2,0
8000411c:	861a                	mv	a2,t1
8000411e:	869e                	mv	a3,t2
80004120:	8542                	mv	a0,a6
80004122:	85c6                	mv	a1,a7
80004124:	7a5020ef          	jal	800070c8 <__udivdi3>
80004128:	872a                	mv	a4,a0
8000412a:	87ae                	mv	a5,a1
8000412c:	d03a                	sw	a4,32(sp)
8000412e:	d23e                	sw	a5,36(sp)

    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
80004130:	47a1                	li	a5,8
80004132:	d63e                	sw	a5,44(sp)
80004134:	aa61                	j	800042cc <.L9>

80004136 <.L21>:
        /* osc range: HPM_UART_OSC_MIN - UART_SOC_OVERSAMPLE_MAX, even number */
        delta = 0;
80004136:	d402                	sw	zero,40(sp)
        /* Calculate divider with rounding */
        div = (uint32_t)((tmp + osc * (HPM_UART_BAUDRATE_SCALE / 2)) / (osc * HPM_UART_BAUDRATE_SCALE));
80004138:	5732                	lw	a4,44(sp)
8000413a:	87ba                	mv	a5,a4
8000413c:	078a                	slli	a5,a5,0x2
8000413e:	97ba                	add	a5,a5,a4
80004140:	00279713          	slli	a4,a5,0x2
80004144:	97ba                	add	a5,a5,a4
80004146:	00279713          	slli	a4,a5,0x2
8000414a:	97ba                	add	a5,a5,a4
8000414c:	078a                	slli	a5,a5,0x2
8000414e:	843e                	mv	s0,a5
80004150:	4481                	li	s1,0
80004152:	5602                	lw	a2,32(sp)
80004154:	5692                	lw	a3,36(sp)
80004156:	00c40733          	add	a4,s0,a2
8000415a:	85ba                	mv	a1,a4
8000415c:	0085b5b3          	sltu	a1,a1,s0
80004160:	00d487b3          	add	a5,s1,a3
80004164:	00f586b3          	add	a3,a1,a5
80004168:	87b6                	mv	a5,a3
8000416a:	853a                	mv	a0,a4
8000416c:	85be                	mv	a1,a5
8000416e:	5732                	lw	a4,44(sp)
80004170:	87ba                	mv	a5,a4
80004172:	078a                	slli	a5,a5,0x2
80004174:	97ba                	add	a5,a5,a4
80004176:	00279713          	slli	a4,a5,0x2
8000417a:	97ba                	add	a5,a5,a4
8000417c:	00279713          	slli	a4,a5,0x2
80004180:	97ba                	add	a5,a5,a4
80004182:	078e                	slli	a5,a5,0x3
80004184:	8b3e                	mv	s6,a5
80004186:	4b81                	li	s7,0
80004188:	865a                	mv	a2,s6
8000418a:	86de                	mv	a3,s7
8000418c:	73d020ef          	jal	800070c8 <__udivdi3>
80004190:	872a                	mv	a4,a0
80004192:	87ae                	mv	a5,a1
80004194:	ce3a                	sw	a4,28(sp)
        if (div < HPM_UART_BAUDRATE_DIV_MIN || div > HPM_UART_BAUDRATE_DIV_MAX) {
80004196:	47f2                	lw	a5,28(sp)
80004198:	12078463          	beqz	a5,800042c0 <.L24>
8000419c:	4772                	lw	a4,28(sp)
8000419e:	67c1                	lui	a5,0x10
800041a0:	12f77063          	bgeu	a4,a5,800042c0 <.L24>
            /* invalid div */
            continue;
        }
        if ((div * osc * HPM_UART_BAUDRATE_SCALE) > tmp) {
800041a4:	4772                	lw	a4,28(sp)
800041a6:	57b2                	lw	a5,44(sp)
800041a8:	02f70733          	mul	a4,a4,a5
800041ac:	87ba                	mv	a5,a4
800041ae:	078a                	slli	a5,a5,0x2
800041b0:	97ba                	add	a5,a5,a4
800041b2:	00279713          	slli	a4,a5,0x2
800041b6:	97ba                	add	a5,a5,a4
800041b8:	00279713          	slli	a4,a5,0x2
800041bc:	97ba                	add	a5,a5,a4
800041be:	078e                	slli	a5,a5,0x3
800041c0:	893e                	mv	s2,a5
800041c2:	4981                	li	s3,0
800041c4:	5792                	lw	a5,36(sp)
800041c6:	874e                	mv	a4,s3
800041c8:	00e7ea63          	bltu	a5,a4,800041dc <.L22>
800041cc:	5792                	lw	a5,36(sp)
800041ce:	874e                	mv	a4,s3
800041d0:	02e79a63          	bne	a5,a4,80004204 <.L13>
800041d4:	5782                	lw	a5,32(sp)
800041d6:	874a                	mv	a4,s2
800041d8:	02e7f663          	bgeu	a5,a4,80004204 <.L13>

800041dc <.L22>:
            delta = (uint32_t)((div * osc * HPM_UART_BAUDRATE_SCALE) - tmp);
800041dc:	4772                	lw	a4,28(sp)
800041de:	57b2                	lw	a5,44(sp)
800041e0:	02f70733          	mul	a4,a4,a5
800041e4:	87ba                	mv	a5,a4
800041e6:	078a                	slli	a5,a5,0x2
800041e8:	97ba                	add	a5,a5,a4
800041ea:	00279713          	slli	a4,a5,0x2
800041ee:	97ba                	add	a5,a5,a4
800041f0:	00279713          	slli	a4,a5,0x2
800041f4:	97ba                	add	a5,a5,a4
800041f6:	078e                	slli	a5,a5,0x3
800041f8:	873e                	mv	a4,a5
800041fa:	5782                	lw	a5,32(sp)
800041fc:	40f707b3          	sub	a5,a4,a5
80004200:	d43e                	sw	a5,40(sp)
80004202:	a8b9                	j	80004260 <.L15>

80004204 <.L13>:
        } else if ((div * osc * HPM_UART_BAUDRATE_SCALE) < tmp) {
80004204:	4772                	lw	a4,28(sp)
80004206:	57b2                	lw	a5,44(sp)
80004208:	02f70733          	mul	a4,a4,a5
8000420c:	87ba                	mv	a5,a4
8000420e:	078a                	slli	a5,a5,0x2
80004210:	97ba                	add	a5,a5,a4
80004212:	00279713          	slli	a4,a5,0x2
80004216:	97ba                	add	a5,a5,a4
80004218:	00279713          	slli	a4,a5,0x2
8000421c:	97ba                	add	a5,a5,a4
8000421e:	078e                	slli	a5,a5,0x3
80004220:	8a3e                	mv	s4,a5
80004222:	4a81                	li	s5,0
80004224:	5792                	lw	a5,36(sp)
80004226:	8756                	mv	a4,s5
80004228:	00f76a63          	bltu	a4,a5,8000423c <.L23>
8000422c:	5792                	lw	a5,36(sp)
8000422e:	8756                	mv	a4,s5
80004230:	02e79863          	bne	a5,a4,80004260 <.L15>
80004234:	5782                	lw	a5,32(sp)
80004236:	8752                	mv	a4,s4
80004238:	02f77463          	bgeu	a4,a5,80004260 <.L15>

8000423c <.L23>:
            delta = (uint32_t)(tmp - (div * osc * HPM_UART_BAUDRATE_SCALE));
8000423c:	5682                	lw	a3,32(sp)
8000423e:	4772                	lw	a4,28(sp)
80004240:	57b2                	lw	a5,44(sp)
80004242:	02f70733          	mul	a4,a4,a5
80004246:	87ba                	mv	a5,a4
80004248:	078a                	slli	a5,a5,0x2
8000424a:	97ba                	add	a5,a5,a4
8000424c:	00279713          	slli	a4,a5,0x2
80004250:	97ba                	add	a5,a5,a4
80004252:	00279713          	slli	a4,a5,0x2
80004256:	97ba                	add	a5,a5,a4
80004258:	078e                	slli	a5,a5,0x3
8000425a:	40f687b3          	sub	a5,a3,a5
8000425e:	d43e                	sw	a5,40(sp)

80004260 <.L15>:
        }
        if (delta && (((delta * 100) / tmp) > HPM_UART_BAUDRATE_TOLERANCE)) {
80004260:	57a2                	lw	a5,40(sp)
80004262:	cb95                	beqz	a5,80004296 <.L17>
80004264:	5722                	lw	a4,40(sp)
80004266:	87ba                	mv	a5,a4
80004268:	078a                	slli	a5,a5,0x2
8000426a:	97ba                	add	a5,a5,a4
8000426c:	00279713          	slli	a4,a5,0x2
80004270:	97ba                	add	a5,a5,a4
80004272:	078a                	slli	a5,a5,0x2
80004274:	8c3e                	mv	s8,a5
80004276:	4c81                	li	s9,0
80004278:	5602                	lw	a2,32(sp)
8000427a:	5692                	lw	a3,36(sp)
8000427c:	8562                	mv	a0,s8
8000427e:	85e6                	mv	a1,s9
80004280:	649020ef          	jal	800070c8 <__udivdi3>
80004284:	872a                	mv	a4,a0
80004286:	87ae                	mv	a5,a1
80004288:	86be                	mv	a3,a5
8000428a:	ee8d                	bnez	a3,800042c4 <.L25>
8000428c:	86be                	mv	a3,a5
8000428e:	e681                	bnez	a3,80004296 <.L17>
80004290:	478d                	li	a5,3
80004292:	02e7e963          	bltu	a5,a4,800042c4 <.L25>

80004296 <.L17>:
            continue;
        } else {
            *div_out = div;
80004296:	47f2                	lw	a5,28(sp)
80004298:	0807c733          	zext.h	a4,a5
8000429c:	4792                	lw	a5,4(sp)
8000429e:	00e79023          	sh	a4,0(a5) # 10000 <__AHB_SRAM_segment_size__+0x8000>
            *osc_out = (osc == HPM_UART_OSC_MAX) ? 0 : osc; /* osc == 0 in bitfield, oversample rate is 32 */
800042a2:	5732                	lw	a4,44(sp)
800042a4:	02000793          	li	a5,32
800042a8:	00f70663          	beq	a4,a5,800042b4 <.L19>
800042ac:	57b2                	lw	a5,44(sp)
800042ae:	0ff7f793          	zext.b	a5,a5
800042b2:	a011                	j	800042b6 <.L20>

800042b4 <.L19>:
800042b4:	4781                	li	a5,0

800042b6 <.L20>:
800042b6:	4702                	lw	a4,0(sp)
800042b8:	00f70023          	sb	a5,0(a4) # f4000000 <__AHB_SRAM_segment_end__+0x3bf8000>
            return true;
800042bc:	4785                	li	a5,1
800042be:	a821                	j	800042d6 <.L8>

800042c0 <.L24>:
            continue;
800042c0:	0001                	nop
800042c2:	a011                	j	800042c6 <.L12>

800042c4 <.L25>:
            continue;
800042c4:	0001                	nop

800042c6 <.L12>:
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
800042c6:	57b2                	lw	a5,44(sp)
800042c8:	0789                	addi	a5,a5,2
800042ca:	d63e                	sw	a5,44(sp)

800042cc <.L9>:
800042cc:	5732                	lw	a4,44(sp)
800042ce:	47f9                	li	a5,30
800042d0:	e6e7f3e3          	bgeu	a5,a4,80004136 <.L21>
        }
    }
    return false;
800042d4:	4781                	li	a5,0

800042d6 <.L8>:
}
800042d6:	853e                	mv	a0,a5
800042d8:	40f6                	lw	ra,92(sp)
800042da:	4466                	lw	s0,88(sp)
800042dc:	44d6                	lw	s1,84(sp)
800042de:	4946                	lw	s2,80(sp)
800042e0:	49b6                	lw	s3,76(sp)
800042e2:	4a26                	lw	s4,72(sp)
800042e4:	4a96                	lw	s5,68(sp)
800042e6:	4b06                	lw	s6,64(sp)
800042e8:	5bf2                	lw	s7,60(sp)
800042ea:	5c62                	lw	s8,56(sp)
800042ec:	5cd2                	lw	s9,52(sp)
800042ee:	6125                	addi	sp,sp,96
800042f0:	8082                	ret

Disassembly of section .text.uart_init:

800042f2 <uart_init>:

hpm_stat_t uart_init(UART_Type *ptr, uart_config_t *config)
{
800042f2:	7179                	addi	sp,sp,-48
800042f4:	d606                	sw	ra,44(sp)
800042f6:	c62a                	sw	a0,12(sp)
800042f8:	c42e                	sw	a1,8(sp)
    uint32_t tmp;
    uint8_t osc;
    uint16_t div;

    /* disable all interrupts */
    ptr->IER = 0;
800042fa:	47b2                	lw	a5,12(sp)
800042fc:	0207a223          	sw	zero,36(a5)
    /* Set DLAB to 1 */
    ptr->LCR |= UART_LCR_DLAB_MASK;
80004300:	47b2                	lw	a5,12(sp)
80004302:	57dc                	lw	a5,44(a5)
80004304:	0807e713          	ori	a4,a5,128
80004308:	47b2                	lw	a5,12(sp)
8000430a:	d7d8                	sw	a4,44(a5)

    if (!uart_calculate_baudrate(config->src_freq_in_hz, config->baudrate, &div, &osc)) {
8000430c:	47a2                	lw	a5,8(sp)
8000430e:	4398                	lw	a4,0(a5)
80004310:	47a2                	lw	a5,8(sp)
80004312:	43dc                	lw	a5,4(a5)
80004314:	01b10693          	addi	a3,sp,27
80004318:	0830                	addi	a2,sp,24
8000431a:	85be                	mv	a1,a5
8000431c:	853a                	mv	a0,a4
8000431e:	3b8d                	jal	80004090 <uart_calculate_baudrate>
80004320:	87aa                	mv	a5,a0
80004322:	0017c793          	xori	a5,a5,1
80004326:	0ff7f793          	zext.b	a5,a5
8000432a:	c781                	beqz	a5,80004332 <.L27>
        return status_uart_no_suitable_baudrate_parameter_found;
8000432c:	3e900793          	li	a5,1001
80004330:	a251                	j	800044b4 <.L44>

80004332 <.L27>:
    }
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
80004332:	47b2                	lw	a5,12(sp)
80004334:	4bdc                	lw	a5,20(a5)
80004336:	fe07f713          	andi	a4,a5,-32
        | UART_OSCR_OSC_SET(osc);
8000433a:	01b14783          	lbu	a5,27(sp)
8000433e:	8bfd                	andi	a5,a5,31
80004340:	8f5d                	or	a4,a4,a5
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
80004342:	47b2                	lw	a5,12(sp)
80004344:	cbd8                	sw	a4,20(a5)
    ptr->DLL = UART_DLL_DLL_SET(div >> 0);
80004346:	01815783          	lhu	a5,24(sp)
8000434a:	0ff7f713          	zext.b	a4,a5
8000434e:	47b2                	lw	a5,12(sp)
80004350:	d398                	sw	a4,32(a5)
    ptr->DLM = UART_DLM_DLM_SET(div >> 8);
80004352:	01815783          	lhu	a5,24(sp)
80004356:	83a1                	srli	a5,a5,0x8
80004358:	0807c7b3          	zext.h	a5,a5
8000435c:	0ff7f713          	zext.b	a4,a5
80004360:	47b2                	lw	a5,12(sp)
80004362:	d3d8                	sw	a4,36(a5)

    /* DLAB bit needs to be cleared once baudrate is configured */
    tmp = ptr->LCR & (~UART_LCR_DLAB_MASK);
80004364:	47b2                	lw	a5,12(sp)
80004366:	57dc                	lw	a5,44(a5)
80004368:	f7f7f793          	andi	a5,a5,-129
8000436c:	ce3e                	sw	a5,28(sp)

    tmp &= ~(UART_LCR_SPS_MASK | UART_LCR_EPS_MASK | UART_LCR_PEN_MASK);
8000436e:	47f2                	lw	a5,28(sp)
80004370:	fc77f793          	andi	a5,a5,-57
80004374:	ce3e                	sw	a5,28(sp)
    switch (config->parity) {
80004376:	47a2                	lw	a5,8(sp)
80004378:	00a7c783          	lbu	a5,10(a5)
8000437c:	4711                	li	a4,4
8000437e:	02f76d63          	bltu	a4,a5,800043b8 <.L29>
80004382:	00279713          	slli	a4,a5,0x2
80004386:	cec18793          	addi	a5,gp,-788 # 8000357c <.L31>
8000438a:	97ba                	add	a5,a5,a4
8000438c:	439c                	lw	a5,0(a5)
8000438e:	8782                	jr	a5

80004390 <.L34>:
    case parity_none:
        break;
    case parity_odd:
        tmp |= UART_LCR_PEN_MASK;
80004390:	47f2                	lw	a5,28(sp)
80004392:	0087e793          	ori	a5,a5,8
80004396:	ce3e                	sw	a5,28(sp)
        break;
80004398:	a01d                	j	800043be <.L36>

8000439a <.L33>:
    case parity_even:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_EPS_MASK;
8000439a:	47f2                	lw	a5,28(sp)
8000439c:	0187e793          	ori	a5,a5,24
800043a0:	ce3e                	sw	a5,28(sp)
        break;
800043a2:	a831                	j	800043be <.L36>

800043a4 <.L32>:
    case parity_always_1:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_SPS_MASK;
800043a4:	47f2                	lw	a5,28(sp)
800043a6:	0287e793          	ori	a5,a5,40
800043aa:	ce3e                	sw	a5,28(sp)
        break;
800043ac:	a809                	j	800043be <.L36>

800043ae <.L30>:
    case parity_always_0:
        tmp |= UART_LCR_EPS_MASK | UART_LCR_PEN_MASK
800043ae:	47f2                	lw	a5,28(sp)
800043b0:	0387e793          	ori	a5,a5,56
800043b4:	ce3e                	sw	a5,28(sp)
            | UART_LCR_SPS_MASK;
        break;
800043b6:	a021                	j	800043be <.L36>

800043b8 <.L29>:
    default:
        /* invalid configuration */
        return status_invalid_argument;
800043b8:	4789                	li	a5,2
800043ba:	a8ed                	j	800044b4 <.L44>

800043bc <.L45>:
        break;
800043bc:	0001                	nop

800043be <.L36>:
    }

    tmp &= ~(UART_LCR_STB_MASK | UART_LCR_WLS_MASK);
800043be:	47f2                	lw	a5,28(sp)
800043c0:	9be1                	andi	a5,a5,-8
800043c2:	ce3e                	sw	a5,28(sp)
    switch (config->num_of_stop_bits) {
800043c4:	47a2                	lw	a5,8(sp)
800043c6:	0087c783          	lbu	a5,8(a5)
800043ca:	4709                	li	a4,2
800043cc:	00e78e63          	beq	a5,a4,800043e8 <.L37>
800043d0:	4709                	li	a4,2
800043d2:	02f74663          	blt	a4,a5,800043fe <.L38>
800043d6:	c795                	beqz	a5,80004402 <.L46>
800043d8:	4705                	li	a4,1
800043da:	02e79263          	bne	a5,a4,800043fe <.L38>
    case stop_bits_1:
        break;
    case stop_bits_1_5:
        tmp |= UART_LCR_STB_MASK;
800043de:	47f2                	lw	a5,28(sp)
800043e0:	0047e793          	ori	a5,a5,4
800043e4:	ce3e                	sw	a5,28(sp)
        break;
800043e6:	a839                	j	80004404 <.L41>

800043e8 <.L37>:
    case stop_bits_2:
        if (config->word_length < word_length_6_bits) {
800043e8:	47a2                	lw	a5,8(sp)
800043ea:	0097c783          	lbu	a5,9(a5)
800043ee:	e399                	bnez	a5,800043f4 <.L42>
            /* invalid configuration */
            return status_invalid_argument;
800043f0:	4789                	li	a5,2
800043f2:	a0c9                	j	800044b4 <.L44>

800043f4 <.L42>:
        }
        tmp |= UART_LCR_STB_MASK;
800043f4:	47f2                	lw	a5,28(sp)
800043f6:	0047e793          	ori	a5,a5,4
800043fa:	ce3e                	sw	a5,28(sp)
        break;
800043fc:	a021                	j	80004404 <.L41>

800043fe <.L38>:
    default:
        /* invalid configuration */
        return status_invalid_argument;
800043fe:	4789                	li	a5,2
80004400:	a855                	j	800044b4 <.L44>

80004402 <.L46>:
        break;
80004402:	0001                	nop

80004404 <.L41>:
    }

    ptr->LCR = tmp | UART_LCR_WLS_SET(config->word_length);
80004404:	47a2                	lw	a5,8(sp)
80004406:	0097c783          	lbu	a5,9(a5)
8000440a:	0037f713          	andi	a4,a5,3
8000440e:	47f2                	lw	a5,28(sp)
80004410:	8f5d                	or	a4,a4,a5
80004412:	47b2                	lw	a5,12(sp)
80004414:	d7d8                	sw	a4,44(a5)

#if defined(HPM_IP_FEATURE_UART_FINE_FIFO_THRLD) && (HPM_IP_FEATURE_UART_FINE_FIFO_THRLD == 1)
    /* reset TX and RX fifo */
    ptr->FCRR = UART_FCRR_TFIFORST_MASK | UART_FCRR_RFIFORST_MASK;
80004416:	47b2                	lw	a5,12(sp)
80004418:	4719                	li	a4,6
8000441a:	cf98                	sw	a4,24(a5)
    /* Enable FIFO */
    ptr->FCRR = UART_FCRR_FIFOT4EN_MASK
        | UART_FCRR_FIFOE_SET(config->fifo_enable)
8000441c:	47a2                	lw	a5,8(sp)
8000441e:	00e7c783          	lbu	a5,14(a5)
80004422:	86be                	mv	a3,a5
        | UART_FCRR_TFIFOT4_SET(config->tx_fifo_level)
80004424:	47a2                	lw	a5,8(sp)
80004426:	00b7c783          	lbu	a5,11(a5)
8000442a:	01079713          	slli	a4,a5,0x10
8000442e:	001f07b7          	lui	a5,0x1f0
80004432:	8ff9                	and	a5,a5,a4
80004434:	00f6e733          	or	a4,a3,a5
        | UART_FCRR_RFIFOT4_SET(config->rx_fifo_level)
80004438:	47a2                	lw	a5,8(sp)
8000443a:	00c7c783          	lbu	a5,12(a5) # 1f000c <_flash_size+0xf000c>
8000443e:	00879693          	slli	a3,a5,0x8
80004442:	6789                	lui	a5,0x2
80004444:	f0078793          	addi	a5,a5,-256 # 1f00 <__NOR_CFG_OPTION_segment_size__+0x1300>
80004448:	8ff5                	and	a5,a5,a3
8000444a:	8f5d                	or	a4,a4,a5
#if defined(HPM_IP_FEATURE_UART_DISABLE_DMA_TIMEOUT) && (HPM_IP_FEATURE_UART_DISABLE_DMA_TIMEOUT == 1)
        | UART_FCRR_TMOUT_RXDMA_DIS_MASK /**< disable RX timeout trigger dma */
#endif
        | UART_FCRR_DMAE_SET(config->dma_enable);
8000444c:	47a2                	lw	a5,8(sp)
8000444e:	00d7c783          	lbu	a5,13(a5)
80004452:	078e                	slli	a5,a5,0x3
80004454:	8ba1                	andi	a5,a5,8
80004456:	8f5d                	or	a4,a4,a5
80004458:	008007b7          	lui	a5,0x800
8000445c:	8f5d                	or	a4,a4,a5
    ptr->FCRR = UART_FCRR_FIFOT4EN_MASK
8000445e:	47b2                	lw	a5,12(sp)
80004460:	cf98                	sw	a4,24(a5)
    ptr->FCR = tmp;
    /* store FCR register value */
    ptr->GPR = tmp;
#endif

    uart_modem_config(ptr, &config->modem_config);
80004462:	47a2                	lw	a5,8(sp)
80004464:	07bd                	addi	a5,a5,15 # 80000f <_flash_size+0x70000f>
80004466:	85be                	mv	a1,a5
80004468:	4532                	lw	a0,12(sp)
8000446a:	058020ef          	jal	800064c2 <uart_modem_config>

#if defined(HPM_IP_FEATURE_UART_RX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_RX_IDLE_DETECT == 1)
    uart_init_rxline_idle_detection(ptr, config->rxidle_config);
8000446e:	47a2                	lw	a5,8(sp)
80004470:	0127d703          	lhu	a4,18(a5)
80004474:	0147d783          	lhu	a5,20(a5)
80004478:	07c2                	slli	a5,a5,0x10
8000447a:	8fd9                	or	a5,a5,a4
8000447c:	873e                	mv	a4,a5
8000447e:	85ba                	mv	a1,a4
80004480:	4532                	lw	a0,12(sp)
80004482:	184020ef          	jal	80006606 <uart_init_rxline_idle_detection>
#endif

#if defined(HPM_IP_FEATURE_UART_TX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_TX_IDLE_DETECT == 1)
    uart_init_txline_idle_detection(ptr, config->txidle_config);
80004486:	47a2                	lw	a5,8(sp)
80004488:	0167d703          	lhu	a4,22(a5)
8000448c:	0187d783          	lhu	a5,24(a5)
80004490:	07c2                	slli	a5,a5,0x10
80004492:	8fd9                	or	a5,a5,a4
80004494:	873e                	mv	a4,a5
80004496:	85ba                	mv	a1,a4
80004498:	4532                	lw	a0,12(sp)
8000449a:	2885                	jal	8000450a <uart_init_txline_idle_detection>
#endif

#if defined(HPM_IP_FEATURE_UART_RX_EN) && (HPM_IP_FEATURE_UART_RX_EN == 1)
    if (config->rx_enable) {
8000449c:	47a2                	lw	a5,8(sp)
8000449e:	01a7c783          	lbu	a5,26(a5)
800044a2:	cb81                	beqz	a5,800044b2 <.L43>
        ptr->IDLE_CFG |= UART_IDLE_CFG_RXEN_MASK;
800044a4:	47b2                	lw	a5,12(sp)
800044a6:	43d8                	lw	a4,4(a5)
800044a8:	28b01793          	bseti	a5,zero,0xb
800044ac:	8f5d                	or	a4,a4,a5
800044ae:	47b2                	lw	a5,12(sp)
800044b0:	c3d8                	sw	a4,4(a5)

800044b2 <.L43>:
    }
#endif
    return status_success;
800044b2:	4781                	li	a5,0

800044b4 <.L44>:
}
800044b4:	853e                	mv	a0,a5
800044b6:	50b2                	lw	ra,44(sp)
800044b8:	6145                	addi	sp,sp,48
800044ba:	8082                	ret

Disassembly of section .text.uart_send_byte:

800044bc <uart_send_byte>:

    return status_success;
}

hpm_stat_t uart_send_byte(UART_Type *ptr, uint8_t c)
{
800044bc:	1101                	addi	sp,sp,-32
800044be:	c62a                	sw	a0,12(sp)
800044c0:	87ae                	mv	a5,a1
800044c2:	00f105a3          	sb	a5,11(sp)
    uint32_t retry = 0;
800044c6:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
800044c8:	a811                	j	800044dc <.L52>

800044ca <.L55>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
800044ca:	4772                	lw	a4,28(sp)
800044cc:	6785                	lui	a5,0x1
800044ce:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
800044d2:	00e7eb63          	bltu	a5,a4,800044e8 <.L58>
            break;
        }
        retry++;
800044d6:	47f2                	lw	a5,28(sp)
800044d8:	0785                	addi	a5,a5,1
800044da:	ce3e                	sw	a5,28(sp)

800044dc <.L52>:
    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
800044dc:	47b2                	lw	a5,12(sp)
800044de:	5bdc                	lw	a5,52(a5)
800044e0:	0207f793          	andi	a5,a5,32
800044e4:	d3fd                	beqz	a5,800044ca <.L55>
800044e6:	a011                	j	800044ea <.L54>

800044e8 <.L58>:
            break;
800044e8:	0001                	nop

800044ea <.L54>:
    }

    if (retry > HPM_UART_DRV_RETRY_COUNT) {
800044ea:	4772                	lw	a4,28(sp)
800044ec:	6785                	lui	a5,0x1
800044ee:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
800044f2:	00e7f463          	bgeu	a5,a4,800044fa <.L56>
        return status_timeout;
800044f6:	478d                	li	a5,3
800044f8:	a031                	j	80004504 <.L57>

800044fa <.L56>:
    }

    ptr->THR = UART_THR_THR_SET(c);
800044fa:	00b14703          	lbu	a4,11(sp)
800044fe:	47b2                	lw	a5,12(sp)
80004500:	d398                	sw	a4,32(a5)
    return status_success;
80004502:	4781                	li	a5,0

80004504 <.L57>:
}
80004504:	853e                	mv	a0,a5
80004506:	6105                	addi	sp,sp,32
80004508:	8082                	ret

Disassembly of section .text.uart_init_txline_idle_detection:

8000450a <uart_init_txline_idle_detection>:
}
#endif

#if defined(HPM_IP_FEATURE_UART_TX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_TX_IDLE_DETECT == 1)
hpm_stat_t uart_init_txline_idle_detection(UART_Type *ptr, uart_rxline_idle_config_t txidle_config)
{
8000450a:	1101                	addi	sp,sp,-32
8000450c:	ce06                	sw	ra,28(sp)
8000450e:	c62a                	sw	a0,12(sp)
80004510:	c42e                	sw	a1,8(sp)
    ptr->IDLE_CFG &= ~(UART_IDLE_CFG_TX_IDLE_EN_MASK
80004512:	47b2                	lw	a5,12(sp)
80004514:	43d8                	lw	a4,4(a5)
80004516:	fc0107b7          	lui	a5,0xfc010
8000451a:	17fd                	addi	a5,a5,-1 # fc00ffff <__AHB_SRAM_segment_end__+0xbc07fff>
8000451c:	8f7d                	and	a4,a4,a5
8000451e:	47b2                	lw	a5,12(sp)
80004520:	c3d8                	sw	a4,4(a5)
                    | UART_IDLE_CFG_TX_IDLE_THR_MASK
                    | UART_IDLE_CFG_TX_IDLE_COND_MASK);
    ptr->IDLE_CFG |= UART_IDLE_CFG_TX_IDLE_EN_SET(txidle_config.detect_enable)
80004522:	47b2                	lw	a5,12(sp)
80004524:	43d8                	lw	a4,4(a5)
80004526:	00814783          	lbu	a5,8(sp)
8000452a:	01879693          	slli	a3,a5,0x18
8000452e:	010007b7          	lui	a5,0x1000
80004532:	8efd                	and	a3,a3,a5
                    | UART_IDLE_CFG_TX_IDLE_THR_SET(txidle_config.threshold)
80004534:	00b14783          	lbu	a5,11(sp)
80004538:	01079613          	slli	a2,a5,0x10
8000453c:	00ff07b7          	lui	a5,0xff0
80004540:	8ff1                	and	a5,a5,a2
80004542:	8edd                	or	a3,a3,a5
                    | UART_IDLE_CFG_TX_IDLE_COND_SET(txidle_config.idle_cond);
80004544:	00a14783          	lbu	a5,10(sp)
80004548:	01979613          	slli	a2,a5,0x19
8000454c:	020007b7          	lui	a5,0x2000
80004550:	8ff1                	and	a5,a5,a2
80004552:	8fd5                	or	a5,a5,a3
    ptr->IDLE_CFG |= UART_IDLE_CFG_TX_IDLE_EN_SET(txidle_config.detect_enable)
80004554:	8f5d                	or	a4,a4,a5
80004556:	47b2                	lw	a5,12(sp)
80004558:	c3d8                	sw	a4,4(a5)

    if (txidle_config.detect_irq_enable) {
8000455a:	00914783          	lbu	a5,9(sp)
8000455e:	c799                	beqz	a5,8000456c <.L97>
        uart_enable_irq(ptr, uart_intr_tx_line_idle);
80004560:	400005b7          	lui	a1,0x40000
80004564:	4532                	lw	a0,12(sp)
80004566:	7b5010ef          	jal	8000651a <uart_enable_irq>
8000456a:	a031                	j	80004576 <.L98>

8000456c <.L97>:
    } else {
        uart_disable_irq(ptr, uart_intr_tx_line_idle);
8000456c:	400005b7          	lui	a1,0x40000
80004570:	4532                	lw	a0,12(sp)
80004572:	78d010ef          	jal	800064fe <uart_disable_irq>

80004576 <.L98>:
    }

    return status_success;
80004576:	4781                	li	a5,0
}
80004578:	853e                	mv	a0,a5
8000457a:	40f2                	lw	ra,28(sp)
8000457c:	6105                	addi	sp,sp,32
8000457e:	8082                	ret

Disassembly of section .text.pllctlv2_pll_is_stable:

80004580 <pllctlv2_pll_is_stable>:
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @param [in] pll Index of the PLL to check (pllctlv2_pll0 through pllctlv2_pll6)
 * @return true if the PLL is stable and locked, false otherwise
 */
static inline bool pllctlv2_pll_is_stable(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll)
{
80004580:	1101                	addi	sp,sp,-32
80004582:	c62a                	sw	a0,12(sp)
80004584:	87ae                	mv	a5,a1
80004586:	00f105a3          	sb	a5,11(sp)
    uint32_t status = ptr->PLL[pll].MFI;
8000458a:	00b14783          	lbu	a5,11(sp)
8000458e:	4732                	lw	a4,12(sp)
80004590:	0785                	addi	a5,a5,1 # 2000001 <_flash_size+0x1f00001>
80004592:	079e                	slli	a5,a5,0x7
80004594:	97ba                	add	a5,a5,a4
80004596:	439c                	lw	a5,0(a5)
80004598:	ce3e                	sw	a5,28(sp)
    return (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_MFI_ENABLE_MASK)
8000459a:	4772                	lw	a4,28(sp)
8000459c:	100007b7          	lui	a5,0x10000
800045a0:	8ff9                	and	a5,a5,a4
         || (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_MFI_BUSY_MASK) && IS_HPM_BITMASK_SET(status, PLLCTLV2_PLL_MFI_RESPONSE_MASK)));
800045a2:	cb89                	beqz	a5,800045b4 <.L2>
800045a4:	47f2                	lw	a5,28(sp)
800045a6:	0007c963          	bltz	a5,800045b8 <.L3>
800045aa:	4772                	lw	a4,28(sp)
800045ac:	200007b7          	lui	a5,0x20000
800045b0:	8ff9                	and	a5,a5,a4
800045b2:	c399                	beqz	a5,800045b8 <.L3>

800045b4 <.L2>:
800045b4:	4785                	li	a5,1
800045b6:	a011                	j	800045ba <.L4>

800045b8 <.L3>:
800045b8:	4781                	li	a5,0

800045ba <.L4>:
800045ba:	8b85                	andi	a5,a5,1
800045bc:	0ff7f793          	zext.b	a5,a5
}
800045c0:	853e                	mv	a0,a5
800045c2:	6105                	addi	sp,sp,32
800045c4:	8082                	ret

Disassembly of section .text.pllctlv2_init_pll_with_freq:

800045c6 <pllctlv2_init_pll_with_freq>:
    }
    return status;
}

hpm_stat_t pllctlv2_init_pll_with_freq(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, uint32_t freq_in_hz)
{
800045c6:	7179                	addi	sp,sp,-48
800045c8:	d606                	sw	ra,44(sp)
800045ca:	c62a                	sw	a0,12(sp)
800045cc:	87ae                	mv	a5,a1
800045ce:	c232                	sw	a2,4(sp)
800045d0:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status;
    if ((ptr == NULL) || (freq_in_hz < PLLCTLV2_PLL_FREQ_MIN) || (freq_in_hz > PLLCTLV2_PLL_FREQ_MAX) ||
800045d4:	47b2                	lw	a5,12(sp)
800045d6:	c395                	beqz	a5,800045fa <.L19>
800045d8:	4712                	lw	a4,4(sp)
800045da:	16e367b7          	lui	a5,0x16e36
800045de:	00f76e63          	bltu	a4,a5,800045fa <.L19>
800045e2:	4712                	lw	a4,4(sp)
800045e4:	3d8317b7          	lui	a5,0x3d831
800045e8:	20078793          	addi	a5,a5,512 # 3d831200 <_flash_size+0x3d731200>
800045ec:	00e7e763          	bltu	a5,a4,800045fa <.L19>
800045f0:	00b14703          	lbu	a4,11(sp)
800045f4:	4785                	li	a5,1
800045f6:	00e7f563          	bgeu	a5,a4,80004600 <.L20>

800045fa <.L19>:
        (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
        status = status_invalid_argument;
800045fa:	4789                	li	a5,2
800045fc:	ce3e                	sw	a5,28(sp)
800045fe:	a8bd                	j	8000467c <.L21>

80004600 <.L20>:
    } else {
        uint32_t mfn = freq_in_hz % PLLCTLV2_PLL_XTAL_FREQ;
80004600:	4792                	lw	a5,4(sp)
80004602:	165ea737          	lui	a4,0x165ea
80004606:	f8170713          	addi	a4,a4,-127 # 165e9f81 <_flash_size+0x164e9f81>
8000460a:	02e7b733          	mulhu	a4,a5,a4
8000460e:	01575693          	srli	a3,a4,0x15
80004612:	016e3737          	lui	a4,0x16e3
80004616:	60070713          	addi	a4,a4,1536 # 16e3600 <_flash_size+0x15e3600>
8000461a:	02e68733          	mul	a4,a3,a4
8000461e:	8f99                	sub	a5,a5,a4
80004620:	cc3e                	sw	a5,24(sp)
        uint32_t mfi = freq_in_hz / PLLCTLV2_PLL_XTAL_FREQ;
80004622:	4712                	lw	a4,4(sp)
80004624:	165ea7b7          	lui	a5,0x165ea
80004628:	f8178793          	addi	a5,a5,-127 # 165e9f81 <_flash_size+0x164e9f81>
8000462c:	02f737b3          	mulhu	a5,a4,a5
80004630:	83d5                	srli	a5,a5,0x15
80004632:	ca3e                	sw	a5,20(sp)

        /*
         * NOTE: Default MFD value is 240M
         */
        ptr->PLL[pll].MFN = mfn * PLLCTLV2_PLL_MFN_FACTOR;
80004634:	00b14683          	lbu	a3,11(sp)
80004638:	4762                	lw	a4,24(sp)
8000463a:	87ba                	mv	a5,a4
8000463c:	078a                	slli	a5,a5,0x2
8000463e:	97ba                	add	a5,a5,a4
80004640:	0786                	slli	a5,a5,0x1
80004642:	863e                	mv	a2,a5
80004644:	4732                	lw	a4,12(sp)
80004646:	00168793          	addi	a5,a3,1
8000464a:	079e                	slli	a5,a5,0x7
8000464c:	97ba                	add	a5,a5,a4
8000464e:	c3d0                	sw	a2,4(a5)
        ptr->PLL[pll].MFI = mfi;
80004650:	00b14783          	lbu	a5,11(sp)
80004654:	4732                	lw	a4,12(sp)
80004656:	0785                	addi	a5,a5,1
80004658:	079e                	slli	a5,a5,0x7
8000465a:	97ba                	add	a5,a5,a4
8000465c:	4752                	lw	a4,20(sp)
8000465e:	c398                	sw	a4,0(a5)


        while (!pllctlv2_pll_is_stable(ptr, pll)) {
80004660:	a011                	j	80004664 <.L22>

80004662 <.L23>:
            NOP();
80004662:	0001                	nop

80004664 <.L22>:
        while (!pllctlv2_pll_is_stable(ptr, pll)) {
80004664:	00b14783          	lbu	a5,11(sp)
80004668:	85be                	mv	a1,a5
8000466a:	4532                	lw	a0,12(sp)
8000466c:	3f11                	jal	80004580 <pllctlv2_pll_is_stable>
8000466e:	87aa                	mv	a5,a0
80004670:	0017c793          	xori	a5,a5,1
80004674:	0ff7f793          	zext.b	a5,a5
80004678:	f7ed                	bnez	a5,80004662 <.L23>
        }

        status = status_success;
8000467a:	ce02                	sw	zero,28(sp)

8000467c <.L21>:
    }
    return status;
8000467c:	47f2                	lw	a5,28(sp)
}
8000467e:	853e                	mv	a0,a5
80004680:	50b2                	lw	ra,44(sp)
80004682:	6145                	addi	sp,sp,48
80004684:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_xtoa:

80004686 <__SEGGER_RTL_xtoa>:
80004686:	882e                	mv	a6,a1
80004688:	ca91                	beqz	a3,8000469c <__SEGGER_RTL_xtoa+0x16>
8000468a:	00180693          	addi	a3,a6,1
8000468e:	02d00593          	li	a1,45
80004692:	00b80023          	sb	a1,0(a6)
80004696:	40a00533          	neg	a0,a0
8000469a:	a011                	j	8000469e <__SEGGER_RTL_xtoa+0x18>
8000469c:	86c2                	mv	a3,a6
8000469e:	ffe68713          	addi	a4,a3,-2
800046a2:	48a5                	li	a7,9
800046a4:	85aa                	mv	a1,a0
800046a6:	02c55533          	divu	a0,a0,a2
800046aa:	02c507b3          	mul	a5,a0,a2
800046ae:	40f587b3          	sub	a5,a1,a5
800046b2:	00f8e563          	bltu	a7,a5,800046bc <__SEGGER_RTL_xtoa+0x36>
800046b6:	03078793          	addi	a5,a5,48
800046ba:	a019                	j	800046c0 <__SEGGER_RTL_xtoa+0x3a>
800046bc:	05778793          	addi	a5,a5,87
800046c0:	00f70123          	sb	a5,2(a4)
800046c4:	0705                	addi	a4,a4,1
800046c6:	fcc5ffe3          	bgeu	a1,a2,800046a4 <__SEGGER_RTL_xtoa+0x1e>
800046ca:	00070123          	sb	zero,2(a4)
800046ce:	0006c503          	lbu	a0,0(a3)
800046d2:	85ba                	mv	a1,a4
800046d4:	00174603          	lbu	a2,1(a4)
800046d8:	00a700a3          	sb	a0,1(a4)
800046dc:	00168513          	addi	a0,a3,1
800046e0:	00c68023          	sb	a2,0(a3)
800046e4:	177d                	addi	a4,a4,-1
800046e6:	86aa                	mv	a3,a0
800046e8:	feb563e3          	bltu	a0,a1,800046ce <__SEGGER_RTL_xtoa+0x48>
800046ec:	8542                	mv	a0,a6
800046ee:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_X_assert:

800046f0 <__SEGGER_RTL_X_assert>:
800046f0:	1101                	addi	sp,sp,-32
800046f2:	ce06                	sw	ra,28(sp)
800046f4:	cc22                	sw	s0,24(sp)
800046f6:	ca26                	sw	s1,20(sp)
800046f8:	86b2                	mv	a3,a2
800046fa:	842e                	mv	s0,a1
800046fc:	84aa                	mv	s1,a0
800046fe:	004c                	addi	a1,sp,4
80004700:	4629                	li	a2,10
80004702:	8536                	mv	a0,a3
80004704:	3de020ef          	jal	80006ae2 <itoa>
80004708:	8522                	mv	a0,s0
8000470a:	466020ef          	jal	80006b70 <__SEGGER_RTL_puts_no_nl>
8000470e:	80008537          	lui	a0,0x80008
80004712:	bf950513          	addi	a0,a0,-1031 # 80007bf9 <.L.str>
80004716:	45a020ef          	jal	80006b70 <__SEGGER_RTL_puts_no_nl>
8000471a:	0048                	addi	a0,sp,4
8000471c:	454020ef          	jal	80006b70 <__SEGGER_RTL_puts_no_nl>
80004720:	80008537          	lui	a0,0x80008
80004724:	c3b50513          	addi	a0,a0,-965 # 80007c3b <.L.str.1>
80004728:	448020ef          	jal	80006b70 <__SEGGER_RTL_puts_no_nl>
8000472c:	8526                	mv	a0,s1
8000472e:	442020ef          	jal	80006b70 <__SEGGER_RTL_puts_no_nl>
80004732:	80008537          	lui	a0,0x80008
80004736:	bfb50513          	addi	a0,a0,-1029 # 80007bfb <.L.str.2>
8000473a:	436020ef          	jal	80006b70 <__SEGGER_RTL_puts_no_nl>
8000473e:	3d0020ef          	jal	80006b0e <abort>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_IGN:

80004742 <__SEGGER_RTL_SIGNAL_SIG_IGN>:
80004742:	8082                	ret

Disassembly of section .text.libc.__subsf3:

80004744 <__subsf3>:
80004744:	80000637          	lui	a2,0x80000
80004748:	8db1                	xor	a1,a1,a2
8000474a:	a009                	j	8000474c <__addsf3>

Disassembly of section .text.libc.__addsf3:

8000474c <__addsf3>:
8000474c:	80000637          	lui	a2,0x80000
80004750:	00b546b3          	xor	a3,a0,a1
80004754:	0806ca63          	bltz	a3,800047e8 <.L__addsf3_subtract>
80004758:	00b57563          	bgeu	a0,a1,80004762 <.L__addsf3_add_already_ordered>
8000475c:	86aa                	mv	a3,a0
8000475e:	852e                	mv	a0,a1
80004760:	85b6                	mv	a1,a3

80004762 <.L__addsf3_add_already_ordered>:
80004762:	00151713          	slli	a4,a0,0x1
80004766:	8361                	srli	a4,a4,0x18
80004768:	00159693          	slli	a3,a1,0x1
8000476c:	82e1                	srli	a3,a3,0x18
8000476e:	0ff00293          	li	t0,255
80004772:	06570563          	beq	a4,t0,800047dc <.L__addsf3_add_inf_or_nan>
80004776:	c325                	beqz	a4,800047d6 <.L__addsf3_zero>
80004778:	ceb1                	beqz	a3,800047d4 <.L__addsf3_add_done>
8000477a:	40d706b3          	sub	a3,a4,a3
8000477e:	42e1                	li	t0,24
80004780:	04d2ca63          	blt	t0,a3,800047d4 <.L__addsf3_add_done>
80004784:	05a2                	slli	a1,a1,0x8
80004786:	8dd1                	or	a1,a1,a2
80004788:	01755713          	srli	a4,a0,0x17
8000478c:	0522                	slli	a0,a0,0x8
8000478e:	8d51                	or	a0,a0,a2
80004790:	47e5                	li	a5,25
80004792:	8f95                	sub	a5,a5,a3
80004794:	00f59633          	sll	a2,a1,a5
80004798:	821d                	srli	a2,a2,0x7
8000479a:	00d5d5b3          	srl	a1,a1,a3
8000479e:	00b507b3          	add	a5,a0,a1
800047a2:	00a7f463          	bgeu	a5,a0,800047aa <.L__addsf3_add_no_normalization>
800047a6:	8385                	srli	a5,a5,0x1
800047a8:	0709                	addi	a4,a4,2

800047aa <.L__addsf3_add_no_normalization>:
800047aa:	177d                	addi	a4,a4,-1
800047ac:	0ff77593          	zext.b	a1,a4
800047b0:	f0158593          	addi	a1,a1,-255 # 3fffff01 <_flash_size+0x3fefff01>
800047b4:	cd91                	beqz	a1,800047d0 <.L__addsf3_inf>
800047b6:	075e                	slli	a4,a4,0x17
800047b8:	0087d513          	srli	a0,a5,0x8
800047bc:	07e2                	slli	a5,a5,0x18
800047be:	8fd1                	or	a5,a5,a2
800047c0:	0007d663          	bgez	a5,800047cc <.L__addsf3_no_tie>
800047c4:	0786                	slli	a5,a5,0x1
800047c6:	0505                	addi	a0,a0,1
800047c8:	e391                	bnez	a5,800047cc <.L__addsf3_no_tie>
800047ca:	9979                	andi	a0,a0,-2

800047cc <.L__addsf3_no_tie>:
800047cc:	953a                	add	a0,a0,a4
800047ce:	8082                	ret

800047d0 <.L__addsf3_inf>:
800047d0:	01771513          	slli	a0,a4,0x17

800047d4 <.L__addsf3_add_done>:
800047d4:	8082                	ret

800047d6 <.L__addsf3_zero>:
800047d6:	817d                	srli	a0,a0,0x1f
800047d8:	057e                	slli	a0,a0,0x1f
800047da:	8082                	ret

800047dc <.L__addsf3_add_inf_or_nan>:
800047dc:	00951613          	slli	a2,a0,0x9
800047e0:	da75                	beqz	a2,800047d4 <.L__addsf3_add_done>

800047e2 <.L__addsf3_return_nan>:
800047e2:	7fc00537          	lui	a0,0x7fc00
800047e6:	8082                	ret

800047e8 <.L__addsf3_subtract>:
800047e8:	8db1                	xor	a1,a1,a2
800047ea:	40b506b3          	sub	a3,a0,a1
800047ee:	00b57563          	bgeu	a0,a1,800047f8 <.L__addsf3_sub_already_ordered>
800047f2:	8eb1                	xor	a3,a3,a2
800047f4:	8d15                	sub	a0,a0,a3
800047f6:	95b6                	add	a1,a1,a3

800047f8 <.L__addsf3_sub_already_ordered>:
800047f8:	00159693          	slli	a3,a1,0x1
800047fc:	82e1                	srli	a3,a3,0x18
800047fe:	00151713          	slli	a4,a0,0x1
80004802:	8361                	srli	a4,a4,0x18
80004804:	05a2                	slli	a1,a1,0x8
80004806:	8dd1                	or	a1,a1,a2
80004808:	0ff00293          	li	t0,255
8000480c:	0c570c63          	beq	a4,t0,800048e4 <.L__addsf3_sub_inf_or_nan>
80004810:	c2f5                	beqz	a3,800048f4 <.L__addsf3_sub_zero>
80004812:	40d706b3          	sub	a3,a4,a3
80004816:	c695                	beqz	a3,80004842 <.L__addsf3_exponents_equal>
80004818:	4285                	li	t0,1
8000481a:	08569063          	bne	a3,t0,8000489a <.L__addsf3_exponents_differ_by_more_than_1>
8000481e:	01755693          	srli	a3,a0,0x17
80004822:	0526                	slli	a0,a0,0x9
80004824:	00b532b3          	sltu	t0,a0,a1
80004828:	8d0d                	sub	a0,a0,a1
8000482a:	02029263          	bnez	t0,8000484e <.L__addsf3_normalization_steps>
8000482e:	06de                	slli	a3,a3,0x17
80004830:	01751593          	slli	a1,a0,0x17
80004834:	8125                	srli	a0,a0,0x9
80004836:	0005d463          	bgez	a1,8000483e <.L__addsf3_sub_no_tie_single>
8000483a:	0505                	addi	a0,a0,1 # 7fc00001 <_flash_size+0x7fb00001>
8000483c:	9979                	andi	a0,a0,-2

8000483e <.L__addsf3_sub_no_tie_single>:
8000483e:	9536                	add	a0,a0,a3

80004840 <.L__addsf3_sub_done>:
80004840:	8082                	ret

80004842 <.L__addsf3_exponents_equal>:
80004842:	01755693          	srli	a3,a0,0x17
80004846:	0526                	slli	a0,a0,0x9
80004848:	0586                	slli	a1,a1,0x1
8000484a:	8d0d                	sub	a0,a0,a1
8000484c:	d975                	beqz	a0,80004840 <.L__addsf3_sub_done>

8000484e <.L__addsf3_normalization_steps>:
8000484e:	4581                	li	a1,0
80004850:	01055793          	srli	a5,a0,0x10
80004854:	e399                	bnez	a5,8000485a <.Ltmp0>
80004856:	0542                	slli	a0,a0,0x10
80004858:	05c1                	addi	a1,a1,16

8000485a <.Ltmp0>:
8000485a:	01855793          	srli	a5,a0,0x18
8000485e:	e399                	bnez	a5,80004864 <.Ltmp1>
80004860:	0522                	slli	a0,a0,0x8
80004862:	05a1                	addi	a1,a1,8

80004864 <.Ltmp1>:
80004864:	01c55793          	srli	a5,a0,0x1c
80004868:	e399                	bnez	a5,8000486e <.Ltmp2>
8000486a:	0512                	slli	a0,a0,0x4
8000486c:	0591                	addi	a1,a1,4

8000486e <.Ltmp2>:
8000486e:	01e55793          	srli	a5,a0,0x1e
80004872:	e399                	bnez	a5,80004878 <.Ltmp3>
80004874:	050a                	slli	a0,a0,0x2
80004876:	0589                	addi	a1,a1,2

80004878 <.Ltmp3>:
80004878:	00054463          	bltz	a0,80004880 <.Ltmp4>
8000487c:	0506                	slli	a0,a0,0x1
8000487e:	0585                	addi	a1,a1,1

80004880 <.Ltmp4>:
80004880:	0585                	addi	a1,a1,1
80004882:	0506                	slli	a0,a0,0x1
80004884:	00e5f763          	bgeu	a1,a4,80004892 <.L__addsf3_underflow>
80004888:	8e8d                	sub	a3,a3,a1
8000488a:	06de                	slli	a3,a3,0x17
8000488c:	8125                	srli	a0,a0,0x9
8000488e:	9536                	add	a0,a0,a3
80004890:	8082                	ret

80004892 <.L__addsf3_underflow>:
80004892:	0086d513          	srli	a0,a3,0x8
80004896:	057e                	slli	a0,a0,0x1f
80004898:	8082                	ret

8000489a <.L__addsf3_exponents_differ_by_more_than_1>:
8000489a:	42e5                	li	t0,25
8000489c:	fad2e2e3          	bltu	t0,a3,80004840 <.L__addsf3_sub_done>
800048a0:	0685                	addi	a3,a3,1
800048a2:	40d00733          	neg	a4,a3
800048a6:	00e59733          	sll	a4,a1,a4
800048aa:	00d5d5b3          	srl	a1,a1,a3
800048ae:	00e03733          	snez	a4,a4
800048b2:	95ae                	add	a1,a1,a1
800048b4:	95ba                	add	a1,a1,a4
800048b6:	01755693          	srli	a3,a0,0x17
800048ba:	0522                	slli	a0,a0,0x8
800048bc:	8d51                	or	a0,a0,a2
800048be:	40b50733          	sub	a4,a0,a1
800048c2:	00074463          	bltz	a4,800048ca <.L__addsf3_sub_already_normalized>
800048c6:	070a                	slli	a4,a4,0x2
800048c8:	8305                	srli	a4,a4,0x1

800048ca <.L__addsf3_sub_already_normalized>:
800048ca:	16fd                	addi	a3,a3,-1
800048cc:	06de                	slli	a3,a3,0x17
800048ce:	00875513          	srli	a0,a4,0x8
800048d2:	0762                	slli	a4,a4,0x18
800048d4:	00075663          	bgez	a4,800048e0 <.L__addsf3_sub_no_tie>
800048d8:	0706                	slli	a4,a4,0x1
800048da:	0505                	addi	a0,a0,1
800048dc:	e311                	bnez	a4,800048e0 <.L__addsf3_sub_no_tie>
800048de:	9979                	andi	a0,a0,-2

800048e0 <.L__addsf3_sub_no_tie>:
800048e0:	9536                	add	a0,a0,a3
800048e2:	8082                	ret

800048e4 <.L__addsf3_sub_inf_or_nan>:
800048e4:	0ff00293          	li	t0,255
800048e8:	ee568de3          	beq	a3,t0,800047e2 <.L__addsf3_return_nan>
800048ec:	00951593          	slli	a1,a0,0x9
800048f0:	d9a1                	beqz	a1,80004840 <.L__addsf3_sub_done>
800048f2:	bdc5                	j	800047e2 <.L__addsf3_return_nan>

800048f4 <.L__addsf3_sub_zero>:
800048f4:	f731                	bnez	a4,80004840 <.L__addsf3_sub_done>
800048f6:	4501                	li	a0,0
800048f8:	8082                	ret

Disassembly of section .text.libc.__ltsf2:

800048fa <__ltsf2>:
800048fa:	ff000637          	lui	a2,0xff000
800048fe:	00151693          	slli	a3,a0,0x1
80004902:	02d66763          	bltu	a2,a3,80004930 <.L__ltsf2_zero>
80004906:	00159693          	slli	a3,a1,0x1
8000490a:	02d66363          	bltu	a2,a3,80004930 <.L__ltsf2_zero>
8000490e:	00b56633          	or	a2,a0,a1
80004912:	00161693          	slli	a3,a2,0x1
80004916:	ce89                	beqz	a3,80004930 <.L__ltsf2_zero>
80004918:	00064763          	bltz	a2,80004926 <.L__ltsf2_negative>
8000491c:	00b53533          	sltu	a0,a0,a1
80004920:	40a00533          	neg	a0,a0
80004924:	8082                	ret

80004926 <.L__ltsf2_negative>:
80004926:	00a5b533          	sltu	a0,a1,a0
8000492a:	40a00533          	neg	a0,a0
8000492e:	8082                	ret

80004930 <.L__ltsf2_zero>:
80004930:	4501                	li	a0,0
80004932:	8082                	ret

Disassembly of section .text.libc.__gtsf2:

80004934 <__gtsf2>:
80004934:	ff000637          	lui	a2,0xff000
80004938:	00151693          	slli	a3,a0,0x1
8000493c:	02d66363          	bltu	a2,a3,80004962 <.L__gtsf2_zero>
80004940:	00159693          	slli	a3,a1,0x1
80004944:	00d66f63          	bltu	a2,a3,80004962 <.L__gtsf2_zero>
80004948:	00b56633          	or	a2,a0,a1
8000494c:	00161693          	slli	a3,a2,0x1
80004950:	ca89                	beqz	a3,80004962 <.L__gtsf2_zero>
80004952:	00064563          	bltz	a2,8000495c <.L__gtsf2_negative>
80004956:	00a5b533          	sltu	a0,a1,a0
8000495a:	8082                	ret

8000495c <.L__gtsf2_negative>:
8000495c:	00b53533          	sltu	a0,a0,a1
80004960:	8082                	ret

80004962 <.L__gtsf2_zero>:
80004962:	4501                	li	a0,0
80004964:	8082                	ret

Disassembly of section .text.libc.__gesf2:

80004966 <__gesf2>:
80004966:	ff000637          	lui	a2,0xff000
8000496a:	00151693          	slli	a3,a0,0x1
8000496e:	02d66763          	bltu	a2,a3,8000499c <.L__gesf2_nan>
80004972:	00159693          	slli	a3,a1,0x1
80004976:	02d66363          	bltu	a2,a3,8000499c <.L__gesf2_nan>
8000497a:	00b56633          	or	a2,a0,a1
8000497e:	00161693          	slli	a3,a2,0x1
80004982:	ce99                	beqz	a3,800049a0 <.L__gesf2_zero>
80004984:	00064763          	bltz	a2,80004992 <.L__gesf2_negative>
80004988:	00b53533          	sltu	a0,a0,a1
8000498c:	40a00533          	neg	a0,a0
80004990:	8082                	ret

80004992 <.L__gesf2_negative>:
80004992:	00a5b533          	sltu	a0,a1,a0
80004996:	40a00533          	neg	a0,a0
8000499a:	8082                	ret

8000499c <.L__gesf2_nan>:
8000499c:	557d                	li	a0,-1
8000499e:	8082                	ret

800049a0 <.L__gesf2_zero>:
800049a0:	4501                	li	a0,0
800049a2:	8082                	ret

Disassembly of section .text.libc.__floatundisf:

800049a4 <__floatundisf>:
800049a4:	c5bd                	beqz	a1,80004a12 <.L__floatundisf_high_word_zero>
800049a6:	4701                	li	a4,0
800049a8:	0105d693          	srli	a3,a1,0x10
800049ac:	e299                	bnez	a3,800049b2 <.Ltmp45>
800049ae:	0741                	addi	a4,a4,16
800049b0:	05c2                	slli	a1,a1,0x10

800049b2 <.Ltmp45>:
800049b2:	0185d693          	srli	a3,a1,0x18
800049b6:	e299                	bnez	a3,800049bc <.Ltmp46>
800049b8:	0721                	addi	a4,a4,8
800049ba:	05a2                	slli	a1,a1,0x8

800049bc <.Ltmp46>:
800049bc:	01c5d693          	srli	a3,a1,0x1c
800049c0:	e299                	bnez	a3,800049c6 <.Ltmp47>
800049c2:	0711                	addi	a4,a4,4
800049c4:	0592                	slli	a1,a1,0x4

800049c6 <.Ltmp47>:
800049c6:	01e5d693          	srli	a3,a1,0x1e
800049ca:	e299                	bnez	a3,800049d0 <.Ltmp48>
800049cc:	0709                	addi	a4,a4,2
800049ce:	058a                	slli	a1,a1,0x2

800049d0 <.Ltmp48>:
800049d0:	0005c463          	bltz	a1,800049d8 <.Ltmp49>
800049d4:	0705                	addi	a4,a4,1
800049d6:	0586                	slli	a1,a1,0x1

800049d8 <.Ltmp49>:
800049d8:	fff74613          	not	a2,a4
800049dc:	00c556b3          	srl	a3,a0,a2
800049e0:	8285                	srli	a3,a3,0x1
800049e2:	8dd5                	or	a1,a1,a3
800049e4:	00e51533          	sll	a0,a0,a4
800049e8:	0be60613          	addi	a2,a2,190 # ff0000be <__AHB_SRAM_segment_end__+0xebf80be>
800049ec:	00a03533          	snez	a0,a0
800049f0:	8dc9                	or	a1,a1,a0

800049f2 <.L__floatundisf_round_and_pack>:
800049f2:	065e                	slli	a2,a2,0x17
800049f4:	0085d513          	srli	a0,a1,0x8
800049f8:	05de                	slli	a1,a1,0x17
800049fa:	0005a333          	sltz	t1,a1
800049fe:	95ae                	add	a1,a1,a1
80004a00:	959a                	add	a1,a1,t1
80004a02:	0005d663          	bgez	a1,80004a0e <.L__floatundisf_round_down>
80004a06:	95ae                	add	a1,a1,a1
80004a08:	00b035b3          	snez	a1,a1
80004a0c:	952e                	add	a0,a0,a1

80004a0e <.L__floatundisf_round_down>:
80004a0e:	9532                	add	a0,a0,a2

80004a10 <.L__floatundisf_done>:
80004a10:	8082                	ret

80004a12 <.L__floatundisf_high_word_zero>:
80004a12:	dd7d                	beqz	a0,80004a10 <.L__floatundisf_done>
80004a14:	09d00613          	li	a2,157
80004a18:	01055693          	srli	a3,a0,0x10
80004a1c:	e299                	bnez	a3,80004a22 <.Ltmp50>
80004a1e:	0542                	slli	a0,a0,0x10
80004a20:	1641                	addi	a2,a2,-16

80004a22 <.Ltmp50>:
80004a22:	01855693          	srli	a3,a0,0x18
80004a26:	e299                	bnez	a3,80004a2c <.Ltmp51>
80004a28:	0522                	slli	a0,a0,0x8
80004a2a:	1661                	addi	a2,a2,-8

80004a2c <.Ltmp51>:
80004a2c:	01c55693          	srli	a3,a0,0x1c
80004a30:	e299                	bnez	a3,80004a36 <.Ltmp52>
80004a32:	0512                	slli	a0,a0,0x4
80004a34:	1671                	addi	a2,a2,-4

80004a36 <.Ltmp52>:
80004a36:	01e55693          	srli	a3,a0,0x1e
80004a3a:	e299                	bnez	a3,80004a40 <.Ltmp53>
80004a3c:	050a                	slli	a0,a0,0x2
80004a3e:	1679                	addi	a2,a2,-2

80004a40 <.Ltmp53>:
80004a40:	00054463          	bltz	a0,80004a48 <.Ltmp54>
80004a44:	0506                	slli	a0,a0,0x1
80004a46:	167d                	addi	a2,a2,-1

80004a48 <.Ltmp54>:
80004a48:	85aa                	mv	a1,a0
80004a4a:	4501                	li	a0,0
80004a4c:	b75d                	j	800049f2 <.L__floatundisf_round_and_pack>

Disassembly of section .text.libc.__truncdfsf2:

80004a4e <__truncdfsf2>:
80004a4e:	00159693          	slli	a3,a1,0x1
80004a52:	82d5                	srli	a3,a3,0x15
80004a54:	7ff00613          	li	a2,2047
80004a58:	04c68663          	beq	a3,a2,80004aa4 <.L__truncdfsf2_inf_nan>
80004a5c:	c8068693          	addi	a3,a3,-896
80004a60:	02d05e63          	blez	a3,80004a9c <.L__truncdfsf2_underflow>
80004a64:	0ff00613          	li	a2,255
80004a68:	04c6f263          	bgeu	a3,a2,80004aac <.L__truncdfsf2_inf>
80004a6c:	06de                	slli	a3,a3,0x17
80004a6e:	01f5d613          	srli	a2,a1,0x1f
80004a72:	067e                	slli	a2,a2,0x1f
80004a74:	8ed1                	or	a3,a3,a2
80004a76:	05b2                	slli	a1,a1,0xc
80004a78:	01455613          	srli	a2,a0,0x14
80004a7c:	8dd1                	or	a1,a1,a2
80004a7e:	81a5                	srli	a1,a1,0x9
80004a80:	00251613          	slli	a2,a0,0x2
80004a84:	00062733          	sltz	a4,a2
80004a88:	9632                	add	a2,a2,a2
80004a8a:	000627b3          	sltz	a5,a2
80004a8e:	9632                	add	a2,a2,a2
80004a90:	963a                	add	a2,a2,a4
80004a92:	c211                	beqz	a2,80004a96 <.L__truncdfsf2_no_round_tie>
80004a94:	95be                	add	a1,a1,a5

80004a96 <.L__truncdfsf2_no_round_tie>:
80004a96:	00d58533          	add	a0,a1,a3
80004a9a:	8082                	ret

80004a9c <.L__truncdfsf2_underflow>:
80004a9c:	01f5d513          	srli	a0,a1,0x1f
80004aa0:	057e                	slli	a0,a0,0x1f
80004aa2:	8082                	ret

80004aa4 <.L__truncdfsf2_inf_nan>:
80004aa4:	00c59693          	slli	a3,a1,0xc
80004aa8:	8ec9                	or	a3,a3,a0
80004aaa:	ea81                	bnez	a3,80004aba <.L__truncdfsf2_nan>

80004aac <.L__truncdfsf2_inf>:
80004aac:	81fd                	srli	a1,a1,0x1f
80004aae:	05fe                	slli	a1,a1,0x1f
80004ab0:	7f800537          	lui	a0,0x7f800
80004ab4:	8d4d                	or	a0,a0,a1
80004ab6:	4581                	li	a1,0
80004ab8:	8082                	ret

80004aba <.L__truncdfsf2_nan>:
80004aba:	800006b7          	lui	a3,0x80000
80004abe:	00d5f633          	and	a2,a1,a3
80004ac2:	058e                	slli	a1,a1,0x3
80004ac4:	8175                	srli	a0,a0,0x1d
80004ac6:	8d4d                	or	a0,a0,a1
80004ac8:	0506                	slli	a0,a0,0x1
80004aca:	8105                	srli	a0,a0,0x1
80004acc:	8d51                	or	a0,a0,a2
80004ace:	82a5                	srli	a3,a3,0x9
80004ad0:	8d55                	or	a0,a0,a3
80004ad2:	8082                	ret

Disassembly of section .text.libc.frexpf:

80004ad4 <frexpf>:
80004ad4:	01755613          	srli	a2,a0,0x17
80004ad8:	0ff67613          	zext.b	a2,a2
80004adc:	0ff00693          	li	a3,255
80004ae0:	00d60363          	beq	a2,a3,80004ae6 <frexpf+0x12>
80004ae4:	e601                	bnez	a2,80004aec <frexpf+0x18>
80004ae6:	0005a023          	sw	zero,0(a1)
80004aea:	8082                	ret
80004aec:	f8260613          	addi	a2,a2,-126
80004af0:	c190                	sw	a2,0(a1)
80004af2:	808005b7          	lui	a1,0x80800
80004af6:	15fd                	addi	a1,a1,-1 # 807fffff <__FLASH_segment_end__+0x6fffff>
80004af8:	8d6d                	and	a0,a0,a1
80004afa:	3f0005b7          	lui	a1,0x3f000
80004afe:	8d4d                	or	a0,a0,a1
80004b00:	8082                	ret

Disassembly of section .text.libc.abs:

80004b02 <abs>:
80004b02:	41f55593          	srai	a1,a0,0x1f
80004b06:	8d2d                	xor	a0,a0,a1
80004b08:	8d0d                	sub	a0,a0,a1
80004b0a:	8082                	ret

Disassembly of section .text.libc.memcpy:

80004b0c <memcpy>:
80004b0c:	c251                	beqz	a2,80004b90 <.Lmemcpy_done>
80004b0e:	87aa                	mv	a5,a0
80004b10:	00b546b3          	xor	a3,a0,a1
80004b14:	06fa                	slli	a3,a3,0x1e
80004b16:	e2bd                	bnez	a3,80004b7c <.Lmemcpy_byte_copy>
80004b18:	01e51693          	slli	a3,a0,0x1e
80004b1c:	ce81                	beqz	a3,80004b34 <.Lmemcpy_aligned>

80004b1e <.Lmemcpy_word_align>:
80004b1e:	00058683          	lb	a3,0(a1) # 3f000000 <_flash_size+0x3ef00000>
80004b22:	00d50023          	sb	a3,0(a0) # 7f800000 <_flash_size+0x7f700000>
80004b26:	0585                	addi	a1,a1,1
80004b28:	0505                	addi	a0,a0,1
80004b2a:	167d                	addi	a2,a2,-1
80004b2c:	c22d                	beqz	a2,80004b8e <.Lmemcpy_memcpy_end>
80004b2e:	01e51693          	slli	a3,a0,0x1e
80004b32:	f6f5                	bnez	a3,80004b1e <.Lmemcpy_word_align>

80004b34 <.Lmemcpy_aligned>:
80004b34:	02000693          	li	a3,32
80004b38:	02d66763          	bltu	a2,a3,80004b66 <.Lmemcpy_word_copy>

80004b3c <.Lmemcpy_aligned_block_copy_loop>:
80004b3c:	4198                	lw	a4,0(a1)
80004b3e:	c118                	sw	a4,0(a0)
80004b40:	41d8                	lw	a4,4(a1)
80004b42:	c158                	sw	a4,4(a0)
80004b44:	4598                	lw	a4,8(a1)
80004b46:	c518                	sw	a4,8(a0)
80004b48:	45d8                	lw	a4,12(a1)
80004b4a:	c558                	sw	a4,12(a0)
80004b4c:	4998                	lw	a4,16(a1)
80004b4e:	c918                	sw	a4,16(a0)
80004b50:	49d8                	lw	a4,20(a1)
80004b52:	c958                	sw	a4,20(a0)
80004b54:	4d98                	lw	a4,24(a1)
80004b56:	cd18                	sw	a4,24(a0)
80004b58:	4dd8                	lw	a4,28(a1)
80004b5a:	cd58                	sw	a4,28(a0)
80004b5c:	9536                	add	a0,a0,a3
80004b5e:	95b6                	add	a1,a1,a3
80004b60:	8e15                	sub	a2,a2,a3
80004b62:	fcd67de3          	bgeu	a2,a3,80004b3c <.Lmemcpy_aligned_block_copy_loop>

80004b66 <.Lmemcpy_word_copy>:
80004b66:	c605                	beqz	a2,80004b8e <.Lmemcpy_memcpy_end>
80004b68:	4691                	li	a3,4
80004b6a:	00d66963          	bltu	a2,a3,80004b7c <.Lmemcpy_byte_copy>

80004b6e <.Lmemcpy_word_copy_loop>:
80004b6e:	4198                	lw	a4,0(a1)
80004b70:	c118                	sw	a4,0(a0)
80004b72:	9536                	add	a0,a0,a3
80004b74:	95b6                	add	a1,a1,a3
80004b76:	8e15                	sub	a2,a2,a3
80004b78:	fed67be3          	bgeu	a2,a3,80004b6e <.Lmemcpy_word_copy_loop>

80004b7c <.Lmemcpy_byte_copy>:
80004b7c:	ca09                	beqz	a2,80004b8e <.Lmemcpy_memcpy_end>

80004b7e <.Lmemcpy_byte_copy_loop>:
80004b7e:	00058703          	lb	a4,0(a1)
80004b82:	00e50023          	sb	a4,0(a0)
80004b86:	0585                	addi	a1,a1,1
80004b88:	0505                	addi	a0,a0,1
80004b8a:	167d                	addi	a2,a2,-1
80004b8c:	fa6d                	bnez	a2,80004b7e <.Lmemcpy_byte_copy_loop>

80004b8e <.Lmemcpy_memcpy_end>:
80004b8e:	853e                	mv	a0,a5

80004b90 <.Lmemcpy_done>:
80004b90:	8082                	ret

Disassembly of section .text.libc.strnlen:

80004b92 <strnlen>:
80004b92:	cda9                	beqz	a1,80004bec <strnlen+0x5a>
80004b94:	00054603          	lbu	a2,0(a0)
80004b98:	ca31                	beqz	a2,80004bec <strnlen+0x5a>
80004b9a:	ffc57713          	andi	a4,a0,-4
80004b9e:	00357613          	andi	a2,a0,3
80004ba2:	00351693          	slli	a3,a0,0x3
80004ba6:	95b2                	add	a1,a1,a2
80004ba8:	4310                	lw	a2,0(a4)
80004baa:	57fd                	li	a5,-1
80004bac:	00d796b3          	sll	a3,a5,a3
80004bb0:	fff6c693          	not	a3,a3
80004bb4:	4791                	li	a5,4
80004bb6:	8ed1                	or	a3,a3,a2
80004bb8:	02f5ed63          	bltu	a1,a5,80004bf2 <strnlen+0x60>
80004bbc:	01010637          	lui	a2,0x1010
80004bc0:	808087b7          	lui	a5,0x80808
80004bc4:	10060893          	addi	a7,a2,256 # 1010100 <_flash_size+0xf10100>
80004bc8:	08078793          	addi	a5,a5,128 # 80808080 <__FLASH_segment_end__+0x708080>
80004bcc:	480d                	li	a6,3
80004bce:	863a                	mv	a2,a4
80004bd0:	40d88733          	sub	a4,a7,a3
80004bd4:	8f55                	or	a4,a4,a3
80004bd6:	8f7d                	and	a4,a4,a5
80004bd8:	00f71c63          	bne	a4,a5,80004bf0 <strnlen+0x5e>
80004bdc:	4254                	lw	a3,4(a2)
80004bde:	00460713          	addi	a4,a2,4
80004be2:	15f1                	addi	a1,a1,-4
80004be4:	863a                	mv	a2,a4
80004be6:	feb865e3          	bltu	a6,a1,80004bd0 <strnlen+0x3e>
80004bea:	a021                	j	80004bf2 <strnlen+0x60>
80004bec:	4501                	li	a0,0
80004bee:	8082                	ret
80004bf0:	8732                	mv	a4,a2
80004bf2:	0ff6f613          	zext.b	a2,a3
80004bf6:	c215                	beqz	a2,80004c1a <strnlen+0x88>
80004bf8:	6641                	lui	a2,0x10
80004bfa:	f0060613          	addi	a2,a2,-256 # ff00 <__AHB_SRAM_segment_size__+0x7f00>
80004bfe:	8e75                	and	a2,a2,a3
80004c00:	ce01                	beqz	a2,80004c18 <strnlen+0x86>
80004c02:	00ff0637          	lui	a2,0xff0
80004c06:	8e75                	and	a2,a2,a3
80004c08:	c205                	beqz	a2,80004c28 <strnlen+0x96>
80004c0a:	82e1                	srli	a3,a3,0x18
80004c0c:	00d03633          	snez	a2,a3
80004c10:	060d                	addi	a2,a2,3 # ff0003 <_flash_size+0xef0003>
80004c12:	00b67663          	bgeu	a2,a1,80004c1e <strnlen+0x8c>
80004c16:	a029                	j	80004c20 <strnlen+0x8e>
80004c18:	4605                	li	a2,1
80004c1a:	00b66363          	bltu	a2,a1,80004c20 <strnlen+0x8e>
80004c1e:	862e                	mv	a2,a1
80004c20:	40a70533          	sub	a0,a4,a0
80004c24:	9532                	add	a0,a0,a2
80004c26:	8082                	ret
80004c28:	4609                	li	a2,2
80004c2a:	feb67ae3          	bgeu	a2,a1,80004c1e <strnlen+0x8c>
80004c2e:	bfcd                	j	80004c20 <strnlen+0x8e>

Disassembly of section .text.libc.__SEGGER_RTL_putc:

80004c30 <__SEGGER_RTL_putc>:
80004c30:	1141                	addi	sp,sp,-16
80004c32:	c606                	sw	ra,12(sp)
80004c34:	c422                	sw	s0,8(sp)
80004c36:	842a                	mv	s0,a0
80004c38:	4908                	lw	a0,16(a0)
80004c3a:	00b103a3          	sb	a1,7(sp)
80004c3e:	c11d                	beqz	a0,80004c64 <__SEGGER_RTL_putc+0x34>
80004c40:	4010                	lw	a2,0(s0)
80004c42:	4054                	lw	a3,4(s0)
80004c44:	06d67f63          	bgeu	a2,a3,80004cc2 <__SEGGER_RTL_putc+0x92>
80004c48:	4850                	lw	a2,20(s0)
80004c4a:	00160693          	addi	a3,a2,1
80004c4e:	9532                	add	a0,a0,a2
80004c50:	c854                	sw	a3,20(s0)
80004c52:	00b50023          	sb	a1,0(a0)
80004c56:	4848                	lw	a0,20(s0)
80004c58:	4c0c                	lw	a1,24(s0)
80004c5a:	06b51463          	bne	a0,a1,80004cc2 <__SEGGER_RTL_putc+0x92>
80004c5e:	8522                	mv	a0,s0
80004c60:	2885                	jal	80004cd0 <__SEGGER_RTL_prin_flush>
80004c62:	a085                	j	80004cc2 <__SEGGER_RTL_putc+0x92>
80004c64:	4448                	lw	a0,12(s0)
80004c66:	c105                	beqz	a0,80004c86 <__SEGGER_RTL_putc+0x56>
80004c68:	4010                	lw	a2,0(s0)
80004c6a:	4054                	lw	a3,4(s0)
80004c6c:	04d67b63          	bgeu	a2,a3,80004cc2 <__SEGGER_RTL_putc+0x92>
80004c70:	00160713          	addi	a4,a2,1
80004c74:	8eb9                	xor	a3,a3,a4
80004c76:	0016b693          	seqz	a3,a3
80004c7a:	16fd                	addi	a3,a3,-1 # 7fffffff <_flash_size+0x7fefffff>
80004c7c:	8df5                	and	a1,a1,a3
80004c7e:	9532                	add	a0,a0,a2
80004c80:	00b50023          	sb	a1,0(a0)
80004c84:	a83d                	j	80004cc2 <__SEGGER_RTL_putc+0x92>
80004c86:	4408                	lw	a0,8(s0)
80004c88:	c115                	beqz	a0,80004cac <__SEGGER_RTL_putc+0x7c>
80004c8a:	4010                	lw	a2,0(s0)
80004c8c:	4054                	lw	a3,4(s0)
80004c8e:	02d67a63          	bgeu	a2,a3,80004cc2 <__SEGGER_RTL_putc+0x92>
80004c92:	00160713          	addi	a4,a2,1
80004c96:	060a                	slli	a2,a2,0x2
80004c98:	8eb9                	xor	a3,a3,a4
80004c9a:	0016b693          	seqz	a3,a3
80004c9e:	16fd                	addi	a3,a3,-1
80004ca0:	8df5                	and	a1,a1,a3
80004ca2:	0ff5f593          	zext.b	a1,a1
80004ca6:	9532                	add	a0,a0,a2
80004ca8:	c10c                	sw	a1,0(a0)
80004caa:	a821                	j	80004cc2 <__SEGGER_RTL_putc+0x92>
80004cac:	5014                	lw	a3,32(s0)
80004cae:	ca91                	beqz	a3,80004cc2 <__SEGGER_RTL_putc+0x92>
80004cb0:	4008                	lw	a0,0(s0)
80004cb2:	404c                	lw	a1,4(s0)
80004cb4:	00b57763          	bgeu	a0,a1,80004cc2 <__SEGGER_RTL_putc+0x92>
80004cb8:	00710593          	addi	a1,sp,7
80004cbc:	4605                	li	a2,1
80004cbe:	8522                	mv	a0,s0
80004cc0:	9682                	jalr	a3
80004cc2:	4008                	lw	a0,0(s0)
80004cc4:	0505                	addi	a0,a0,1
80004cc6:	c008                	sw	a0,0(s0)
80004cc8:	40b2                	lw	ra,12(sp)
80004cca:	4422                	lw	s0,8(sp)
80004ccc:	0141                	addi	sp,sp,16
80004cce:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_prin_flush:

80004cd0 <__SEGGER_RTL_prin_flush>:
80004cd0:	4950                	lw	a2,20(a0)
80004cd2:	ce19                	beqz	a2,80004cf0 <__SEGGER_RTL_prin_flush+0x20>
80004cd4:	1141                	addi	sp,sp,-16
80004cd6:	c606                	sw	ra,12(sp)
80004cd8:	c422                	sw	s0,8(sp)
80004cda:	842a                	mv	s0,a0
80004cdc:	5114                	lw	a3,32(a0)
80004cde:	c681                	beqz	a3,80004ce6 <__SEGGER_RTL_prin_flush+0x16>
80004ce0:	480c                	lw	a1,16(s0)
80004ce2:	8522                	mv	a0,s0
80004ce4:	9682                	jalr	a3
80004ce6:	00042a23          	sw	zero,20(s0)
80004cea:	40b2                	lw	ra,12(sp)
80004cec:	4422                	lw	s0,8(sp)
80004cee:	0141                	addi	sp,sp,16
80004cf0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_print_padding:

80004cf2 <__SEGGER_RTL_print_padding>:
80004cf2:	02c05963          	blez	a2,80004d24 <__SEGGER_RTL_print_padding+0x32>
80004cf6:	1101                	addi	sp,sp,-32
80004cf8:	ce06                	sw	ra,28(sp)
80004cfa:	cc22                	sw	s0,24(sp)
80004cfc:	ca26                	sw	s1,20(sp)
80004cfe:	c84a                	sw	s2,16(sp)
80004d00:	c64e                	sw	s3,12(sp)
80004d02:	892e                	mv	s2,a1
80004d04:	84aa                	mv	s1,a0
80004d06:	00160413          	addi	s0,a2,1
80004d0a:	4985                	li	s3,1
80004d0c:	8526                	mv	a0,s1
80004d0e:	85ca                	mv	a1,s2
80004d10:	3705                	jal	80004c30 <__SEGGER_RTL_putc>
80004d12:	147d                	addi	s0,s0,-1
80004d14:	fe89ece3          	bltu	s3,s0,80004d0c <__SEGGER_RTL_print_padding+0x1a>
80004d18:	40f2                	lw	ra,28(sp)
80004d1a:	4462                	lw	s0,24(sp)
80004d1c:	44d2                	lw	s1,20(sp)
80004d1e:	4942                	lw	s2,16(sp)
80004d20:	49b2                	lw	s3,12(sp)
80004d22:	6105                	addi	sp,sp,32
80004d24:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pre_padding:

80004d26 <__SEGGER_RTL_pre_padding>:
80004d26:	0105f693          	andi	a3,a1,16
80004d2a:	e699                	bnez	a3,80004d38 <__SEGGER_RTL_pre_padding+0x12>
80004d2c:	2005f593          	andi	a1,a1,512
80004d30:	c589                	beqz	a1,80004d3a <__SEGGER_RTL_pre_padding+0x14>
80004d32:	03000593          	li	a1,48
80004d36:	bf75                	j	80004cf2 <__SEGGER_RTL_print_padding>
80004d38:	8082                	ret
80004d3a:	02000593          	li	a1,32
80004d3e:	bf55                	j	80004cf2 <__SEGGER_RTL_print_padding>

Disassembly of section .text.libc.vfprintf:

80004d40 <vfprintf>:
80004d40:	1141                	addi	sp,sp,-16
80004d42:	c606                	sw	ra,12(sp)
80004d44:	c422                	sw	s0,8(sp)
80004d46:	c226                	sw	s1,4(sp)
80004d48:	c04a                	sw	s2,0(sp)
80004d4a:	8932                	mv	s2,a2
80004d4c:	84ae                	mv	s1,a1
80004d4e:	842a                	mv	s0,a0
80004d50:	591020ef          	jal	80007ae0 <__SEGGER_RTL_current_locale>
80004d54:	85aa                	mv	a1,a0
80004d56:	8522                	mv	a0,s0
80004d58:	8626                	mv	a2,s1
80004d5a:	86ca                	mv	a3,s2
80004d5c:	40b2                	lw	ra,12(sp)
80004d5e:	4422                	lw	s0,8(sp)
80004d60:	4492                	lw	s1,4(sp)
80004d62:	4902                	lw	s2,0(sp)
80004d64:	0141                	addi	sp,sp,16
80004d66:	a009                	j	80004d68 <vfprintf_l>

Disassembly of section .text.libc.vfprintf_l:

80004d68 <vfprintf_l>:
80004d68:	52f012ef          	jal	t0,80006a96 <__riscv_save_10>
80004d6c:	7179                	addi	sp,sp,-48
80004d6e:	1080                	addi	s0,sp,96
80004d70:	8936                	mv	s2,a3
80004d72:	89b2                	mv	s3,a2
80004d74:	8a2e                	mv	s4,a1
80004d76:	8aaa                	mv	s5,a0
80004d78:	50b010ef          	jal	80006a82 <__SEGGER_RTL_X_file_bufsize>
80004d7c:	8baa                	mv	s7,a0
80004d7e:	8b0a                	mv	s6,sp
80004d80:	053d                	addi	a0,a0,15
80004d82:	9941                	andi	a0,a0,-16
80004d84:	40a104b3          	sub	s1,sp,a0
80004d88:	8126                	mv	sp,s1
80004d8a:	fa840513          	addi	a0,s0,-88
80004d8e:	02400613          	li	a2,36
80004d92:	4581                	li	a1,0
80004d94:	421020ef          	jal	800079b4 <memset>
80004d98:	80000537          	lui	a0,0x80000
80004d9c:	800055b7          	lui	a1,0x80005
80004da0:	dd458593          	addi	a1,a1,-556 # 80004dd4 <__SEGGER_RTL_stream_write>
80004da4:	157d                	addi	a0,a0,-1 # 7fffffff <_flash_size+0x7fefffff>
80004da6:	faa42623          	sw	a0,-84(s0)
80004daa:	fa942c23          	sw	s1,-72(s0)
80004dae:	fd742023          	sw	s7,-64(s0)
80004db2:	fd442223          	sw	s4,-60(s0)
80004db6:	fcb42423          	sw	a1,-56(s0)
80004dba:	fd542623          	sw	s5,-52(s0)
80004dbe:	fa840513          	addi	a0,s0,-88
80004dc2:	85ce                	mv	a1,s3
80004dc4:	864a                	mv	a2,s2
80004dc6:	2091                	jal	80004e0a <__SEGGER_RTL_vfprintf>
80004dc8:	815a                	mv	sp,s6
80004dca:	fa040113          	addi	sp,s0,-96
80004dce:	6145                	addi	sp,sp,48
80004dd0:	4f90106f          	j	80006ac8 <__riscv_restore_8>

Disassembly of section .text.libc.__SEGGER_RTL_stream_write:

80004dd4 <__SEGGER_RTL_stream_write>:
80004dd4:	5154                	lw	a3,36(a0)
80004dd6:	852e                	mv	a0,a1
80004dd8:	4585                	li	a1,1
80004dda:	5bd0106f          	j	80006b96 <fwrite>

Disassembly of section .text.libc.printf:

80004dde <printf>:
80004dde:	7179                	addi	sp,sp,-48
80004de0:	c606                	sw	ra,12(sp)
80004de2:	82aa                	mv	t0,a0
80004de4:	d23e                	sw	a5,36(sp)
80004de6:	d442                	sw	a6,40(sp)
80004de8:	d646                	sw	a7,44(sp)
80004dea:	00080537          	lui	a0,0x80
80004dee:	34c52503          	lw	a0,844(a0) # 8034c <stdout>
80004df2:	ca2e                	sw	a1,20(sp)
80004df4:	cc32                	sw	a2,24(sp)
80004df6:	ce36                	sw	a3,28(sp)
80004df8:	d03a                	sw	a4,32(sp)
80004dfa:	084c                	addi	a1,sp,20
80004dfc:	c42e                	sw	a1,8(sp)
80004dfe:	0850                	addi	a2,sp,20
80004e00:	8596                	mv	a1,t0
80004e02:	3f3d                	jal	80004d40 <vfprintf>
80004e04:	40b2                	lw	ra,12(sp)
80004e06:	6145                	addi	sp,sp,48
80004e08:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_vfprintf_short_float_long:

80004e0a <__SEGGER_RTL_vfprintf>:
80004e0a:	485012ef          	jal	t0,80006a8e <__riscv_save_12>
80004e0e:	711d                	addi	sp,sp,-96
80004e10:	8d2e                	mv	s10,a1
80004e12:	8a2a                	mv	s4,a0
80004e14:	448d                	li	s1,3
80004e16:	00052023          	sw	zero,0(a0)
80004e1a:	02500c93          	li	s9,37
80004e1e:	4dc1                	li	s11,16
80004e20:	49a9                	li	s3,10
80004e22:	66666537          	lui	a0,0x66666
80004e26:	7e9675b7          	lui	a1,0x7e967
80004e2a:	747d                	lui	s0,0xfffff
80004e2c:	555556b7          	lui	a3,0x55555
80004e30:	51eb8737          	lui	a4,0x51eb8
80004e34:	000207b7          	lui	a5,0x20
80004e38:	66750513          	addi	a0,a0,1639 # 66666667 <_flash_size+0x66566667>
80004e3c:	cc2a                	sw	a0,24(sp)
80004e3e:	69958513          	addi	a0,a1,1689 # 7e967699 <_flash_size+0x7e867699>
80004e42:	c62a                	sw	a0,12(sp)
80004e44:	7ff40513          	addi	a0,s0,2047 # fffff7ff <__AHB_SRAM_segment_end__+0xfbf77ff>
80004e48:	c82a                	sw	a0,16(sp)
80004e4a:	55668513          	addi	a0,a3,1366 # 55555556 <_flash_size+0x55455556>
80004e4e:	c02a                	sw	a0,0(sp)
80004e50:	51f70513          	addi	a0,a4,1311 # 51eb851f <_flash_size+0x51db851f>
80004e54:	c42a                	sw	a0,8(sp)
80004e56:	02178513          	addi	a0,a5,33 # 20021 <__ILM_segment_end__+0x21>
80004e5a:	ce2a                	sw	a0,28(sp)
80004e5c:	4505                	li	a0,1
80004e5e:	04aa                	slli	s1,s1,0xa
80004e60:	d026                	sw	s1,32(sp)
80004e62:	84b2                	mv	s1,a2
80004e64:	052e                	slli	a0,a0,0xb
80004e66:	c22a                	sw	a0,4(sp)
80004e68:	e1818913          	addi	s2,gp,-488 # 800036a8 <.LJTI0_0>
80004e6c:	000d4583          	lbu	a1,0(s10)
80004e70:	01958863          	beq	a1,s9,80004e80 <__SEGGER_RTL_vfprintf+0x76>
80004e74:	56058de3          	beqz	a1,80005bee <__SEGGER_RTL_vfprintf+0xde4>
80004e78:	0d05                	addi	s10,s10,1
80004e7a:	8552                	mv	a0,s4
80004e7c:	3b55                	jal	80004c30 <__SEGGER_RTL_putc>
80004e7e:	b7fd                	j	80004e6c <__SEGGER_RTL_vfprintf+0x62>
80004e80:	4b81                	li	s7,0
80004e82:	0d0d                	addi	s10,s10,3
80004e84:	05e00693          	li	a3,94
80004e88:	ffed4503          	lbu	a0,-2(s10)
80004e8c:	fe050593          	addi	a1,a0,-32
80004e90:	00bdeb63          	bltu	s11,a1,80004ea6 <__SEGGER_RTL_vfprintf+0x9c>
80004e94:	058a                	slli	a1,a1,0x2
80004e96:	95ca                	add	a1,a1,s2
80004e98:	4190                	lw	a2,0(a1)
80004e9a:	08000593          	li	a1,128
80004e9e:	8602                	jr	a2
80004ea0:	04000593          	li	a1,64
80004ea4:	a831                	j	80004ec0 <__SEGGER_RTL_vfprintf+0xb6>
80004ea6:	02d51163          	bne	a0,a3,80004ec8 <__SEGGER_RTL_vfprintf+0xbe>
80004eaa:	6585                	lui	a1,0x1
80004eac:	a811                	j	80004ec0 <__SEGGER_RTL_vfprintf+0xb6>
80004eae:	45c1                	li	a1,16
80004eb0:	a801                	j	80004ec0 <__SEGGER_RTL_vfprintf+0xb6>
80004eb2:	20000593          	li	a1,512
80004eb6:	a029                	j	80004ec0 <__SEGGER_RTL_vfprintf+0xb6>
80004eb8:	65a1                	lui	a1,0x8
80004eba:	a019                	j	80004ec0 <__SEGGER_RTL_vfprintf+0xb6>
80004ebc:	02000593          	li	a1,32
80004ec0:	00bbebb3          	or	s7,s7,a1
80004ec4:	0d05                	addi	s10,s10,1
80004ec6:	b7c9                	j	80004e88 <__SEGGER_RTL_vfprintf+0x7e>
80004ec8:	fd050593          	addi	a1,a0,-48
80004ecc:	0ff5f593          	zext.b	a1,a1
80004ed0:	1d7d                	addi	s10,s10,-1
80004ed2:	4625                	li	a2,9
80004ed4:	04b66263          	bltu	a2,a1,80004f18 <__SEGGER_RTL_vfprintf+0x10e>
80004ed8:	4581                	li	a1,0
80004eda:	0ff57613          	zext.b	a2,a0
80004ede:	000d4503          	lbu	a0,0(s10)
80004ee2:	033585b3          	mul	a1,a1,s3
80004ee6:	95b2                	add	a1,a1,a2
80004ee8:	fd058593          	addi	a1,a1,-48 # 7fd0 <__FLASH_segment_used_size__+0x2e60>
80004eec:	fd050613          	addi	a2,a0,-48
80004ef0:	0ff67613          	zext.b	a2,a2
80004ef4:	0d05                	addi	s10,s10,1
80004ef6:	ff3662e3          	bltu	a2,s3,80004eda <__SEGGER_RTL_vfprintf+0xd0>
80004efa:	a005                	j	80004f1a <__SEGGER_RTL_vfprintf+0x110>
80004efc:	408c                	lw	a1,0(s1)
80004efe:	0491                	addi	s1,s1,4
80004f00:	fffd4503          	lbu	a0,-1(s10)
80004f04:	01b5d693          	srli	a3,a1,0x1b
80004f08:	8ac1                	andi	a3,a3,16
80004f0a:	0176ebb3          	or	s7,a3,s7
80004f0e:	41f5d693          	srai	a3,a1,0x1f
80004f12:	8db5                	xor	a1,a1,a3
80004f14:	8d95                	sub	a1,a1,a3
80004f16:	a011                	j	80004f1a <__SEGGER_RTL_vfprintf+0x110>
80004f18:	4581                	li	a1,0
80004f1a:	02e00613          	li	a2,46
80004f1e:	00c51f63          	bne	a0,a2,80004f3c <__SEGGER_RTL_vfprintf+0x132>
80004f22:	000d4503          	lbu	a0,0(s10)
80004f26:	02a00613          	li	a2,42
80004f2a:	00c51b63          	bne	a0,a2,80004f40 <__SEGGER_RTL_vfprintf+0x136>
80004f2e:	0004ab03          	lw	s6,0(s1)
80004f32:	001d4503          	lbu	a0,1(s10)
80004f36:	0491                	addi	s1,s1,4
80004f38:	0d09                	addi	s10,s10,2
80004f3a:	a825                	j	80004f72 <__SEGGER_RTL_vfprintf+0x168>
80004f3c:	4b01                	li	s6,0
80004f3e:	a099                	j	80004f84 <__SEGGER_RTL_vfprintf+0x17a>
80004f40:	fd050613          	addi	a2,a0,-48
80004f44:	0ff67613          	zext.b	a2,a2
80004f48:	0d05                	addi	s10,s10,1
80004f4a:	4b01                	li	s6,0
80004f4c:	46a5                	li	a3,9
80004f4e:	02c6e963          	bltu	a3,a2,80004f80 <__SEGGER_RTL_vfprintf+0x176>
80004f52:	0ff57613          	zext.b	a2,a0
80004f56:	000d4503          	lbu	a0,0(s10)
80004f5a:	033b06b3          	mul	a3,s6,s3
80004f5e:	9636                	add	a2,a2,a3
80004f60:	fd060b13          	addi	s6,a2,-48
80004f64:	fd050613          	addi	a2,a0,-48
80004f68:	0ff67613          	zext.b	a2,a2
80004f6c:	0d05                	addi	s10,s10,1
80004f6e:	ff3662e3          	bltu	a2,s3,80004f52 <__SEGGER_RTL_vfprintf+0x148>
80004f72:	fffb4613          	not	a2,s6
80004f76:	827d                	srli	a2,a2,0x1f
80004f78:	0622                	slli	a2,a2,0x8
80004f7a:	00cbebb3          	or	s7,s7,a2
80004f7e:	a019                	j	80004f84 <__SEGGER_RTL_vfprintf+0x17a>
80004f80:	100beb93          	ori	s7,s7,256
80004f84:	f9850613          	addi	a2,a0,-104
80004f88:	00761693          	slli	a3,a2,0x7
80004f8c:	0662                	slli	a2,a2,0x18
80004f8e:	8265                	srli	a2,a2,0x19
80004f90:	8e55                	or	a2,a2,a3
80004f92:	0ff67613          	zext.b	a2,a2
80004f96:	46a5                	li	a3,9
80004f98:	04c6ef63          	bltu	a3,a2,80004ff6 <__SEGGER_RTL_vfprintf+0x1ec>
80004f9c:	060a                	slli	a2,a2,0x2
80004f9e:	e5c18693          	addi	a3,gp,-420 # 800036ec <.LJTI0_1>
80004fa2:	9636                	add	a2,a2,a3
80004fa4:	4210                	lw	a2,0(a2)
80004fa6:	8602                	jr	a2
80004fa8:	000d4503          	lbu	a0,0(s10)
80004fac:	0d05                	addi	s10,s10,1
80004fae:	a0a1                	j	80004ff6 <__SEGGER_RTL_vfprintf+0x1ec>
80004fb0:	000d4503          	lbu	a0,0(s10)
80004fb4:	06c00613          	li	a2,108
80004fb8:	02c51863          	bne	a0,a2,80004fe8 <__SEGGER_RTL_vfprintf+0x1de>
80004fbc:	001d4503          	lbu	a0,1(s10)
80004fc0:	0d09                	addi	s10,s10,2
80004fc2:	a005                	j	80004fe2 <__SEGGER_RTL_vfprintf+0x1d8>
80004fc4:	000d4503          	lbu	a0,0(s10)
80004fc8:	06800613          	li	a2,104
80004fcc:	02c51263          	bne	a0,a2,80004ff0 <__SEGGER_RTL_vfprintf+0x1e6>
80004fd0:	001d4503          	lbu	a0,1(s10)
80004fd4:	0d09                	addi	s10,s10,2
80004fd6:	008beb93          	ori	s7,s7,8
80004fda:	a831                	j	80004ff6 <__SEGGER_RTL_vfprintf+0x1ec>
80004fdc:	000d4503          	lbu	a0,0(s10)
80004fe0:	0d05                	addi	s10,s10,1
80004fe2:	002beb93          	ori	s7,s7,2
80004fe6:	a801                	j	80004ff6 <__SEGGER_RTL_vfprintf+0x1ec>
80004fe8:	0d05                	addi	s10,s10,1
80004fea:	001beb93          	ori	s7,s7,1
80004fee:	a021                	j	80004ff6 <__SEGGER_RTL_vfprintf+0x1ec>
80004ff0:	0d05                	addi	s10,s10,1
80004ff2:	004beb93          	ori	s7,s7,4
80004ff6:	00b02633          	sgtz	a2,a1
80004ffa:	40c00633          	neg	a2,a2
80004ffe:	00b67ab3          	and	s5,a2,a1
80005002:	04600593          	li	a1,70
80005006:	02a5d363          	bge	a1,a0,8000502c <__SEGGER_RTL_vfprintf+0x222>
8000500a:	f9d50593          	addi	a1,a0,-99
8000500e:	4655                	li	a2,21
80005010:	04b66663          	bltu	a2,a1,8000505c <__SEGGER_RTL_vfprintf+0x252>
80005014:	058a                	slli	a1,a1,0x2
80005016:	e8418613          	addi	a2,gp,-380 # 80003714 <.LJTI0_2>
8000501a:	95b2                	add	a1,a1,a2
8000501c:	418c                	lw	a1,0(a1)
8000501e:	8582                	jr	a1
80005020:	d456                	sw	s5,40(sp)
80005022:	d202                	sw	zero,36(sp)
80005024:	6591                	lui	a1,0x4
80005026:	00bbeab3          	or	s5,s7,a1
8000502a:	a219                	j	80005130 <__SEGGER_RTL_vfprintf+0x326>
8000502c:	04400593          	li	a1,68
80005030:	02a5d163          	bge	a1,a0,80005052 <__SEGGER_RTL_vfprintf+0x248>
80005034:	04500593          	li	a1,69
80005038:	04b50663          	beq	a0,a1,80005084 <__SEGGER_RTL_vfprintf+0x27a>
8000503c:	04600593          	li	a1,70
80005040:	e2b516e3          	bne	a0,a1,80004e6c <__SEGGER_RTL_vfprintf+0x62>
80005044:	6509                	lui	a0,0x2
80005046:	00abebb3          	or	s7,s7,a0
8000504a:	5502                	lw	a0,32(sp)
8000504c:	c0050513          	addi	a0,a0,-1024 # 1c00 <__NOR_CFG_OPTION_segment_size__+0x1000>
80005050:	a4fd                	j	8000533e <__SEGGER_RTL_vfprintf+0x534>
80005052:	5b951f63          	bne	a0,s9,80005610 <__SEGGER_RTL_vfprintf+0x806>
80005056:	02500593          	li	a1,37
8000505a:	b505                	j	80004e7a <__SEGGER_RTL_vfprintf+0x70>
8000505c:	04700593          	li	a1,71
80005060:	2cb50b63          	beq	a0,a1,80005336 <__SEGGER_RTL_vfprintf+0x52c>
80005064:	05800593          	li	a1,88
80005068:	e0b512e3          	bne	a0,a1,80004e6c <__SEGGER_RTL_vfprintf+0x62>
8000506c:	6589                	lui	a1,0x2
8000506e:	00bbebb3          	or	s7,s7,a1
80005072:	07800593          	li	a1,120
80005076:	d456                	sw	s5,40(sp)
80005078:	08b50e63          	beq	a0,a1,80005114 <__SEGGER_RTL_vfprintf+0x30a>
8000507c:	658d                	lui	a1,0x3
8000507e:	05858593          	addi	a1,a1,88 # 3058 <__BOOT_HEADER_segment_size__+0x1058>
80005082:	a861                	j	8000511a <__SEGGER_RTL_vfprintf+0x310>
80005084:	6509                	lui	a0,0x2
80005086:	00abebb3          	or	s7,s7,a0
8000508a:	400bec93          	ori	s9,s7,1024
8000508e:	ac55                	j	80005342 <__SEGGER_RTL_vfprintf+0x538>
80005090:	100bf593          	andi	a1,s7,256
80005094:	d456                	sw	s5,40(sp)
80005096:	c199                	beqz	a1,8000509c <__SEGGER_RTL_vfprintf+0x292>
80005098:	dffbfb93          	andi	s7,s7,-513
8000509c:	d202                	sw	zero,36(sp)
8000509e:	8ade                	mv	s5,s7
800050a0:	a841                	j	80005130 <__SEGGER_RTL_vfprintf+0x326>
800050a2:	d456                	sw	s5,40(sp)
800050a4:	4c01                	li	s8,0
800050a6:	0004ac83          	lw	s9,0(s1)
800050aa:	0491                	addi	s1,s1,4
800050ac:	018b9593          	slli	a1,s7,0x18
800050b0:	85fd                	srai	a1,a1,0x1f
800050b2:	0235f413          	andi	s0,a1,35
800050b6:	100bea93          	ori	s5,s7,256
800050ba:	4b21                	li	s6,8
800050bc:	ac39                	j	800052da <__SEGGER_RTL_vfprintf+0x4d0>
800050be:	8b26                	mv	s6,s1
800050c0:	0004c483          	lbu	s1,0(s1)
800050c4:	0b11                	addi	s6,s6,4
800050c6:	1afd                	addi	s5,s5,-1
800050c8:	8552                	mv	a0,s4
800050ca:	85de                	mv	a1,s7
800050cc:	8656                	mv	a2,s5
800050ce:	39a1                	jal	80004d26 <__SEGGER_RTL_pre_padding>
800050d0:	8552                	mv	a0,s4
800050d2:	85a6                	mv	a1,s1
800050d4:	3eb1                	jal	80004c30 <__SEGGER_RTL_putc>
800050d6:	84da                	mv	s1,s6
800050d8:	a641                	j	80005458 <__SEGGER_RTL_vfprintf+0x64e>
800050da:	4088                	lw	a0,0(s1)
800050dc:	008bf593          	andi	a1,s7,8
800050e0:	52059b63          	bnez	a1,80005616 <__SEGGER_RTL_vfprintf+0x80c>
800050e4:	000a2583          	lw	a1,0(s4)
800050e8:	002bf413          	andi	s0,s7,2
800050ec:	58041263          	bnez	s0,80005670 <__SEGGER_RTL_vfprintf+0x866>
800050f0:	c10c                	sw	a1,0(a0)
800050f2:	a351                	j	80005676 <__SEGGER_RTL_vfprintf+0x86c>
800050f4:	4088                	lw	a0,0(s1)
800050f6:	0491                	addi	s1,s1,4
800050f8:	ae09                	j	8000540a <__SEGGER_RTL_vfprintf+0x600>
800050fa:	d456                	sw	s5,40(sp)
800050fc:	100bf593          	andi	a1,s7,256
80005100:	8ade                	mv	s5,s7
80005102:	c199                	beqz	a1,80005108 <__SEGGER_RTL_vfprintf+0x2fe>
80005104:	dffbfa93          	andi	s5,s7,-513
80005108:	0be2                	slli	s7,s7,0x18
8000510a:	405bd593          	srai	a1,s7,0x5
8000510e:	81f9                	srli	a1,a1,0x1e
80005110:	0592                	slli	a1,a1,0x4
80005112:	a831                	j	8000512e <__SEGGER_RTL_vfprintf+0x324>
80005114:	658d                	lui	a1,0x3
80005116:	07858593          	addi	a1,a1,120 # 3078 <__BOOT_HEADER_segment_size__+0x1078>
8000511a:	100bf613          	andi	a2,s7,256
8000511e:	8ade                	mv	s5,s7
80005120:	c219                	beqz	a2,80005126 <__SEGGER_RTL_vfprintf+0x31c>
80005122:	dffbfa93          	andi	s5,s7,-513
80005126:	0be2                	slli	s7,s7,0x18
80005128:	41fbd613          	srai	a2,s7,0x1f
8000512c:	8df1                	and	a1,a1,a2
8000512e:	d22e                	sw	a1,36(sp)
80005130:	002af613          	andi	a2,s5,2
80005134:	011a9693          	slli	a3,s5,0x11
80005138:	004af593          	andi	a1,s5,4
8000513c:	0006c663          	bltz	a3,80005148 <__SEGGER_RTL_vfprintf+0x33e>
80005140:	e20d                	bnez	a2,80005162 <__SEGGER_RTL_vfprintf+0x358>
80005142:	00448693          	addi	a3,s1,4
80005146:	a02d                	j	80005170 <__SEGGER_RTL_vfprintf+0x366>
80005148:	e229                	bnez	a2,8000518a <__SEGGER_RTL_vfprintf+0x380>
8000514a:	0004ac83          	lw	s9,0(s1)
8000514e:	00448693          	addi	a3,s1,4
80005152:	41fcdc13          	srai	s8,s9,0x1f
80005156:	c5a1                	beqz	a1,8000519e <__SEGGER_RTL_vfprintf+0x394>
80005158:	010c9593          	slli	a1,s9,0x10
8000515c:	4105dc93          	srai	s9,a1,0x10
80005160:	a0b1                	j	800051ac <__SEGGER_RTL_vfprintf+0x3a2>
80005162:	00748613          	addi	a2,s1,7
80005166:	ff867493          	andi	s1,a2,-8
8000516a:	40d0                	lw	a2,4(s1)
8000516c:	00848693          	addi	a3,s1,8
80005170:	0004ac83          	lw	s9,0(s1)
80005174:	e9a9                	bnez	a1,800051c6 <__SEGGER_RTL_vfprintf+0x3bc>
80005176:	008af593          	andi	a1,s5,8
8000517a:	c199                	beqz	a1,80005180 <__SEGGER_RTL_vfprintf+0x376>
8000517c:	0ffcfc93          	zext.b	s9,s9
80005180:	818d                	srli	a1,a1,0x3
80005182:	15fd                	addi	a1,a1,-1
80005184:	00c5fc33          	and	s8,a1,a2
80005188:	a095                	j	800051ec <__SEGGER_RTL_vfprintf+0x3e2>
8000518a:	00748613          	addi	a2,s1,7
8000518e:	9a61                	andi	a2,a2,-8
80005190:	00062c83          	lw	s9,0(a2)
80005194:	00462c03          	lw	s8,4(a2)
80005198:	00860693          	addi	a3,a2,8
8000519c:	fdd5                	bnez	a1,80005158 <__SEGGER_RTL_vfprintf+0x34e>
8000519e:	008af593          	andi	a1,s5,8
800051a2:	c599                	beqz	a1,800051b0 <__SEGGER_RTL_vfprintf+0x3a6>
800051a4:	018c9593          	slli	a1,s9,0x18
800051a8:	4185dc93          	srai	s9,a1,0x18
800051ac:	41f5dc13          	srai	s8,a1,0x1f
800051b0:	020c4063          	bltz	s8,800051d0 <__SEGGER_RTL_vfprintf+0x3c6>
800051b4:	020af593          	andi	a1,s5,32
800051b8:	e59d                	bnez	a1,800051e6 <__SEGGER_RTL_vfprintf+0x3dc>
800051ba:	040af593          	andi	a1,s5,64
800051be:	c59d                	beqz	a1,800051ec <__SEGGER_RTL_vfprintf+0x3e2>
800051c0:	02000593          	li	a1,32
800051c4:	a01d                	j	800051ea <__SEGGER_RTL_vfprintf+0x3e0>
800051c6:	4c01                	li	s8,0
800051c8:	0cc2                	slli	s9,s9,0x10
800051ca:	010cdc93          	srli	s9,s9,0x10
800051ce:	a839                	j	800051ec <__SEGGER_RTL_vfprintf+0x3e2>
800051d0:	019035b3          	snez	a1,s9
800051d4:	41900cb3          	neg	s9,s9
800051d8:	41800633          	neg	a2,s8
800051dc:	40b60c33          	sub	s8,a2,a1
800051e0:	02d00593          	li	a1,45
800051e4:	a019                	j	800051ea <__SEGGER_RTL_vfprintf+0x3e0>
800051e6:	02b00593          	li	a1,43
800051ea:	d22e                	sw	a1,36(sp)
800051ec:	100af593          	andi	a1,s5,256
800051f0:	c199                	beqz	a1,800051f6 <__SEGGER_RTL_vfprintf+0x3ec>
800051f2:	dffafa93          	andi	s5,s5,-513
800051f6:	100af593          	andi	a1,s5,256
800051fa:	e191                	bnez	a1,800051fe <__SEGGER_RTL_vfprintf+0x3f4>
800051fc:	4b05                	li	s6,1
800051fe:	f9c50593          	addi	a1,a0,-100 # 1f9c <__NOR_CFG_OPTION_segment_size__+0x139c>
80005202:	4651                	li	a2,20
80005204:	0cb66563          	bltu	a2,a1,800052ce <__SEGGER_RTL_vfprintf+0x4c4>
80005208:	4672                	lw	a2,28(sp)
8000520a:	00b65633          	srl	a2,a2,a1
8000520e:	8a05                	andi	a2,a2,1
80005210:	ea31                	bnez	a2,80005264 <__SEGGER_RTL_vfprintf+0x45a>
80005212:	00101637          	lui	a2,0x101
80005216:	00b65633          	srl	a2,a2,a1
8000521a:	8a05                	andi	a2,a2,1
8000521c:	ee4d                	bnez	a2,800052d6 <__SEGGER_RTL_vfprintf+0x4cc>
8000521e:	462d                	li	a2,11
80005220:	0ac59763          	bne	a1,a2,800052ce <__SEGGER_RTL_vfprintf+0x4c4>
80005224:	8736                	mv	a4,a3
80005226:	4b81                	li	s7,0
80005228:	018ce533          	or	a0,s9,s8
8000522c:	c915                	beqz	a0,80005260 <__SEGGER_RTL_vfprintf+0x456>
8000522e:	003cd513          	srli	a0,s9,0x3
80005232:	01dc1593          	slli	a1,s8,0x1d
80005236:	8dc9                	or	a1,a1,a0
80005238:	04610513          	addi	a0,sp,70
8000523c:	007cf613          	andi	a2,s9,7
80005240:	8cae                	mv	s9,a1
80005242:	0b85                	addi	s7,s7,1
80005244:	003c5c13          	srli	s8,s8,0x3
80005248:	818d                	srli	a1,a1,0x3
8000524a:	03060613          	addi	a2,a2,48 # 101030 <_flash_size+0x1030>
8000524e:	018ce6b3          	or	a3,s9,s8
80005252:	00c50023          	sb	a2,0(a0)
80005256:	01dc1613          	slli	a2,s8,0x1d
8000525a:	8dd1                	or	a1,a1,a2
8000525c:	0505                	addi	a0,a0,1
8000525e:	fef9                	bnez	a3,8000523c <__SEGGER_RTL_vfprintf+0x432>
80005260:	d63a                	sw	a4,44(sp)
80005262:	acbd                	j	800054e0 <__SEGGER_RTL_vfprintf+0x6d6>
80005264:	d636                	sw	a3,44(sp)
80005266:	4b81                	li	s7,0
80005268:	018ce533          	or	a0,s9,s8
8000526c:	26050a63          	beqz	a0,800054e0 <__SEGGER_RTL_vfprintf+0x6d6>
80005270:	6521                	lui	a0,0x8
80005272:	00aaf4b3          	and	s1,s5,a0
80005276:	c085                	beqz	s1,80005296 <__SEGGER_RTL_vfprintf+0x48c>
80005278:	003bf513          	andi	a0,s7,3
8000527c:	458d                	li	a1,3
8000527e:	00b51c63          	bne	a0,a1,80005296 <__SEGGER_RTL_vfprintf+0x48c>
80005282:	04610413          	addi	s0,sp,70
80005286:	01740533          	add	a0,s0,s7
8000528a:	02c00593          	li	a1,44
8000528e:	00b50023          	sb	a1,0(a0) # 8000 <__AHB_SRAM_segment_size__>
80005292:	0b85                	addi	s7,s7,1
80005294:	a019                	j	8000529a <__SEGGER_RTL_vfprintf+0x490>
80005296:	04610413          	addi	s0,sp,70
8000529a:	4629                	li	a2,10
8000529c:	8566                	mv	a0,s9
8000529e:	85e2                	mv	a1,s8
800052a0:	4681                	li	a3,0
800052a2:	627010ef          	jal	800070c8 <__udivdi3>
800052a6:	001c3613          	seqz	a2,s8
800052aa:	033506b3          	mul	a3,a0,s3
800052ae:	01740733          	add	a4,s0,s7
800052b2:	40dc86b3          	sub	a3,s9,a3
800052b6:	00acb793          	sltiu	a5,s9,10
800052ba:	8e7d                	and	a2,a2,a5
800052bc:	0306e693          	ori	a3,a3,48
800052c0:	00d70023          	sb	a3,0(a4)
800052c4:	0b85                	addi	s7,s7,1
800052c6:	8caa                	mv	s9,a0
800052c8:	8c2e                	mv	s8,a1
800052ca:	d655                	beqz	a2,80005276 <__SEGGER_RTL_vfprintf+0x46c>
800052cc:	ac11                	j	800054e0 <__SEGGER_RTL_vfprintf+0x6d6>
800052ce:	05800593          	li	a1,88
800052d2:	20b51563          	bne	a0,a1,800054dc <__SEGGER_RTL_vfprintf+0x6d2>
800052d6:	84b6                	mv	s1,a3
800052d8:	5412                	lw	s0,36(sp)
800052da:	018ce533          	or	a0,s9,s8
800052de:	d626                	sw	s1,44(sp)
800052e0:	c929                	beqz	a0,80005332 <__SEGGER_RTL_vfprintf+0x528>
800052e2:	012a9593          	slli	a1,s5,0x12
800052e6:	80008537          	lui	a0,0x80008
800052ea:	ce250513          	addi	a0,a0,-798 # 80007ce2 <__SEGGER_RTL_hex_lc>
800052ee:	0005d663          	bgez	a1,800052fa <__SEGGER_RTL_vfprintf+0x4f0>
800052f2:	80008537          	lui	a0,0x80008
800052f6:	cd250513          	addi	a0,a0,-814 # 80007cd2 <__SEGGER_RTL_hex_uc>
800052fa:	4b81                	li	s7,0
800052fc:	004cd593          	srli	a1,s9,0x4
80005300:	01cc1613          	slli	a2,s8,0x1c
80005304:	8e4d                	or	a2,a2,a1
80005306:	04610593          	addi	a1,sp,70
8000530a:	00fcf693          	andi	a3,s9,15
8000530e:	8cb2                	mv	s9,a2
80005310:	004c5c13          	srli	s8,s8,0x4
80005314:	8211                	srli	a2,a2,0x4
80005316:	96aa                	add	a3,a3,a0
80005318:	018ce733          	or	a4,s9,s8
8000531c:	0006c683          	lbu	a3,0(a3)
80005320:	01cc1793          	slli	a5,s8,0x1c
80005324:	8e5d                	or	a2,a2,a5
80005326:	0b85                	addi	s7,s7,1
80005328:	00d58023          	sb	a3,0(a1)
8000532c:	0585                	addi	a1,a1,1
8000532e:	ff71                	bnez	a4,8000530a <__SEGGER_RTL_vfprintf+0x500>
80005330:	aa4d                	j	800054e2 <__SEGGER_RTL_vfprintf+0x6d8>
80005332:	4b81                	li	s7,0
80005334:	a27d                	j	800054e2 <__SEGGER_RTL_vfprintf+0x6d8>
80005336:	6509                	lui	a0,0x2
80005338:	00abebb3          	or	s7,s7,a0
8000533c:	5502                	lw	a0,32(sp)
8000533e:	00abecb3          	or	s9,s7,a0
80005342:	002cf513          	andi	a0,s9,2
80005346:	ed01                	bnez	a0,8000535e <__SEGGER_RTL_vfprintf+0x554>
80005348:	00748513          	addi	a0,s1,7
8000534c:	ff857613          	andi	a2,a0,-8
80005350:	4208                	lw	a0,0(a2)
80005352:	424c                	lw	a1,4(a2)
80005354:	00860493          	addi	s1,a2,8
80005358:	ef6ff0ef          	jal	80004a4e <__truncdfsf2>
8000535c:	a831                	j	80005378 <__SEGGER_RTL_vfprintf+0x56e>
8000535e:	4088                	lw	a0,0(s1)
80005360:	410c                	lw	a1,0(a0)
80005362:	4150                	lw	a2,4(a0)
80005364:	4514                	lw	a3,8(a0)
80005366:	4558                	lw	a4,12(a0)
80005368:	0491                	addi	s1,s1,4
8000536a:	1808                	addi	a0,sp,48
8000536c:	d82e                	sw	a1,48(sp)
8000536e:	da32                	sw	a2,52(sp)
80005370:	dc36                	sw	a3,56(sp)
80005372:	de3a                	sw	a4,60(sp)
80005374:	30b010ef          	jal	80006e7e <__trunctfsf2>
80005378:	842a                	mv	s0,a0
8000537a:	100cf513          	andi	a0,s9,256
8000537e:	e111                	bnez	a0,80005382 <__SEGGER_RTL_vfprintf+0x578>
80005380:	4b19                	li	s6,6
80005382:	000b1863          	bnez	s6,80005392 <__SEGGER_RTL_vfprintf+0x588>
80005386:	5582                	lw	a1,32(sp)
80005388:	00bcf533          	and	a0,s9,a1
8000538c:	8d2d                	xor	a0,a0,a1
8000538e:	00153b13          	seqz	s6,a0
80005392:	8522                	mv	a0,s0
80005394:	311010ef          	jal	80006ea4 <__SEGGER_RTL_float32_isinf>
80005398:	c505                	beqz	a0,800053c0 <__SEGGER_RTL_vfprintf+0x5b6>
8000539a:	8522                	mv	a0,s0
8000539c:	4581                	li	a1,0
8000539e:	d5cff0ef          	jal	800048fa <__ltsf2>
800053a2:	6589                	lui	a1,0x2
800053a4:	00bcf5b3          	and	a1,s9,a1
800053a8:	02055d63          	bgez	a0,800053e2 <__SEGGER_RTL_vfprintf+0x5d8>
800053ac:	80008537          	lui	a0,0x80008
800053b0:	c5550513          	addi	a0,a0,-939 # 80007c55 <.L.str.2>
800053b4:	c5b9                	beqz	a1,80005402 <__SEGGER_RTL_vfprintf+0x5f8>
800053b6:	80008537          	lui	a0,0x80008
800053ba:	c5050513          	addi	a0,a0,-944 # 80007c50 <.L.str.1>
800053be:	a091                	j	80005402 <__SEGGER_RTL_vfprintf+0x5f8>
800053c0:	8522                	mv	a0,s0
800053c2:	2d7010ef          	jal	80006e98 <__SEGGER_RTL_float32_isnan>
800053c6:	c15d                	beqz	a0,8000546c <__SEGGER_RTL_vfprintf+0x662>
800053c8:	012c9593          	slli	a1,s9,0x12
800053cc:	80008537          	lui	a0,0x80008
800053d0:	cf650513          	addi	a0,a0,-778 # 80007cf6 <.L.str.6>
800053d4:	0205d763          	bgez	a1,80005402 <__SEGGER_RTL_vfprintf+0x5f8>
800053d8:	80008537          	lui	a0,0x80008
800053dc:	cf250513          	addi	a0,a0,-782 # 80007cf2 <.L.str.5>
800053e0:	a00d                	j	80005402 <__SEGGER_RTL_vfprintf+0x5f8>
800053e2:	c591                	beqz	a1,800053ee <__SEGGER_RTL_vfprintf+0x5e4>
800053e4:	800085b7          	lui	a1,0x80008
800053e8:	c5a58593          	addi	a1,a1,-934 # 80007c5a <.L.str.3>
800053ec:	a029                	j	800053f6 <__SEGGER_RTL_vfprintf+0x5ec>
800053ee:	800085b7          	lui	a1,0x80008
800053f2:	c5f58593          	addi	a1,a1,-929 # 80007c5f <.L.str.4>
800053f6:	00158513          	addi	a0,a1,1
800053fa:	020cf613          	andi	a2,s9,32
800053fe:	c211                	beqz	a2,80005402 <__SEGGER_RTL_vfprintf+0x5f8>
80005400:	852e                	mv	a0,a1
80005402:	effcfb93          	andi	s7,s9,-257
80005406:	02500c93          	li	s9,37
8000540a:	0b918413          	addi	s0,gp,185 # 80003949 <.L.str>
8000540e:	c111                	beqz	a0,80005412 <__SEGGER_RTL_vfprintf+0x608>
80005410:	842a                	mv	s0,a0
80005412:	100bf513          	andi	a0,s7,256
80005416:	e509                	bnez	a0,80005420 <__SEGGER_RTL_vfprintf+0x616>
80005418:	8522                	mv	a0,s0
8000541a:	602020ef          	jal	80007a1c <strlen>
8000541e:	a029                	j	80005428 <__SEGGER_RTL_vfprintf+0x61e>
80005420:	8522                	mv	a0,s0
80005422:	85da                	mv	a1,s6
80005424:	f6eff0ef          	jal	80004b92 <strnlen>
80005428:	8b2a                	mv	s6,a0
8000542a:	dffbfb93          	andi	s7,s7,-513
8000542e:	40aa8ab3          	sub	s5,s5,a0
80005432:	8552                	mv	a0,s4
80005434:	85de                	mv	a1,s7
80005436:	8656                	mv	a2,s5
80005438:	30fd                	jal	80004d26 <__SEGGER_RTL_pre_padding>
8000543a:	000b0f63          	beqz	s6,80005458 <__SEGGER_RTL_vfprintf+0x64e>
8000543e:	8c26                	mv	s8,s1
80005440:	9b22                	add	s6,s6,s0
80005442:	00044583          	lbu	a1,0(s0)
80005446:	00140493          	addi	s1,s0,1
8000544a:	8552                	mv	a0,s4
8000544c:	fe4ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005450:	8426                	mv	s0,s1
80005452:	ff6498e3          	bne	s1,s6,80005442 <__SEGGER_RTL_vfprintf+0x638>
80005456:	84e2                	mv	s1,s8
80005458:	010bf413          	andi	s0,s7,16
8000545c:	a00408e3          	beqz	s0,80004e6c <__SEGGER_RTL_vfprintf+0x62>
80005460:	02000593          	li	a1,32
80005464:	8552                	mv	a0,s4
80005466:	8656                	mv	a2,s5
80005468:	3069                	jal	80004cf2 <__SEGGER_RTL_print_padding>
8000546a:	b409                	j	80004e6c <__SEGGER_RTL_vfprintf+0x62>
8000546c:	d456                	sw	s5,40(sp)
8000546e:	8522                	mv	a0,s0
80005470:	245010ef          	jal	80006eb4 <__SEGGER_RTL_float32_isnormal>
80005474:	00153513          	seqz	a0,a0
80005478:	157d                	addi	a0,a0,-1
8000547a:	00857bb3          	and	s7,a0,s0
8000547e:	855e                	mv	a0,s7
80005480:	24d010ef          	jal	80006ecc <__SEGGER_RTL_float32_signbit>
80005484:	8aaa                	mv	s5,a0
80005486:	00a03533          	snez	a0,a0
8000548a:	057e                	slli	a0,a0,0x1f
8000548c:	00abc433          	xor	s0,s7,a0
80005490:	08ec                	addi	a1,sp,92
80005492:	8522                	mv	a0,s0
80005494:	e40ff0ef          	jal	80004ad4 <frexpf>
80005498:	4576                	lw	a0,92(sp)
8000549a:	00151593          	slli	a1,a0,0x1
8000549e:	952e                	add	a0,a0,a1
800054a0:	45e2                	lw	a1,24(sp)
800054a2:	02b51533          	mulh	a0,a0,a1
800054a6:	01f55c13          	srli	s8,a0,0x1f
800054aa:	8509                	srai	a0,a0,0x2
800054ac:	9c2a                	add	s8,s8,a0
800054ae:	cee2                	sw	s8,92(sp)
800054b0:	855e                	mv	a0,s7
800054b2:	4581                	li	a1,0
800054b4:	0d7010ef          	jal	80006d8a <__eqsf2>
800054b8:	0e050963          	beqz	a0,800055aa <__SEGGER_RTL_vfprintf+0x7a0>
800054bc:	001c0513          	addi	a0,s8,1
800054c0:	5c4020ef          	jal	80007a84 <__SEGGER_RTL_pow10f>
800054c4:	85aa                	mv	a1,a0
800054c6:	8522                	mv	a0,s0
800054c8:	c6cff0ef          	jal	80004934 <__gtsf2>
800054cc:	0ca05263          	blez	a0,80005590 <__SEGGER_RTL_vfprintf+0x786>
800054d0:	4576                	lw	a0,92(sp)
800054d2:	00150593          	addi	a1,a0,1
800054d6:	ceae                	sw	a1,92(sp)
800054d8:	0509                	addi	a0,a0,2
800054da:	b7dd                	j	800054c0 <__SEGGER_RTL_vfprintf+0x6b6>
800054dc:	4b81                	li	s7,0
800054de:	d636                	sw	a3,44(sp)
800054e0:	5412                	lw	s0,36(sp)
800054e2:	417b0533          	sub	a0,s6,s7
800054e6:	10043593          	sltiu	a1,s0,256
800054ea:	8ca2                	mv	s9,s0
800054ec:	00143613          	seqz	a2,s0
800054f0:	15f9                	addi	a1,a1,-2
800054f2:	167d                	addi	a2,a2,-1
800054f4:	8df1                	and	a1,a1,a2
800054f6:	00a02633          	sgtz	a2,a0
800054fa:	40c004b3          	neg	s1,a2
800054fe:	8ce9                	and	s1,s1,a0
80005500:	009b8533          	add	a0,s7,s1
80005504:	5422                	lw	s0,40(sp)
80005506:	8c09                	sub	s0,s0,a0
80005508:	200af513          	andi	a0,s5,512
8000550c:	00b40b33          	add	s6,s0,a1
80005510:	4c05                	li	s8,1
80005512:	e511                	bnez	a0,8000551e <__SEGGER_RTL_vfprintf+0x714>
80005514:	8552                	mv	a0,s4
80005516:	85d6                	mv	a1,s5
80005518:	865a                	mv	a2,s6
8000551a:	3031                	jal	80004d26 <__SEGGER_RTL_pre_padding>
8000551c:	4b01                	li	s6,0
8000551e:	04510413          	addi	s0,sp,69
80005522:	10000513          	li	a0,256
80005526:	00ace963          	bltu	s9,a0,80005538 <__SEGGER_RTL_vfprintf+0x72e>
8000552a:	008cd593          	srli	a1,s9,0x8
8000552e:	8552                	mv	a0,s4
80005530:	f00ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005534:	85e6                	mv	a1,s9
80005536:	a021                	j	8000553e <__SEGGER_RTL_vfprintf+0x734>
80005538:	85e6                	mv	a1,s9
8000553a:	000c8563          	beqz	s9,80005544 <__SEGGER_RTL_vfprintf+0x73a>
8000553e:	8552                	mv	a0,s4
80005540:	ef0ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005544:	8552                	mv	a0,s4
80005546:	85d6                	mv	a1,s5
80005548:	865a                	mv	a2,s6
8000554a:	fdcff0ef          	jal	80004d26 <__SEGGER_RTL_pre_padding>
8000554e:	03000593          	li	a1,48
80005552:	8552                	mv	a0,s4
80005554:	8626                	mv	a2,s1
80005556:	f9cff0ef          	jal	80004cf2 <__SEGGER_RTL_print_padding>
8000555a:	01705d63          	blez	s7,80005574 <__SEGGER_RTL_vfprintf+0x76a>
8000555e:	84de                	mv	s1,s7
80005560:	01740533          	add	a0,s0,s7
80005564:	00054583          	lbu	a1,0(a0)
80005568:	1bfd                	addi	s7,s7,-1
8000556a:	8552                	mv	a0,s4
8000556c:	ec4ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005570:	fe9c67e3          	bltu	s8,s1,8000555e <__SEGGER_RTL_vfprintf+0x754>
80005574:	010af513          	andi	a0,s5,16
80005578:	54b2                	lw	s1,44(sp)
8000557a:	02500c93          	li	s9,37
8000557e:	8e0507e3          	beqz	a0,80004e6c <__SEGGER_RTL_vfprintf+0x62>
80005582:	02000593          	li	a1,32
80005586:	8552                	mv	a0,s4
80005588:	865a                	mv	a2,s6
8000558a:	f68ff0ef          	jal	80004cf2 <__SEGGER_RTL_print_padding>
8000558e:	b8f9                	j	80004e6c <__SEGGER_RTL_vfprintf+0x62>
80005590:	4576                	lw	a0,92(sp)
80005592:	4f2020ef          	jal	80007a84 <__SEGGER_RTL_pow10f>
80005596:	85aa                	mv	a1,a0
80005598:	8522                	mv	a0,s0
8000559a:	b60ff0ef          	jal	800048fa <__ltsf2>
8000559e:	00055663          	bgez	a0,800055aa <__SEGGER_RTL_vfprintf+0x7a0>
800055a2:	4576                	lw	a0,92(sp)
800055a4:	157d                	addi	a0,a0,-1
800055a6:	ceaa                	sw	a0,92(sp)
800055a8:	b7ed                	j	80005592 <__SEGGER_RTL_vfprintf+0x788>
800055aa:	001ab513          	seqz	a0,s5
800055ae:	157d                	addi	a0,a0,-1
800055b0:	06057593          	andi	a1,a0,96
800055b4:	4576                	lw	a0,92(sp)
800055b6:	00bcec33          	or	s8,s9,a1
800055ba:	5582                	lw	a1,32(sp)
800055bc:	00bc7ab3          	and	s5,s8,a1
800055c0:	40000593          	li	a1,1024
800055c4:	d626                	sw	s1,44(sp)
800055c6:	02ba8a63          	beq	s5,a1,800055fa <__SEGGER_RTL_vfprintf+0x7f0>
800055ca:	5582                	lw	a1,32(sp)
800055cc:	00ba9763          	bne	s5,a1,800055da <__SEGGER_RTL_vfprintf+0x7d0>
800055d0:	03655563          	bge	a0,s6,800055fa <__SEGGER_RTL_vfprintf+0x7f0>
800055d4:	55ed                	li	a1,-5
800055d6:	02a5d263          	bge	a1,a0,800055fa <__SEGGER_RTL_vfprintf+0x7f0>
800055da:	400c7593          	andi	a1,s8,1024
800055de:	080c7693          	andi	a3,s8,128
800055e2:	ca36                	sw	a3,20(sp)
800055e4:	80003ab7          	lui	s5,0x80003
800055e8:	068a8a93          	addi	s5,s5,104 # 80003068 <__SEGGER_RTL_ipow10>
800055ec:	0c058b63          	beqz	a1,800056c2 <__SEGGER_RTL_vfprintf+0x8b8>
800055f0:	45b9                	li	a1,14
800055f2:	08a5d563          	bge	a1,a0,8000567c <__SEGGER_RTL_vfprintf+0x872>
800055f6:	4b01                	li	s6,0
800055f8:	a0e9                	j	800056c2 <__SEGGER_RTL_vfprintf+0x8b8>
800055fa:	02500c93          	li	s9,37
800055fe:	02600593          	li	a1,38
80005602:	00b51f63          	bne	a0,a1,80005620 <__SEGGER_RTL_vfprintf+0x816>
80005606:	8522                	mv	a0,s0
80005608:	45b2                	lw	a1,12(sp)
8000560a:	680010ef          	jal	80006c8a <__divsf3>
8000560e:	a00d                	j	80005630 <__SEGGER_RTL_vfprintf+0x826>
80005610:	84051ee3          	bnez	a0,80004e6c <__SEGGER_RTL_vfprintf+0x62>
80005614:	a509                	j	80005c16 <__SEGGER_RTL_vfprintf+0xe0c>
80005616:	000a2583          	lw	a1,0(s4)
8000561a:	00b50023          	sb	a1,0(a0)
8000561e:	a8a1                	j	80005676 <__SEGGER_RTL_vfprintf+0x86c>
80005620:	40a00533          	neg	a0,a0
80005624:	460020ef          	jal	80007a84 <__SEGGER_RTL_pow10f>
80005628:	85aa                	mv	a1,a0
8000562a:	8522                	mv	a0,s0
8000562c:	5ae010ef          	jal	80006bda <__mulsf3>
80005630:	842a                	mv	s0,a0
80005632:	4581                	li	a1,0
80005634:	756010ef          	jal	80006d8a <__eqsf2>
80005638:	1a050c63          	beqz	a0,800057f0 <__SEGGER_RTL_vfprintf+0x9e6>
8000563c:	8522                	mv	a0,s0
8000563e:	067010ef          	jal	80006ea4 <__SEGGER_RTL_float32_isinf>
80005642:	14050c63          	beqz	a0,8000579a <__SEGGER_RTL_vfprintf+0x990>
80005646:	8522                	mv	a0,s0
80005648:	4581                	li	a1,0
8000564a:	ab0ff0ef          	jal	800048fa <__ltsf2>
8000564e:	6589                	lui	a1,0x2
80005650:	00bc75b3          	and	a1,s8,a1
80005654:	54055d63          	bgez	a0,80005bae <__SEGGER_RTL_vfprintf+0xda4>
80005658:	80008537          	lui	a0,0x80008
8000565c:	c5550513          	addi	a0,a0,-939 # 80007c55 <.L.str.2>
80005660:	5aa2                	lw	s5,40(sp)
80005662:	56058763          	beqz	a1,80005bd0 <__SEGGER_RTL_vfprintf+0xdc6>
80005666:	80008537          	lui	a0,0x80008
8000566a:	c5050513          	addi	a0,a0,-944 # 80007c50 <.L.str.1>
8000566e:	a38d                	j	80005bd0 <__SEGGER_RTL_vfprintf+0xdc6>
80005670:	c10c                	sw	a1,0(a0)
80005672:	00052223          	sw	zero,4(a0)
80005676:	0491                	addi	s1,s1,4
80005678:	ff4ff06f          	j	80004e6c <__SEGGER_RTL_vfprintf+0x62>
8000567c:	fff54593          	not	a1,a0
80005680:	95da                	add	a1,a1,s6
80005682:	4641                	li	a2,16
80005684:	8b2e                	mv	s6,a1
80005686:	00c5c363          	blt	a1,a2,8000568c <__SEGGER_RTL_vfprintf+0x882>
8000568a:	4b41                	li	s6,16
8000568c:	ea9d                	bnez	a3,800056c2 <__SEGGER_RTL_vfprintf+0x8b8>
8000568e:	c995                	beqz	a1,800056c2 <__SEGGER_RTL_vfprintf+0x8b8>
80005690:	855a                	mv	a0,s6
80005692:	3f2020ef          	jal	80007a84 <__SEGGER_RTL_pow10f>
80005696:	85aa                	mv	a1,a0
80005698:	8522                	mv	a0,s0
8000569a:	540010ef          	jal	80006bda <__mulsf3>
8000569e:	3f0005b7          	lui	a1,0x3f000
800056a2:	8aaff0ef          	jal	8000474c <__addsf3>
800056a6:	1bb010ef          	jal	80007060 <floorf>
800056aa:	412005b7          	lui	a1,0x41200
800056ae:	067010ef          	jal	80006f14 <fmodf>
800056b2:	4581                	li	a1,0
800056b4:	6d6010ef          	jal	80006d8a <__eqsf2>
800056b8:	e501                	bnez	a0,800056c0 <__SEGGER_RTL_vfprintf+0x8b6>
800056ba:	1b7d                	addi	s6,s6,-1
800056bc:	fc0b1ae3          	bnez	s6,80005690 <__SEGGER_RTL_vfprintf+0x886>
800056c0:	4576                	lw	a0,92(sp)
800056c2:	416005b3          	neg	a1,s6
800056c6:	1541                	addi	a0,a0,-16
800056c8:	00a5c363          	blt	a1,a0,800056ce <__SEGGER_RTL_vfprintf+0x8c4>
800056cc:	852e                	mv	a0,a1
800056ce:	3b6020ef          	jal	80007a84 <__SEGGER_RTL_pow10f>
800056d2:	55fd                	li	a1,-1
800056d4:	7fc010ef          	jal	80006ed0 <ldexpf>
800056d8:	85aa                	mv	a1,a0
800056da:	8522                	mv	a0,s0
800056dc:	870ff0ef          	jal	8000474c <__addsf3>
800056e0:	8baa                	mv	s7,a0
800056e2:	4576                	lw	a0,92(sp)
800056e4:	0505                	addi	a0,a0,1
800056e6:	39e020ef          	jal	80007a84 <__SEGGER_RTL_pow10f>
800056ea:	85aa                	mv	a1,a0
800056ec:	855e                	mv	a0,s7
800056ee:	a78ff0ef          	jal	80004966 <__gesf2>
800056f2:	45f6                	lw	a1,92(sp)
800056f4:	00052513          	slti	a0,a0,0
800056f8:	00154513          	xori	a0,a0,1
800056fc:	952e                	add	a0,a0,a1
800056fe:	02054663          	bltz	a0,8000572a <__SEGGER_RTL_vfprintf+0x920>
80005702:	45c5                	li	a1,17
80005704:	02b56863          	bltu	a0,a1,80005734 <__SEGGER_RTL_vfprintf+0x92a>
80005708:	ff050593          	addi	a1,a0,-16
8000570c:	ceae                	sw	a1,92(sp)
8000570e:	40ad8533          	sub	a0,s11,a0
80005712:	372020ef          	jal	80007a84 <__SEGGER_RTL_pow10f>
80005716:	85aa                	mv	a1,a0
80005718:	855e                	mv	a0,s7
8000571a:	4c0010ef          	jal	80006bda <__mulsf3>
8000571e:	698010ef          	jal	80006db6 <__fixunssfdi>
80005722:	842a                	mv	s0,a0
80005724:	84ae                	mv	s1,a1
80005726:	d202                	sw	zero,36(sp)
80005728:	a01d                	j	8000574e <__SEGGER_RTL_vfprintf+0x944>
8000572a:	d25e                	sw	s7,36(sp)
8000572c:	4401                	li	s0,0
8000572e:	4481                	li	s1,0
80005730:	ce82                	sw	zero,92(sp)
80005732:	a831                	j	8000574e <__SEGGER_RTL_vfprintf+0x944>
80005734:	ce82                	sw	zero,92(sp)
80005736:	855e                	mv	a0,s7
80005738:	67e010ef          	jal	80006db6 <__fixunssfdi>
8000573c:	842a                	mv	s0,a0
8000573e:	84ae                	mv	s1,a1
80005740:	a64ff0ef          	jal	800049a4 <__floatundisf>
80005744:	85aa                	mv	a1,a0
80005746:	855e                	mv	a0,s7
80005748:	ffdfe0ef          	jal	80004744 <__subsf3>
8000574c:	d22a                	sw	a0,36(sp)
8000574e:	4c81                	li	s9,0
80005750:	bffc7b93          	andi	s7,s8,-1025
80005754:	5522                	lw	a0,40(sp)
80005756:	40ab0533          	sub	a0,s6,a0
8000575a:	008a8593          	addi	a1,s5,8
8000575e:	46d2                	lw	a3,20(sp)
80005760:	41d0                	lw	a2,4(a1)
80005762:	00c48563          	beq	s1,a2,8000576c <__SEGGER_RTL_vfprintf+0x962>
80005766:	00c4b633          	sltu	a2,s1,a2
8000576a:	a021                	j	80005772 <__SEGGER_RTL_vfprintf+0x968>
8000576c:	4190                	lw	a2,0(a1)
8000576e:	00c43633          	sltu	a2,s0,a2
80005772:	0505                	addi	a0,a0,1
80005774:	0c85                	addi	s9,s9,1
80005776:	05a1                	addi	a1,a1,8 # 41200008 <_flash_size+0x41100008>
80005778:	d665                	beqz	a2,80005760 <__SEGGER_RTL_vfprintf+0x956>
8000577a:	45f6                	lw	a1,92(sp)
8000577c:	00db6633          	or	a2,s6,a3
80005780:	060c7693          	andi	a3,s8,96
80005784:	00163613          	seqz	a2,a2
80005788:	00d036b3          	snez	a3,a3
8000578c:	fff6c693          	not	a3,a3
80005790:	9636                	add	a2,a2,a3
80005792:	8e0d                	sub	a2,a2,a1
80005794:	40a60ab3          	sub	s5,a2,a0
80005798:	a2e9                	j	80005962 <__SEGGER_RTL_vfprintf+0xb58>
8000579a:	44f6                	lw	s1,92(sp)
8000579c:	412005b7          	lui	a1,0x41200
800057a0:	8522                	mv	a0,s0
800057a2:	9c4ff0ef          	jal	80004966 <__gesf2>
800057a6:	02054063          	bltz	a0,800057c6 <__SEGGER_RTL_vfprintf+0x9bc>
800057aa:	412005b7          	lui	a1,0x41200
800057ae:	8522                	mv	a0,s0
800057b0:	4da010ef          	jal	80006c8a <__divsf3>
800057b4:	842a                	mv	s0,a0
800057b6:	0485                	addi	s1,s1,1
800057b8:	412005b7          	lui	a1,0x41200
800057bc:	9aaff0ef          	jal	80004966 <__gesf2>
800057c0:	fe0555e3          	bgez	a0,800057aa <__SEGGER_RTL_vfprintf+0x9a0>
800057c4:	cea6                	sw	s1,92(sp)
800057c6:	3f8005b7          	lui	a1,0x3f800
800057ca:	8522                	mv	a0,s0
800057cc:	92eff0ef          	jal	800048fa <__ltsf2>
800057d0:	02055063          	bgez	a0,800057f0 <__SEGGER_RTL_vfprintf+0x9e6>
800057d4:	412005b7          	lui	a1,0x41200
800057d8:	8522                	mv	a0,s0
800057da:	400010ef          	jal	80006bda <__mulsf3>
800057de:	842a                	mv	s0,a0
800057e0:	14fd                	addi	s1,s1,-1
800057e2:	3f8005b7          	lui	a1,0x3f800
800057e6:	914ff0ef          	jal	800048fa <__ltsf2>
800057ea:	fe0545e3          	bltz	a0,800057d4 <__SEGGER_RTL_vfprintf+0x9ca>
800057ee:	cea6                	sw	s1,92(sp)
800057f0:	001b3513          	seqz	a0,s6
800057f4:	5582                	lw	a1,32(sp)
800057f6:	00bac5b3          	xor	a1,s5,a1
800057fa:	0015b593          	seqz	a1,a1
800057fe:	40bb0b33          	sub	s6,s6,a1
80005802:	157d                	addi	a0,a0,-1
80005804:	01657bb3          	and	s7,a0,s6
80005808:	41700533          	neg	a0,s7
8000580c:	278020ef          	jal	80007a84 <__SEGGER_RTL_pow10f>
80005810:	55fd                	li	a1,-1
80005812:	6be010ef          	jal	80006ed0 <ldexpf>
80005816:	85aa                	mv	a1,a0
80005818:	8522                	mv	a0,s0
8000581a:	f33fe0ef          	jal	8000474c <__addsf3>
8000581e:	8caa                	mv	s9,a0
80005820:	412005b7          	lui	a1,0x41200
80005824:	942ff0ef          	jal	80004966 <__gesf2>
80005828:	00054b63          	bltz	a0,8000583e <__SEGGER_RTL_vfprintf+0xa34>
8000582c:	4576                	lw	a0,92(sp)
8000582e:	0505                	addi	a0,a0,1
80005830:	ceaa                	sw	a0,92(sp)
80005832:	412005b7          	lui	a1,0x41200
80005836:	8566                	mv	a0,s9
80005838:	452010ef          	jal	80006c8a <__divsf3>
8000583c:	8caa                	mv	s9,a0
8000583e:	5aa2                	lw	s5,40(sp)
80005840:	060b8563          	beqz	s7,800058aa <__SEGGER_RTL_vfprintf+0xaa0>
80005844:	5502                	lw	a0,32(sp)
80005846:	c8050513          	addi	a0,a0,-896
8000584a:	00ac7533          	and	a0,s8,a0
8000584e:	4592                	lw	a1,4(sp)
80005850:	04b51e63          	bne	a0,a1,800058ac <__SEGGER_RTL_vfprintf+0xaa2>
80005854:	4541                	li	a0,16
80005856:	00abc363          	blt	s7,a0,8000585c <__SEGGER_RTL_vfprintf+0xa52>
8000585a:	4bc1                	li	s7,16
8000585c:	855e                	mv	a0,s7
8000585e:	226020ef          	jal	80007a84 <__SEGGER_RTL_pow10f>
80005862:	85aa                	mv	a1,a0
80005864:	8566                	mv	a0,s9
80005866:	374010ef          	jal	80006bda <__mulsf3>
8000586a:	54c010ef          	jal	80006db6 <__fixunssfdi>
8000586e:	842a                	mv	s0,a0
80005870:	8d4d                	or	a0,a0,a1
80005872:	cd05                	beqz	a0,800058aa <__SEGGER_RTL_vfprintf+0xaa0>
80005874:	84ae                	mv	s1,a1
80005876:	4629                	li	a2,10
80005878:	8522                	mv	a0,s0
8000587a:	85a6                	mv	a1,s1
8000587c:	4681                	li	a3,0
8000587e:	04b010ef          	jal	800070c8 <__udivdi3>
80005882:	03358633          	mul	a2,a1,s3
80005886:	033536b3          	mulhu	a3,a0,s3
8000588a:	9636                	add	a2,a2,a3
8000588c:	033506b3          	mul	a3,a0,s3
80005890:	8c91                	sub	s1,s1,a2
80005892:	00d43633          	sltu	a2,s0,a3
80005896:	8c91                	sub	s1,s1,a2
80005898:	8c15                	sub	s0,s0,a3
8000589a:	8c45                	or	s0,s0,s1
8000589c:	32041e63          	bnez	s0,80005bd8 <__SEGGER_RTL_vfprintf+0xdce>
800058a0:	1bfd                	addi	s7,s7,-1
800058a2:	842a                	mv	s0,a0
800058a4:	84ae                	mv	s1,a1
800058a6:	fc0b98e3          	bnez	s7,80005876 <__SEGGER_RTL_vfprintf+0xa6c>
800058aa:	4b01                	li	s6,0
800058ac:	d266                	sw	s9,36(sp)
800058ae:	080c7513          	andi	a0,s8,128
800058b2:	416a85b3          	sub	a1,s5,s6
800058b6:	4476                	lw	s0,92(sp)
800058b8:	00ab6533          	or	a0,s6,a0
800058bc:	00a03533          	snez	a0,a0
800058c0:	8d89                	sub	a1,a1,a0
800058c2:	013c1513          	slli	a0,s8,0x13
800058c6:	ffb58a93          	addi	s5,a1,-5 # 411ffffb <_flash_size+0x410ffffb>
800058ca:	00054463          	bltz	a0,800058d2 <__SEGGER_RTL_vfprintf+0xac8>
800058ce:	4c85                	li	s9,1
800058d0:	a891                	j	80005924 <__SEGGER_RTL_vfprintf+0xb1a>
800058d2:	4502                	lw	a0,0(sp)
800058d4:	02a41533          	mulh	a0,s0,a0
800058d8:	01f55593          	srli	a1,a0,0x1f
800058dc:	952e                	add	a0,a0,a1
800058de:	00151593          	slli	a1,a0,0x1
800058e2:	40a40533          	sub	a0,s0,a0
800058e6:	8d0d                	sub	a0,a0,a1
800058e8:	0509                	addi	a0,a0,2
800058ea:	050a                	slli	a0,a0,0x2
800058ec:	edc18593          	addi	a1,gp,-292 # 8000376c <.LJTI0_3>
800058f0:	952e                	add	a0,a0,a1
800058f2:	4108                	lw	a0,0(a0)
800058f4:	4b89                	li	s7,2
800058f6:	54fd                	li	s1,-1
800058f8:	412005b7          	lui	a1,0x41200
800058fc:	4c85                	li	s9,1
800058fe:	8502                	jr	a0
80005900:	4b8d                	li	s7,3
80005902:	54f9                	li	s1,-2
80005904:	42c805b7          	lui	a1,0x42c80
80005908:	5512                	lw	a0,36(sp)
8000590a:	2d0010ef          	jal	80006bda <__mulsf3>
8000590e:	d22a                	sw	a0,36(sp)
80005910:	9426                	add	s0,s0,s1
80005912:	cea2                	sw	s0,92(sp)
80005914:	9aa6                	add	s5,s5,s1
80005916:	8cde                	mv	s9,s7
80005918:	01602533          	sgtz	a0,s6
8000591c:	40a00533          	neg	a0,a0
80005920:	01657b33          	and	s6,a0,s6
80005924:	4542                	lw	a0,16(sp)
80005926:	00ac7bb3          	and	s7,s8,a0
8000592a:	060c7513          	andi	a0,s8,96
8000592e:	00a03533          	snez	a0,a0
80005932:	40aa84b3          	sub	s1,s5,a0
80005936:	8522                	mv	a0,s0
80005938:	9caff0ef          	jal	80004b02 <abs>
8000593c:	06452513          	slti	a0,a0,100
80005940:	00154513          	xori	a0,a0,1
80005944:	40a48ab3          	sub	s5,s1,a0
80005948:	5c12                	lw	s8,36(sp)
8000594a:	8562                	mv	a0,s8
8000594c:	46a010ef          	jal	80006db6 <__fixunssfdi>
80005950:	842a                	mv	s0,a0
80005952:	84ae                	mv	s1,a1
80005954:	850ff0ef          	jal	800049a4 <__floatundisf>
80005958:	85aa                	mv	a1,a0
8000595a:	8562                	mv	a0,s8
8000595c:	de9fe0ef          	jal	80004744 <__subsf3>
80005960:	d22a                	sw	a0,36(sp)
80005962:	01502533          	sgtz	a0,s5
80005966:	40a00533          	neg	a0,a0
8000596a:	210bf593          	andi	a1,s7,528
8000596e:	01557c33          	and	s8,a0,s5
80005972:	e999                	bnez	a1,80005988 <__SEGGER_RTL_vfprintf+0xb7e>
80005974:	01505a63          	blez	s5,80005988 <__SEGGER_RTL_vfprintf+0xb7e>
80005978:	1c7d                	addi	s8,s8,-1
8000597a:	02000593          	li	a1,32
8000597e:	8552                	mv	a0,s4
80005980:	ab0ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005984:	fe0c1ae3          	bnez	s8,80005978 <__SEGGER_RTL_vfprintf+0xb6e>
80005988:	80003ab7          	lui	s5,0x80003
8000598c:	068a8a93          	addi	s5,s5,104 # 80003068 <__SEGGER_RTL_ipow10>
80005990:	020bf593          	andi	a1,s7,32
80005994:	040bf513          	andi	a0,s7,64
80005998:	e589                	bnez	a1,800059a2 <__SEGGER_RTL_vfprintf+0xb98>
8000599a:	cd09                	beqz	a0,800059b4 <__SEGGER_RTL_vfprintf+0xbaa>
8000599c:	02000593          	li	a1,32
800059a0:	a039                	j	800059ae <__SEGGER_RTL_vfprintf+0xba4>
800059a2:	c501                	beqz	a0,800059aa <__SEGGER_RTL_vfprintf+0xba0>
800059a4:	02d00593          	li	a1,45
800059a8:	a019                	j	800059ae <__SEGGER_RTL_vfprintf+0xba4>
800059aa:	02b00593          	li	a1,43
800059ae:	8552                	mv	a0,s4
800059b0:	a80ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
800059b4:	010bf513          	andi	a0,s7,16
800059b8:	e919                	bnez	a0,800059ce <__SEGGER_RTL_vfprintf+0xbc4>
800059ba:	000c0a63          	beqz	s8,800059ce <__SEGGER_RTL_vfprintf+0xbc4>
800059be:	1c7d                	addi	s8,s8,-1
800059c0:	03000593          	li	a1,48
800059c4:	8552                	mv	a0,s4
800059c6:	a6aff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
800059ca:	fe0c1ae3          	bnez	s8,800059be <__SEGGER_RTL_vfprintf+0xbb4>
800059ce:	1cfd                	addi	s9,s9,-1
800059d0:	003c9513          	slli	a0,s9,0x3
800059d4:	00aa85b3          	add	a1,s5,a0
800059d8:	41c8                	lw	a0,4(a1)
800059da:	418c                	lw	a1,0(a1)
800059dc:	02a48863          	beq	s1,a0,80005a0c <__SEGGER_RTL_vfprintf+0xc02>
800059e0:	00a4b633          	sltu	a2,s1,a0
800059e4:	e61d                	bnez	a2,80005a12 <__SEGGER_RTL_vfprintf+0xc08>
800059e6:	03000613          	li	a2,48
800059ea:	00b436b3          	sltu	a3,s0,a1
800059ee:	8c89                	sub	s1,s1,a0
800059f0:	8c95                	sub	s1,s1,a3
800059f2:	8c0d                	sub	s0,s0,a1
800059f4:	00a48563          	beq	s1,a0,800059fe <__SEGGER_RTL_vfprintf+0xbf4>
800059f8:	00a4b6b3          	sltu	a3,s1,a0
800059fc:	a019                	j	80005a02 <__SEGGER_RTL_vfprintf+0xbf8>
800059fe:	00b436b3          	sltu	a3,s0,a1
80005a02:	0605                	addi	a2,a2,1
80005a04:	d2fd                	beqz	a3,800059ea <__SEGGER_RTL_vfprintf+0xbe0>
80005a06:	0ff67593          	zext.b	a1,a2
80005a0a:	a031                	j	80005a16 <__SEGGER_RTL_vfprintf+0xc0c>
80005a0c:	00b43633          	sltu	a2,s0,a1
80005a10:	da79                	beqz	a2,800059e6 <__SEGGER_RTL_vfprintf+0xbdc>
80005a12:	03000593          	li	a1,48
80005a16:	8552                	mv	a0,s4
80005a18:	a18ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005a1c:	fa0c99e3          	bnez	s9,800059ce <__SEGGER_RTL_vfprintf+0xbc4>
80005a20:	5502                	lw	a0,32(sp)
80005a22:	c0050513          	addi	a0,a0,-1024
80005a26:	00abf433          	and	s0,s7,a0
80005a2a:	cc01                	beqz	s0,80005a42 <__SEGGER_RTL_vfprintf+0xc38>
80005a2c:	4576                	lw	a0,92(sp)
80005a2e:	00a05a63          	blez	a0,80005a42 <__SEGGER_RTL_vfprintf+0xc38>
80005a32:	157d                	addi	a0,a0,-1
80005a34:	ceaa                	sw	a0,92(sp)
80005a36:	03000593          	li	a1,48
80005a3a:	8552                	mv	a0,s4
80005a3c:	9f4ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005a40:	b7f5                	j	80005a2c <__SEGGER_RTL_vfprintf+0xc22>
80005a42:	080bf513          	andi	a0,s7,128
80005a46:	00ab6533          	or	a0,s6,a0
80005a4a:	54b2                	lw	s1,44(sp)
80005a4c:	cd55                	beqz	a0,80005b08 <__SEGGER_RTL_vfprintf+0xcfe>
80005a4e:	02e00593          	li	a1,46
80005a52:	8552                	mv	a0,s4
80005a54:	9dcff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005a58:	45c1                	li	a1,16
80005a5a:	855a                	mv	a0,s6
80005a5c:	00bb4363          	blt	s6,a1,80005a62 <__SEGGER_RTL_vfprintf+0xc58>
80005a60:	4541                	li	a0,16
80005a62:	00a025b3          	sgtz	a1,a0
80005a66:	4676                	lw	a2,92(sp)
80005a68:	40b005b3          	neg	a1,a1
80005a6c:	00a5fcb3          	and	s9,a1,a0
80005a70:	00143513          	seqz	a0,s0
80005a74:	157d                	addi	a0,a0,-1
80005a76:	8d71                	and	a0,a0,a2
80005a78:	40ac8533          	sub	a0,s9,a0
80005a7c:	008020ef          	jal	80007a84 <__SEGGER_RTL_pow10f>
80005a80:	07605763          	blez	s6,80005aee <__SEGGER_RTL_vfprintf+0xce4>
80005a84:	85aa                	mv	a1,a0
80005a86:	5512                	lw	a0,36(sp)
80005a88:	152010ef          	jal	80006bda <__mulsf3>
80005a8c:	32a010ef          	jal	80006db6 <__fixunssfdi>
80005a90:	842a                	mv	s0,a0
80005a92:	84ae                	mv	s1,a1
80005a94:	8ae6                	mv	s5,s9
80005a96:	1afd                	addi	s5,s5,-1
80005a98:	003a9513          	slli	a0,s5,0x3
80005a9c:	800035b7          	lui	a1,0x80003
80005aa0:	06858593          	addi	a1,a1,104 # 80003068 <__SEGGER_RTL_ipow10>
80005aa4:	95aa                	add	a1,a1,a0
80005aa6:	41c8                	lw	a0,4(a1)
80005aa8:	418c                	lw	a1,0(a1)
80005aaa:	02a48863          	beq	s1,a0,80005ada <__SEGGER_RTL_vfprintf+0xcd0>
80005aae:	00a4b633          	sltu	a2,s1,a0
80005ab2:	e61d                	bnez	a2,80005ae0 <__SEGGER_RTL_vfprintf+0xcd6>
80005ab4:	03000613          	li	a2,48
80005ab8:	00b436b3          	sltu	a3,s0,a1
80005abc:	8c89                	sub	s1,s1,a0
80005abe:	8c95                	sub	s1,s1,a3
80005ac0:	8c0d                	sub	s0,s0,a1
80005ac2:	00a48563          	beq	s1,a0,80005acc <__SEGGER_RTL_vfprintf+0xcc2>
80005ac6:	00a4b6b3          	sltu	a3,s1,a0
80005aca:	a019                	j	80005ad0 <__SEGGER_RTL_vfprintf+0xcc6>
80005acc:	00b436b3          	sltu	a3,s0,a1
80005ad0:	0605                	addi	a2,a2,1
80005ad2:	d2fd                	beqz	a3,80005ab8 <__SEGGER_RTL_vfprintf+0xcae>
80005ad4:	0ff67593          	zext.b	a1,a2
80005ad8:	a031                	j	80005ae4 <__SEGGER_RTL_vfprintf+0xcda>
80005ada:	00b43633          	sltu	a2,s0,a1
80005ade:	da79                	beqz	a2,80005ab4 <__SEGGER_RTL_vfprintf+0xcaa>
80005ae0:	03000593          	li	a1,48
80005ae4:	8552                	mv	a0,s4
80005ae6:	94aff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005aea:	fa0a96e3          	bnez	s5,80005a96 <__SEGGER_RTL_vfprintf+0xc8c>
80005aee:	419b0533          	sub	a0,s6,s9
80005af2:	54b2                	lw	s1,44(sp)
80005af4:	c911                	beqz	a0,80005b08 <__SEGGER_RTL_vfprintf+0xcfe>
80005af6:	416c8433          	sub	s0,s9,s6
80005afa:	03000593          	li	a1,48
80005afe:	8552                	mv	a0,s4
80005b00:	930ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005b04:	0405                	addi	s0,s0,1
80005b06:	f875                	bnez	s0,80005afa <__SEGGER_RTL_vfprintf+0xcf0>
80005b08:	400bf513          	andi	a0,s7,1024
80005b0c:	02500c93          	li	s9,37
80005b10:	c969                	beqz	a0,80005be2 <__SEGGER_RTL_vfprintf+0xdd8>
80005b12:	0bca                	slli	s7,s7,0x12
80005b14:	41fbd513          	srai	a0,s7,0x1f
80005b18:	9901                	andi	a0,a0,-32
80005b1a:	06550593          	addi	a1,a0,101
80005b1e:	8552                	mv	a0,s4
80005b20:	910ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005b24:	4576                	lw	a0,92(sp)
80005b26:	00054963          	bltz	a0,80005b38 <__SEGGER_RTL_vfprintf+0xd2e>
80005b2a:	02b00593          	li	a1,43
80005b2e:	8552                	mv	a0,s4
80005b30:	900ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005b34:	4576                	lw	a0,92(sp)
80005b36:	a811                	j	80005b4a <__SEGGER_RTL_vfprintf+0xd40>
80005b38:	02d00593          	li	a1,45
80005b3c:	8552                	mv	a0,s4
80005b3e:	8f2ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005b42:	4576                	lw	a0,92(sp)
80005b44:	40a00533          	neg	a0,a0
80005b48:	ceaa                	sw	a0,92(sp)
80005b4a:	06400493          	li	s1,100
80005b4e:	02954663          	blt	a0,s1,80005b7a <__SEGGER_RTL_vfprintf+0xd70>
80005b52:	4422                	lw	s0,8(sp)
80005b54:	02853533          	mulhu	a0,a0,s0
80005b58:	8115                	srli	a0,a0,0x5
80005b5a:	03050593          	addi	a1,a0,48
80005b5e:	8552                	mv	a0,s4
80005b60:	8d0ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005b64:	4576                	lw	a0,92(sp)
80005b66:	028515b3          	mulh	a1,a0,s0
80005b6a:	01f5d613          	srli	a2,a1,0x1f
80005b6e:	8595                	srai	a1,a1,0x5
80005b70:	95b2                	add	a1,a1,a2
80005b72:	029585b3          	mul	a1,a1,s1
80005b76:	8d0d                	sub	a0,a0,a1
80005b78:	ceaa                	sw	a0,92(sp)
80005b7a:	54b2                	lw	s1,44(sp)
80005b7c:	4462                	lw	s0,24(sp)
80005b7e:	02851533          	mulh	a0,a0,s0
80005b82:	01f55593          	srli	a1,a0,0x1f
80005b86:	8509                	srai	a0,a0,0x2
80005b88:	952e                	add	a0,a0,a1
80005b8a:	03050593          	addi	a1,a0,48
80005b8e:	8552                	mv	a0,s4
80005b90:	8a0ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005b94:	4576                	lw	a0,92(sp)
80005b96:	028515b3          	mulh	a1,a0,s0
80005b9a:	01f5d613          	srli	a2,a1,0x1f
80005b9e:	8589                	srai	a1,a1,0x2
80005ba0:	95b2                	add	a1,a1,a2
80005ba2:	033585b3          	mul	a1,a1,s3
80005ba6:	8d0d                	sub	a0,a0,a1
80005ba8:	03050593          	addi	a1,a0,48
80005bac:	a805                	j	80005bdc <__SEGGER_RTL_vfprintf+0xdd2>
80005bae:	5aa2                	lw	s5,40(sp)
80005bb0:	c591                	beqz	a1,80005bbc <__SEGGER_RTL_vfprintf+0xdb2>
80005bb2:	800085b7          	lui	a1,0x80008
80005bb6:	c5a58593          	addi	a1,a1,-934 # 80007c5a <.L.str.3>
80005bba:	a029                	j	80005bc4 <__SEGGER_RTL_vfprintf+0xdba>
80005bbc:	800085b7          	lui	a1,0x80008
80005bc0:	c5f58593          	addi	a1,a1,-929 # 80007c5f <.L.str.4>
80005bc4:	00158513          	addi	a0,a1,1
80005bc8:	020c7613          	andi	a2,s8,32
80005bcc:	c211                	beqz	a2,80005bd0 <__SEGGER_RTL_vfprintf+0xdc6>
80005bce:	852e                	mv	a0,a1
80005bd0:	effc7b93          	andi	s7,s8,-257
80005bd4:	837ff06f          	j	8000540a <__SEGGER_RTL_vfprintf+0x600>
80005bd8:	8b5e                	mv	s6,s7
80005bda:	b9c9                	j	800058ac <__SEGGER_RTL_vfprintf+0xaa2>
80005bdc:	8552                	mv	a0,s4
80005bde:	852ff0ef          	jal	80004c30 <__SEGGER_RTL_putc>
80005be2:	a80c0563          	beqz	s8,80004e6c <__SEGGER_RTL_vfprintf+0x62>
80005be6:	1c7d                	addi	s8,s8,-1
80005be8:	02000593          	li	a1,32
80005bec:	bfc5                	j	80005bdc <__SEGGER_RTL_vfprintf+0xdd2>
80005bee:	00ca2503          	lw	a0,12(s4)
80005bf2:	c911                	beqz	a0,80005c06 <__SEGGER_RTL_vfprintf+0xdfc>
80005bf4:	000a2583          	lw	a1,0(s4)
80005bf8:	004a2603          	lw	a2,4(s4)
80005bfc:	00c5f563          	bgeu	a1,a2,80005c06 <__SEGGER_RTL_vfprintf+0xdfc>
80005c00:	952e                	add	a0,a0,a1
80005c02:	00050023          	sb	zero,0(a0)
80005c06:	8552                	mv	a0,s4
80005c08:	8c8ff0ef          	jal	80004cd0 <__SEGGER_RTL_prin_flush>
80005c0c:	000a2503          	lw	a0,0(s4)
80005c10:	6125                	addi	sp,sp,96
80005c12:	6ad0006f          	j	80006abe <__riscv_restore_12>
80005c16:	8552                	mv	a0,s4
80005c18:	8b8ff0ef          	jal	80004cd0 <__SEGGER_RTL_prin_flush>
80005c1c:	557d                	li	a0,-1
80005c1e:	bfcd                	j	80005c10 <__SEGGER_RTL_vfprintf+0xe06>

Disassembly of section .segger.init.__SEGGER_init_heap:

80005c20 <__SEGGER_init_heap>:
80005c20:	00080537          	lui	a0,0x80
80005c24:	35850513          	addi	a0,a0,856 # 80358 <__heap_start__>

80005c28 <.Lpcrel_hi1>:
80005c28:	000845b7          	lui	a1,0x84
80005c2c:	35858593          	addi	a1,a1,856 # 84358 <__heap_end__>
80005c30:	8d89                	sub	a1,a1,a0
80005c32:	a009                	j	80005c34 <__SEGGER_RTL_init_heap>

Disassembly of section .text.libc.__SEGGER_RTL_init_heap:

80005c34 <__SEGGER_RTL_init_heap>:
80005c34:	4621                	li	a2,8
80005c36:	00c5e963          	bltu	a1,a2,80005c48 <__SEGGER_RTL_init_heap+0x14>
80005c3a:	00080637          	lui	a2,0x80
80005c3e:	34a62423          	sw	a0,840(a2) # 80348 <__SEGGER_RTL_heap_globals.0>
80005c42:	00052023          	sw	zero,0(a0)
80005c46:	c14c                	sw	a1,4(a0)
80005c48:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_toupper:

80005c4a <__SEGGER_RTL_ascii_toupper>:
80005c4a:	f9f50593          	addi	a1,a0,-97
80005c4e:	01a5b593          	sltiu	a1,a1,26
80005c52:	40b005b3          	neg	a1,a1
80005c56:	9981                	andi	a1,a1,-32
80005c58:	952e                	add	a0,a0,a1
80005c5a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_tolower:

80005c5c <__SEGGER_RTL_ascii_tolower>:
80005c5c:	fbf50593          	addi	a1,a0,-65
80005c60:	01a5b593          	sltiu	a1,a1,26
80005c64:	0596                	slli	a1,a1,0x5
80005c66:	8d4d                	or	a0,a0,a1
80005c68:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towupper:

80005c6a <__SEGGER_RTL_ascii_towupper>:
80005c6a:	f9f50593          	addi	a1,a0,-97
80005c6e:	01a5b593          	sltiu	a1,a1,26
80005c72:	40b005b3          	neg	a1,a1
80005c76:	9981                	andi	a1,a1,-32
80005c78:	952e                	add	a0,a0,a1
80005c7a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towlower:

80005c7c <__SEGGER_RTL_ascii_towlower>:
80005c7c:	fbf50593          	addi	a1,a0,-65
80005c80:	01a5b593          	sltiu	a1,a1,26
80005c84:	0596                	slli	a1,a1,0x5
80005c86:	8d4d                	or	a0,a0,a1
80005c88:	8082                	ret

Disassembly of section .text.reset_handler:

80005c8a <reset_handler>:
        ;
    }
}

__attribute__((weak)) void reset_handler(void)
{
80005c8a:	1141                	addi	sp,sp,-16
80005c8c:	c606                	sw	ra,12(sp)
    fencei();
80005c8e:	0000100f          	fence.i

    /* Call platform specific hardware initialization */
    system_init();
80005c92:	cd1fd0ef          	jal	80003962 <system_init>

    /* Entry function */
    MAIN_ENTRY();
80005c96:	b6ffd0ef          	jal	80003804 <main>
}
80005c9a:	0001                	nop
80005c9c:	40b2                	lw	ra,12(sp)
80005c9e:	0141                	addi	sp,sp,16
80005ca0:	8082                	ret

Disassembly of section .text._init:

80005ca2 <_init>:
__attribute__((weak)) void *__dso_handle = (void *) &__dso_handle;
#endif

__attribute__((weak)) void _init(void)
{
}
80005ca2:	0001                	nop
80005ca4:	8082                	ret

Disassembly of section .text.mchtmr_isr:

80005ca6 <mchtmr_isr>:
}
80005ca6:	0001                	nop
80005ca8:	8082                	ret

Disassembly of section .text.swi_isr:

80005caa <swi_isr>:
}
80005caa:	0001                	nop
80005cac:	8082                	ret

Disassembly of section .text.exception_handler:

80005cae <exception_handler>:

__attribute__((weak)) long exception_handler(long cause, long epc)
{
80005cae:	1141                	addi	sp,sp,-16
80005cb0:	c62a                	sw	a0,12(sp)
80005cb2:	c42e                	sw	a1,8(sp)
    switch (cause) {
80005cb4:	4732                	lw	a4,12(sp)
80005cb6:	47bd                	li	a5,15
80005cb8:	00e7ea63          	bltu	a5,a4,80005ccc <.L23>
80005cbc:	47b2                	lw	a5,12(sp)
80005cbe:	00279713          	slli	a4,a5,0x2
80005cc2:	87818793          	addi	a5,gp,-1928 # 80003108 <.L7>
80005cc6:	97ba                	add	a5,a5,a4
80005cc8:	439c                	lw	a5,0(a5)
80005cca:	8782                	jr	a5

80005ccc <.L23>:
    case MCAUSE_LOAD_PAGE_FAULT:
        break;
    case MCAUSE_STORE_AMO_PAGE_FAULT:
        break;
    default:
        break;
80005ccc:	0001                	nop
    }
    /* Unhandled Trap */
    return epc;
80005cce:	47a2                	lw	a5,8(sp)
}
80005cd0:	853e                	mv	a0,a5
80005cd2:	0141                	addi	sp,sp,16
80005cd4:	8082                	ret

Disassembly of section .text.enable_plic_feature:

80005cd6 <enable_plic_feature>:
{
80005cd6:	1141                	addi	sp,sp,-16
    uint32_t plic_feature = 0;
80005cd8:	c602                	sw	zero,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_VECTORED_MODE;
80005cda:	47b2                	lw	a5,12(sp)
80005cdc:	0027e793          	ori	a5,a5,2
80005ce0:	c63e                	sw	a5,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_PREEMPTIVE_PRIORITY_IRQ;
80005ce2:	47b2                	lw	a5,12(sp)
80005ce4:	0017e793          	ori	a5,a5,1
80005ce8:	c63e                	sw	a5,12(sp)
80005cea:	e40007b7          	lui	a5,0xe4000
80005cee:	c43e                	sw	a5,8(sp)
80005cf0:	47b2                	lw	a5,12(sp)
80005cf2:	c23e                	sw	a5,4(sp)

80005cf4 <.LBB14>:
    *(volatile uint32_t *) (base + HPM_PLIC_FEATURE_OFFSET) = feature;
80005cf4:	47a2                	lw	a5,8(sp)
80005cf6:	4712                	lw	a4,4(sp)
80005cf8:	c398                	sw	a4,0(a5)
}
80005cfa:	0001                	nop

80005cfc <.LBE14>:
}
80005cfc:	0001                	nop
80005cfe:	0141                	addi	sp,sp,16
80005d00:	8082                	ret

Disassembly of section .text.sysctl_enable_group_resource:

80005d02 <sysctl_enable_group_resource>:
{
80005d02:	7179                	addi	sp,sp,-48
80005d04:	d606                	sw	ra,44(sp)
80005d06:	c62a                	sw	a0,12(sp)
80005d08:	87ae                	mv	a5,a1
80005d0a:	8736                	mv	a4,a3
80005d0c:	00f105a3          	sb	a5,11(sp)
80005d10:	87b2                	mv	a5,a2
80005d12:	00f11423          	sh	a5,8(sp)
80005d16:	87ba                	mv	a5,a4
80005d18:	00f10523          	sb	a5,10(sp)
    if (resource < sysctl_resource_linkable_start) {
80005d1c:	00815703          	lhu	a4,8(sp)
80005d20:	0ff00793          	li	a5,255
80005d24:	00e7e463          	bltu	a5,a4,80005d2c <.L55>
        return status_invalid_argument;
80005d28:	4789                	li	a5,2
80005d2a:	a851                	j	80005dbe <.L56>

80005d2c <.L55>:
    index = (resource - sysctl_resource_linkable_start) / 32;
80005d2c:	00815783          	lhu	a5,8(sp)
80005d30:	f0078793          	addi	a5,a5,-256 # e3ffff00 <__FLASH_segment_end__+0x63efff00>
80005d34:	41f7d713          	srai	a4,a5,0x1f
80005d38:	8b7d                	andi	a4,a4,31
80005d3a:	97ba                	add	a5,a5,a4
80005d3c:	8795                	srai	a5,a5,0x5
80005d3e:	ce3e                	sw	a5,28(sp)
    offset = (resource - sysctl_resource_linkable_start) % 32;
80005d40:	00815783          	lhu	a5,8(sp)
80005d44:	f0078713          	addi	a4,a5,-256
80005d48:	41f75793          	srai	a5,a4,0x1f
80005d4c:	83ed                	srli	a5,a5,0x1b
80005d4e:	973e                	add	a4,a4,a5
80005d50:	8b7d                	andi	a4,a4,31
80005d52:	40f707b3          	sub	a5,a4,a5
80005d56:	cc3e                	sw	a5,24(sp)
    switch (group) {
80005d58:	00b14783          	lbu	a5,11(sp)
80005d5c:	efa9                	bnez	a5,80005db6 <.L57>
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset)) | (enable ? (1UL << offset) : 0);
80005d5e:	4732                	lw	a4,12(sp)
80005d60:	47f2                	lw	a5,28(sp)
80005d62:	08078793          	addi	a5,a5,128
80005d66:	0792                	slli	a5,a5,0x4
80005d68:	97ba                	add	a5,a5,a4
80005d6a:	4398                	lw	a4,0(a5)
80005d6c:	47e2                	lw	a5,24(sp)
80005d6e:	4685                	li	a3,1
80005d70:	00f697b3          	sll	a5,a3,a5
80005d74:	fff7c793          	not	a5,a5
80005d78:	8f7d                	and	a4,a4,a5
80005d7a:	00a14783          	lbu	a5,10(sp)
80005d7e:	c791                	beqz	a5,80005d8a <.L58>
80005d80:	47e2                	lw	a5,24(sp)
80005d82:	4685                	li	a3,1
80005d84:	00f697b3          	sll	a5,a3,a5
80005d88:	a011                	j	80005d8c <.L59>

80005d8a <.L58>:
80005d8a:	4781                	li	a5,0

80005d8c <.L59>:
80005d8c:	8f5d                	or	a4,a4,a5
80005d8e:	46b2                	lw	a3,12(sp)
80005d90:	47f2                	lw	a5,28(sp)
80005d92:	08078793          	addi	a5,a5,128
80005d96:	0792                	slli	a5,a5,0x4
80005d98:	97b6                	add	a5,a5,a3
80005d9a:	c398                	sw	a4,0(a5)
        if (enable) {
80005d9c:	00a14783          	lbu	a5,10(sp)
80005da0:	cf89                	beqz	a5,80005dba <.L63>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
80005da2:	0001                	nop

80005da4 <.L61>:
80005da4:	00815783          	lhu	a5,8(sp)
80005da8:	85be                	mv	a1,a5
80005daa:	4532                	lw	a0,12(sp)
80005dac:	c0dfd0ef          	jal	800039b8 <sysctl_resource_target_is_busy>
80005db0:	87aa                	mv	a5,a0
80005db2:	fbed                	bnez	a5,80005da4 <.L61>
        break;
80005db4:	a019                	j	80005dba <.L63>

80005db6 <.L57>:
        return status_invalid_argument;
80005db6:	4789                	li	a5,2
80005db8:	a019                	j	80005dbe <.L56>

80005dba <.L63>:
        break;
80005dba:	0001                	nop
    return status_success;
80005dbc:	4781                	li	a5,0

80005dbe <.L56>:
}
80005dbe:	853e                	mv	a0,a5
80005dc0:	50b2                	lw	ra,44(sp)
80005dc2:	6145                	addi	sp,sp,48
80005dc4:	8082                	ret

Disassembly of section .text.sysctl_check_group_resource_enable:

80005dc6 <sysctl_check_group_resource_enable>:
{
80005dc6:	1101                	addi	sp,sp,-32
80005dc8:	c62a                	sw	a0,12(sp)
80005dca:	87ae                	mv	a5,a1
80005dcc:	8732                	mv	a4,a2
80005dce:	00f105a3          	sb	a5,11(sp)
80005dd2:	87ba                	mv	a5,a4
80005dd4:	00f11423          	sh	a5,8(sp)
    index = (resource - sysctl_resource_linkable_start) / 32;
80005dd8:	00815783          	lhu	a5,8(sp)
80005ddc:	f0078793          	addi	a5,a5,-256
80005de0:	41f7d713          	srai	a4,a5,0x1f
80005de4:	8b7d                	andi	a4,a4,31
80005de6:	97ba                	add	a5,a5,a4
80005de8:	8795                	srai	a5,a5,0x5
80005dea:	cc3e                	sw	a5,24(sp)
    offset = (resource - sysctl_resource_linkable_start) % 32;
80005dec:	00815783          	lhu	a5,8(sp)
80005df0:	f0078713          	addi	a4,a5,-256
80005df4:	41f75793          	srai	a5,a4,0x1f
80005df8:	83ed                	srli	a5,a5,0x1b
80005dfa:	973e                	add	a4,a4,a5
80005dfc:	8b7d                	andi	a4,a4,31
80005dfe:	40f707b3          	sub	a5,a4,a5
80005e02:	ca3e                	sw	a5,20(sp)
    switch (group) {
80005e04:	00b14783          	lbu	a5,11(sp)
80005e08:	e38d                	bnez	a5,80005e2a <.L65>
        enable = ((ptr->GROUP0[index].VALUE & (1UL << offset)) != 0) ? true : false;
80005e0a:	4732                	lw	a4,12(sp)
80005e0c:	47e2                	lw	a5,24(sp)
80005e0e:	08078793          	addi	a5,a5,128
80005e12:	0792                	slli	a5,a5,0x4
80005e14:	97ba                	add	a5,a5,a4
80005e16:	4398                	lw	a4,0(a5)
80005e18:	47d2                	lw	a5,20(sp)
80005e1a:	00f757b3          	srl	a5,a4,a5
80005e1e:	8b85                	andi	a5,a5,1
80005e20:	00f037b3          	snez	a5,a5
80005e24:	00f10fa3          	sb	a5,31(sp)
        break;
80005e28:	a021                	j	80005e30 <.L66>

80005e2a <.L65>:
        enable =  false;
80005e2a:	00010fa3          	sb	zero,31(sp)
        break;
80005e2e:	0001                	nop

80005e30 <.L66>:
    return enable;
80005e30:	01f14783          	lbu	a5,31(sp)
}
80005e34:	853e                	mv	a0,a5
80005e36:	6105                	addi	sp,sp,32
80005e38:	8082                	ret

Disassembly of section .text.sysctl_config_cpu0_domain_clock:

80005e3a <sysctl_config_cpu0_domain_clock>:

hpm_stat_t sysctl_config_cpu0_domain_clock(SYSCTL_Type *ptr,
                                           clock_source_t source,
                                           uint32_t cpu_div,
                                           uint32_t ahb_sub_div)
{
80005e3a:	7179                	addi	sp,sp,-48
80005e3c:	d606                	sw	ra,44(sp)
80005e3e:	c62a                	sw	a0,12(sp)
80005e40:	87ae                	mv	a5,a1
80005e42:	c232                	sw	a2,4(sp)
80005e44:	c036                	sw	a3,0(sp)
80005e46:	00f105a3          	sb	a5,11(sp)
    if (source >= clock_source_general_source_end) {
80005e4a:	00b14703          	lbu	a4,11(sp)
80005e4e:	479d                	li	a5,7
80005e50:	00e7f463          	bgeu	a5,a4,80005e58 <.L86>
        return status_invalid_argument;
80005e54:	4789                	li	a5,2
80005e56:	a849                	j	80005ee8 <.L87>

80005e58 <.L86>:
    }

    uint32_t origin_cpu_div = SYSCTL_CLOCK_CPU_DIV_GET(ptr->CLOCK_CPU[0]) + 1U;
80005e58:	4732                	lw	a4,12(sp)
80005e5a:	6789                	lui	a5,0x2
80005e5c:	97ba                	add	a5,a5,a4
80005e5e:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
80005e62:	0ff7f793          	zext.b	a5,a5
80005e66:	0785                	addi	a5,a5,1
80005e68:	ce3e                	sw	a5,28(sp)
    if (origin_cpu_div == cpu_div) {
80005e6a:	4772                	lw	a4,28(sp)
80005e6c:	4792                	lw	a5,4(sp)
80005e6e:	02f71e63          	bne	a4,a5,80005eaa <.L88>
        ptr->CLOCK_CPU[0] = SYSCTL_CLOCK_CPU_MUX_SET(source) | SYSCTL_CLOCK_CPU_DIV_SET(cpu_div) | SYSCTL_CLOCK_CPU_SUB0_DIV_SET(ahb_sub_div - 1);
80005e72:	00b14783          	lbu	a5,11(sp)
80005e76:	07a2                	slli	a5,a5,0x8
80005e78:	7007f713          	andi	a4,a5,1792
80005e7c:	4792                	lw	a5,4(sp)
80005e7e:	0ff7f793          	zext.b	a5,a5
80005e82:	8f5d                	or	a4,a4,a5
80005e84:	4782                	lw	a5,0(sp)
80005e86:	17fd                	addi	a5,a5,-1
80005e88:	01079693          	slli	a3,a5,0x10
80005e8c:	000f07b7          	lui	a5,0xf0
80005e90:	8ff5                	and	a5,a5,a3
80005e92:	8f5d                	or	a4,a4,a5
80005e94:	46b2                	lw	a3,12(sp)
80005e96:	6789                	lui	a5,0x2
80005e98:	97b6                	add	a5,a5,a3
80005e9a:	80e7a023          	sw	a4,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
        while (sysctl_cpu_clock_any_is_busy(ptr)) {
80005e9e:	0001                	nop

80005ea0 <.L89>:
80005ea0:	4532                	lw	a0,12(sp)
80005ea2:	b41fd0ef          	jal	800039e2 <sysctl_cpu_clock_any_is_busy>
80005ea6:	87aa                	mv	a5,a0
80005ea8:	ffe5                	bnez	a5,80005ea0 <.L89>

80005eaa <.L88>:
        }
    }
    ptr->CLOCK_CPU[0] = SYSCTL_CLOCK_CPU_MUX_SET(source) | SYSCTL_CLOCK_CPU_DIV_SET(cpu_div - 1) | SYSCTL_CLOCK_CPU_SUB0_DIV_SET(ahb_sub_div - 1);
80005eaa:	00b14783          	lbu	a5,11(sp)
80005eae:	07a2                	slli	a5,a5,0x8
80005eb0:	7007f713          	andi	a4,a5,1792
80005eb4:	4792                	lw	a5,4(sp)
80005eb6:	17fd                	addi	a5,a5,-1
80005eb8:	0ff7f793          	zext.b	a5,a5
80005ebc:	8f5d                	or	a4,a4,a5
80005ebe:	4782                	lw	a5,0(sp)
80005ec0:	17fd                	addi	a5,a5,-1
80005ec2:	01079693          	slli	a3,a5,0x10
80005ec6:	000f07b7          	lui	a5,0xf0
80005eca:	8ff5                	and	a5,a5,a3
80005ecc:	8f5d                	or	a4,a4,a5
80005ece:	46b2                	lw	a3,12(sp)
80005ed0:	6789                	lui	a5,0x2
80005ed2:	97b6                	add	a5,a5,a3
80005ed4:	80e7a023          	sw	a4,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>

    while (sysctl_cpu_clock_any_is_busy(ptr)) {
80005ed8:	0001                	nop

80005eda <.L90>:
80005eda:	4532                	lw	a0,12(sp)
80005edc:	b07fd0ef          	jal	800039e2 <sysctl_cpu_clock_any_is_busy>
80005ee0:	87aa                	mv	a5,a0
80005ee2:	ffe5                	bnez	a5,80005eda <.L90>
    }

    clock_update_core_clock();
80005ee4:	24c5                	jal	800061c4 <clock_update_core_clock>

    return status_success;
80005ee6:	4781                	li	a5,0

80005ee8 <.L87>:
}
80005ee8:	853e                	mv	a0,a5
80005eea:	50b2                	lw	ra,44(sp)
80005eec:	6145                	addi	sp,sp,48
80005eee:	8082                	ret

Disassembly of section .text.clock_get_frequency:

80005ef0 <clock_get_frequency>:
{
80005ef0:	7179                	addi	sp,sp,-48
80005ef2:	d606                	sw	ra,44(sp)
80005ef4:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
80005ef6:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
80005ef8:	47b2                	lw	a5,12(sp)
80005efa:	83a1                	srli	a5,a5,0x8
80005efc:	0ff7f793          	zext.b	a5,a5
80005f00:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
80005f02:	47b2                	lw	a5,12(sp)
80005f04:	0ff7f793          	zext.b	a5,a5
80005f08:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
80005f0a:	4762                	lw	a4,24(sp)
80005f0c:	47ad                	li	a5,11
80005f0e:	06e7e963          	bltu	a5,a4,80005f80 <.L16>
80005f12:	47e2                	lw	a5,24(sp)
80005f14:	00279713          	slli	a4,a5,0x2
80005f18:	8c018793          	addi	a5,gp,-1856 # 80003150 <.L18>
80005f1c:	97ba                	add	a5,a5,a4
80005f1e:	439c                	lw	a5,0(a5)
80005f20:	8782                	jr	a5

80005f22 <.L26>:
        clk_freq = get_frequency_for_ip_in_common_group((clock_node_t) node_or_instance);
80005f22:	47d2                	lw	a5,20(sp)
80005f24:	0ff7f793          	zext.b	a5,a5
80005f28:	853e                	mv	a0,a5
80005f2a:	c3ffd0ef          	jal	80003b68 <get_frequency_for_ip_in_common_group>
80005f2e:	ce2a                	sw	a0,28(sp)
        break;
80005f30:	a891                	j	80005f84 <.L27>

80005f32 <.L25>:
        clk_freq = get_frequency_for_adc(CLK_SRC_GROUP_ADC, node_or_instance);
80005f32:	45d2                	lw	a1,20(sp)
80005f34:	4505                	li	a0,1
80005f36:	c9ffd0ef          	jal	80003bd4 <get_frequency_for_adc>
80005f3a:	ce2a                	sw	a0,28(sp)
        break;
80005f3c:	a0a1                	j	80005f84 <.L27>

80005f3e <.L21>:
        clk_freq = get_frequency_for_dac(node_or_instance);
80005f3e:	4552                	lw	a0,20(sp)
80005f40:	20b9                	jal	80005f8e <.LFE116>
80005f42:	ce2a                	sw	a0,28(sp)
        break;
80005f44:	a081                	j	80005f84 <.L27>

80005f46 <.L24>:
        clk_freq = get_frequency_for_ewdg(node_or_instance);
80005f46:	4552                	lw	a0,20(sp)
80005f48:	d25fd0ef          	jal	80003c6c <get_frequency_for_ewdg>
80005f4c:	ce2a                	sw	a0,28(sp)
        break;
80005f4e:	a81d                	j	80005f84 <.L27>

80005f50 <.L17>:
        clk_freq = get_frequency_for_pewdg();
80005f50:	20f1                	jal	8000601c <get_frequency_for_pewdg>
80005f52:	ce2a                	sw	a0,28(sp)
        break;
80005f54:	a805                	j	80005f84 <.L27>

80005f56 <.L23>:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
80005f56:	016e37b7          	lui	a5,0x16e3
80005f5a:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80005f5e:	ce3e                	sw	a5,28(sp)
        break;
80005f60:	a015                	j	80005f84 <.L27>

80005f62 <.L20>:
        clk_freq = get_frequency_for_cpu();
80005f62:	d3dfd0ef          	jal	80003c9e <get_frequency_for_cpu>
80005f66:	ce2a                	sw	a0,28(sp)
        break;
80005f68:	a831                	j	80005f84 <.L27>

80005f6a <.L22>:
        clk_freq = get_frequency_for_ahb();
80005f6a:	28e9                	jal	80006044 <get_frequency_for_ahb>
80005f6c:	ce2a                	sw	a0,28(sp)
        break;
80005f6e:	a819                	j	80005f84 <.L27>

80005f70 <.L19>:
        clk_freq = get_frequency_for_source((clock_source_t) node_or_instance);
80005f70:	47d2                	lw	a5,20(sp)
80005f72:	0ff7f793          	zext.b	a5,a5
80005f76:	853e                	mv	a0,a5
80005f78:	b43fd0ef          	jal	80003aba <get_frequency_for_source>
80005f7c:	ce2a                	sw	a0,28(sp)
        break;
80005f7e:	a019                	j	80005f84 <.L27>

80005f80 <.L16>:
        clk_freq = 0UL;
80005f80:	ce02                	sw	zero,28(sp)
        break;
80005f82:	0001                	nop

80005f84 <.L27>:
    return clk_freq;
80005f84:	47f2                	lw	a5,28(sp)
}
80005f86:	853e                	mv	a0,a5
80005f88:	50b2                	lw	ra,44(sp)
80005f8a:	6145                	addi	sp,sp,48
80005f8c:	8082                	ret

Disassembly of section .text.get_frequency_for_dac:

80005f8e <get_frequency_for_dac>:
{
80005f8e:	7179                	addi	sp,sp,-48
80005f90:	d606                	sw	ra,44(sp)
80005f92:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
80005f94:	ce02                	sw	zero,28(sp)
    bool is_mux_valid = false;
80005f96:	00010da3          	sb	zero,27(sp)
    clock_node_t node = clock_node_end;
80005f9a:	02800793          	li	a5,40
80005f9e:	00f10d23          	sb	a5,26(sp)
    if (instance < DAC_INSTANCE_NUM) {
80005fa2:	4732                	lw	a4,12(sp)
80005fa4:	4785                	li	a5,1
80005fa6:	02e7ec63          	bltu	a5,a4,80005fde <.L51>

80005faa <.LBB8>:
        uint32_t mux_in_reg = SYSCTL_DACCLK_MUX_GET(HPM_SYSCTL->DACCLK[instance]);
80005faa:	f4000737          	lui	a4,0xf4000
80005fae:	47b2                	lw	a5,12(sp)
80005fb0:	70078793          	addi	a5,a5,1792
80005fb4:	078a                	slli	a5,a5,0x2
80005fb6:	97ba                	add	a5,a5,a4
80005fb8:	479c                	lw	a5,8(a5)
80005fba:	83a1                	srli	a5,a5,0x8
80005fbc:	8b85                	andi	a5,a5,1
80005fbe:	ca3e                	sw	a5,20(sp)
        if (mux_in_reg < ARRAY_SIZE(s_dac_clk_mux_node)) {
80005fc0:	4752                	lw	a4,20(sp)
80005fc2:	4785                	li	a5,1
80005fc4:	00e7ed63          	bltu	a5,a4,80005fde <.L51>
            node = s_dac_clk_mux_node[mux_in_reg];
80005fc8:	f8018713          	addi	a4,gp,-128 # 80003810 <s_dac_clk_mux_node>
80005fcc:	47d2                	lw	a5,20(sp)
80005fce:	97ba                	add	a5,a5,a4
80005fd0:	0007c783          	lbu	a5,0(a5)
80005fd4:	00f10d23          	sb	a5,26(sp)
            is_mux_valid = true;
80005fd8:	4785                	li	a5,1
80005fda:	00f10da3          	sb	a5,27(sp)

80005fde <.L51>:
    if (is_mux_valid) {
80005fde:	01b14783          	lbu	a5,27(sp)
80005fe2:	cb85                	beqz	a5,80006012 <.L52>
        if (node == clock_node_ahb) {
80005fe4:	01a14703          	lbu	a4,26(sp)
80005fe8:	0fe00793          	li	a5,254
80005fec:	00f71563          	bne	a4,a5,80005ff6 <.L53>
            clk_freq = get_frequency_for_ahb();
80005ff0:	2891                	jal	80006044 <get_frequency_for_ahb>
80005ff2:	ce2a                	sw	a0,28(sp)
80005ff4:	a839                	j	80006012 <.L52>

80005ff6 <.L53>:
            node += instance;
80005ff6:	47b2                	lw	a5,12(sp)
80005ff8:	0ff7f793          	zext.b	a5,a5
80005ffc:	01a14703          	lbu	a4,26(sp)
80006000:	97ba                	add	a5,a5,a4
80006002:	00f10d23          	sb	a5,26(sp)
            clk_freq = get_frequency_for_ip_in_common_group(node);
80006006:	01a14783          	lbu	a5,26(sp)
8000600a:	853e                	mv	a0,a5
8000600c:	b5dfd0ef          	jal	80003b68 <get_frequency_for_ip_in_common_group>
80006010:	ce2a                	sw	a0,28(sp)

80006012 <.L52>:
    return clk_freq;
80006012:	47f2                	lw	a5,28(sp)
}
80006014:	853e                	mv	a0,a5
80006016:	50b2                	lw	ra,44(sp)
80006018:	6145                	addi	sp,sp,48
8000601a:	8082                	ret

Disassembly of section .text.get_frequency_for_pewdg:

8000601c <get_frequency_for_pewdg>:
{
8000601c:	1141                	addi	sp,sp,-16
    if (EWDG_CTRL0_CLK_SEL_GET(HPM_PEWDG->CTRL0) == 0) {
8000601e:	f41287b7          	lui	a5,0xf4128
80006022:	4398                	lw	a4,0(a5)
80006024:	200007b7          	lui	a5,0x20000
80006028:	8ff9                	and	a5,a5,a4
8000602a:	e799                	bnez	a5,80006038 <.L60>
        freq_in_hz = FREQ_PRESET1_OSC0_CLK0;
8000602c:	016e37b7          	lui	a5,0x16e3
80006030:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80006034:	c63e                	sw	a5,12(sp)
80006036:	a019                	j	8000603c <.L61>

80006038 <.L60>:
        freq_in_hz = FREQ_32KHz;
80006038:	67a1                	lui	a5,0x8
8000603a:	c63e                	sw	a5,12(sp)

8000603c <.L61>:
    return freq_in_hz;
8000603c:	47b2                	lw	a5,12(sp)
}
8000603e:	853e                	mv	a0,a5
80006040:	0141                	addi	sp,sp,16
80006042:	8082                	ret

Disassembly of section .text.get_frequency_for_ahb:

80006044 <get_frequency_for_ahb>:
{
80006044:	1101                	addi	sp,sp,-32
80006046:	ce06                	sw	ra,28(sp)
    uint32_t div = SYSCTL_CLOCK_CPU_SUB0_DIV_GET(HPM_SYSCTL->CLOCK_CPU[0]) + 1U;
80006048:	f4000737          	lui	a4,0xf4000
8000604c:	6789                	lui	a5,0x2
8000604e:	97ba                	add	a5,a5,a4
80006050:	8007a783          	lw	a5,-2048(a5) # 1800 <__NOR_CFG_OPTION_segment_size__+0xc00>
80006054:	83c1                	srli	a5,a5,0x10
80006056:	8bbd                	andi	a5,a5,15
80006058:	0785                	addi	a5,a5,1
8000605a:	c63e                	sw	a5,12(sp)
    return (get_frequency_for_cpu() / div);
8000605c:	c43fd0ef          	jal	80003c9e <get_frequency_for_cpu>
80006060:	872a                	mv	a4,a0
80006062:	47b2                	lw	a5,12(sp)
80006064:	02f757b3          	divu	a5,a4,a5
}
80006068:	853e                	mv	a0,a5
8000606a:	40f2                	lw	ra,28(sp)
8000606c:	6105                	addi	sp,sp,32
8000606e:	8082                	ret

Disassembly of section .text.clock_set_source_divider:

80006070 <clock_set_source_divider>:
{
80006070:	7139                	addi	sp,sp,-64
80006072:	de06                	sw	ra,60(sp)
80006074:	c62a                	sw	a0,12(sp)
80006076:	87ae                	mv	a5,a1
80006078:	c232                	sw	a2,4(sp)
8000607a:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status = status_success;
8000607e:	d602                	sw	zero,44(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
80006080:	47b2                	lw	a5,12(sp)
80006082:	83a1                	srli	a5,a5,0x8
80006084:	0ff7f793          	zext.b	a5,a5
80006088:	d43e                	sw	a5,40(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
8000608a:	47b2                	lw	a5,12(sp)
8000608c:	0ff7f793          	zext.b	a5,a5
80006090:	d23e                	sw	a5,36(sp)
    switch (clk_src_type) {
80006092:	5722                	lw	a4,40(sp)
80006094:	47ad                	li	a5,11
80006096:	0ce7e263          	bltu	a5,a4,8000615a <.L132>
8000609a:	57a2                	lw	a5,40(sp)
8000609c:	00279713          	slli	a4,a5,0x2
800060a0:	91018793          	addi	a5,gp,-1776 # 800031a0 <.L134>
800060a4:	97ba                	add	a5,a5,a4
800060a6:	439c                	lw	a5,0(a5)
800060a8:	8782                	jr	a5

800060aa <.L138>:
        if ((div < 1U) || (div > 256U)) {
800060aa:	4792                	lw	a5,4(sp)
800060ac:	c791                	beqz	a5,800060b8 <.L139>
800060ae:	4712                	lw	a4,4(sp)
800060b0:	10000793          	li	a5,256
800060b4:	00e7f763          	bgeu	a5,a4,800060c2 <.L140>

800060b8 <.L139>:
            status = status_clk_div_invalid;
800060b8:	6795                	lui	a5,0x5
800060ba:	5f078793          	addi	a5,a5,1520 # 55f0 <__FLASH_segment_used_size__+0x480>
800060be:	d63e                	sw	a5,44(sp)
        break;
800060c0:	a055                	j	80006164 <.L142>

800060c2 <.L140>:
            clock_source_t clk_src = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
800060c2:	00b14783          	lbu	a5,11(sp)
800060c6:	8bbd                	andi	a5,a5,15
800060c8:	00f10da3          	sb	a5,27(sp)
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, clk_src, div);
800060cc:	5792                	lw	a5,36(sp)
800060ce:	0ff7f793          	zext.b	a5,a5
800060d2:	01b14703          	lbu	a4,27(sp)
800060d6:	4692                	lw	a3,4(sp)
800060d8:	863a                	mv	a2,a4
800060da:	85be                	mv	a1,a5
800060dc:	f4000537          	lui	a0,0xf4000
800060e0:	953fd0ef          	jal	80003a32 <sysctl_config_clock>

800060e4 <.LBE13>:
        break;
800060e4:	a041                	j	80006164 <.L142>

800060e6 <.L133>:
        status = status_clk_operation_unsupported;
800060e6:	6795                	lui	a5,0x5
800060e8:	5f378793          	addi	a5,a5,1523 # 55f3 <__FLASH_segment_used_size__+0x483>
800060ec:	d63e                	sw	a5,44(sp)
        break;
800060ee:	a89d                	j	80006164 <.L142>

800060f0 <.L137>:
        status = status_clk_fixed;
800060f0:	6795                	lui	a5,0x5
800060f2:	5fa78793          	addi	a5,a5,1530 # 55fa <__FLASH_segment_used_size__+0x48a>
800060f6:	d63e                	sw	a5,44(sp)
        break;
800060f8:	a0b5                	j	80006164 <.L142>

800060fa <.L136>:
        status = status_clk_shared_cpu0;
800060fa:	6795                	lui	a5,0x5
800060fc:	5f878793          	addi	a5,a5,1528 # 55f8 <__FLASH_segment_used_size__+0x488>
80006100:	d63e                	sw	a5,44(sp)
        break;
80006102:	a08d                	j	80006164 <.L142>

80006104 <.L135>:
        if (node_or_instance == clock_node_cpu0) {
80006104:	5712                	lw	a4,36(sp)
80006106:	0fc00793          	li	a5,252
8000610a:	04f71363          	bne	a4,a5,80006150 <.L143>

8000610e <.LBB14>:
            uint32_t expected_freq = get_frequency_for_source((clock_source_t) src) / div;
8000610e:	00b14783          	lbu	a5,11(sp)
80006112:	853e                	mv	a0,a5
80006114:	9a7fd0ef          	jal	80003aba <get_frequency_for_source>
80006118:	872a                	mv	a4,a0
8000611a:	4792                	lw	a5,4(sp)
8000611c:	02f757b3          	divu	a5,a4,a5
80006120:	d03e                	sw	a5,32(sp)
            uint32_t ahb_sub_div = (expected_freq + BUS_FREQ_MAX - 1U) / BUS_FREQ_MAX;
80006122:	5702                	lw	a4,32(sp)
80006124:	0bebc7b7          	lui	a5,0xbebc
80006128:	1ff78793          	addi	a5,a5,511 # bebc1ff <_flash_size+0xbdbc1ff>
8000612c:	973e                	add	a4,a4,a5
8000612e:	55e647b7          	lui	a5,0x55e64
80006132:	b8978793          	addi	a5,a5,-1143 # 55e63b89 <_flash_size+0x55d63b89>
80006136:	02f737b3          	mulhu	a5,a4,a5
8000613a:	83e9                	srli	a5,a5,0x1a
8000613c:	ce3e                	sw	a5,28(sp)
            sysctl_config_cpu0_domain_clock(HPM_SYSCTL, (clock_source_t) src, div, ahb_sub_div);
8000613e:	00b14783          	lbu	a5,11(sp)
80006142:	46f2                	lw	a3,28(sp)
80006144:	4612                	lw	a2,4(sp)
80006146:	85be                	mv	a1,a5
80006148:	f4000537          	lui	a0,0xf4000
8000614c:	31fd                	jal	80005e3a <sysctl_config_cpu0_domain_clock>

8000614e <.LBE14>:
        break;
8000614e:	a819                	j	80006164 <.L142>

80006150 <.L143>:
            status = status_clk_shared_cpu0;
80006150:	6795                	lui	a5,0x5
80006152:	5f878793          	addi	a5,a5,1528 # 55f8 <__FLASH_segment_used_size__+0x488>
80006156:	d63e                	sw	a5,44(sp)
        break;
80006158:	a031                	j	80006164 <.L142>

8000615a <.L132>:
        status = status_clk_src_invalid;
8000615a:	6795                	lui	a5,0x5
8000615c:	5f178793          	addi	a5,a5,1521 # 55f1 <__FLASH_segment_used_size__+0x481>
80006160:	d63e                	sw	a5,44(sp)
        break;
80006162:	0001                	nop

80006164 <.L142>:
    return status;
80006164:	57b2                	lw	a5,44(sp)
}
80006166:	853e                	mv	a0,a5
80006168:	50f2                	lw	ra,60(sp)
8000616a:	6121                	addi	sp,sp,64
8000616c:	8082                	ret

Disassembly of section .text.clock_check_in_group:

8000616e <clock_check_in_group>:

bool clock_check_in_group(clock_name_t clock_name, uint32_t group)
{
8000616e:	7179                	addi	sp,sp,-48
80006170:	d606                	sw	ra,44(sp)
80006172:	c62a                	sw	a0,12(sp)
80006174:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80006176:	47b2                	lw	a5,12(sp)
80006178:	83c1                	srli	a5,a5,0x10
8000617a:	ce3e                	sw	a5,28(sp)

    return sysctl_check_group_resource_enable(HPM_SYSCTL, group, resource);
8000617c:	47a2                	lw	a5,8(sp)
8000617e:	0ff7f793          	zext.b	a5,a5
80006182:	4772                	lw	a4,28(sp)
80006184:	08074733          	zext.h	a4,a4
80006188:	863a                	mv	a2,a4
8000618a:	85be                	mv	a1,a5
8000618c:	f4000537          	lui	a0,0xf4000
80006190:	391d                	jal	80005dc6 <sysctl_check_group_resource_enable>
80006192:	87aa                	mv	a5,a0
}
80006194:	853e                	mv	a0,a5
80006196:	50b2                	lw	ra,44(sp)
80006198:	6145                	addi	sp,sp,48
8000619a:	8082                	ret

Disassembly of section .text.clock_connect_group_to_cpu:

8000619c <clock_connect_group_to_cpu>:

void clock_connect_group_to_cpu(uint32_t group, uint32_t cpu)
{
8000619c:	1141                	addi	sp,sp,-16
8000619e:	c62a                	sw	a0,12(sp)
800061a0:	c42e                	sw	a1,8(sp)
    if (cpu == 0U) {
800061a2:	47a2                	lw	a5,8(sp)
800061a4:	ef89                	bnez	a5,800061be <.L163>
        HPM_SYSCTL->AFFILIATE[cpu].SET = (1UL << group);
800061a6:	f40006b7          	lui	a3,0xf4000
800061aa:	47b2                	lw	a5,12(sp)
800061ac:	4705                	li	a4,1
800061ae:	00f71733          	sll	a4,a4,a5
800061b2:	47a2                	lw	a5,8(sp)
800061b4:	09078793          	addi	a5,a5,144
800061b8:	0792                	slli	a5,a5,0x4
800061ba:	97b6                	add	a5,a5,a3
800061bc:	c3d8                	sw	a4,4(a5)

800061be <.L163>:
    }
}
800061be:	0001                	nop
800061c0:	0141                	addi	sp,sp,16
800061c2:	8082                	ret

Disassembly of section .text.clock_update_core_clock:

800061c4 <clock_update_core_clock>:
    while (hpm_csr_get_core_cycle() < expected_ticks) {
    }
}

void clock_update_core_clock(void)
{
800061c4:	1141                	addi	sp,sp,-16
800061c6:	c606                	sw	ra,12(sp)
    hpm_core_clock = clock_get_frequency(clock_cpu0);
800061c8:	6785                	lui	a5,0x1
800061ca:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x6a6>
800061ce:	330d                	jal	80005ef0 <clock_get_frequency>
800061d0:	872a                	mv	a4,a0
800061d2:	000807b7          	lui	a5,0x80
800061d6:	32e7ac23          	sw	a4,824(a5) # 80338 <hpm_core_clock>
}
800061da:	0001                	nop
800061dc:	40b2                	lw	ra,12(sp)
800061de:	0141                	addi	sp,sp,16
800061e0:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate_all:

800061e2 <l1c_dc_invalidate_all>:
{
800061e2:	1141                	addi	sp,sp,-16
800061e4:	47dd                	li	a5,23
800061e6:	00f107a3          	sb	a5,15(sp)

800061ea <.LBB68>:
}

/* send command */
ATTR_ALWAYS_INLINE static inline void l1c_cctl_cmd(uint8_t cmd)
{
    write_csr(CSR_MCCTLCOMMAND, cmd);
800061ea:	00f14783          	lbu	a5,15(sp)
800061ee:	7cc79073          	csrw	0x7cc,a5
}
800061f2:	0001                	nop

800061f4 <.LBE68>:
}
800061f4:	0001                	nop
800061f6:	0141                	addi	sp,sp,16
800061f8:	8082                	ret

Disassembly of section .text.init_py_pins_as_pgpio:

800061fa <init_py_pins_as_pgpio>:
    HPM_PIOC->PAD[IOC_PAD_PY00].FUNC_CTL = PIOC_PY00_FUNC_CTL_PGPIO_Y_00;
800061fa:	f4118737          	lui	a4,0xf4118
800061fe:	6785                	lui	a5,0x1
80006200:	97ba                	add	a5,a5,a4
80006202:	e007a023          	sw	zero,-512(a5) # e00 <__NOR_CFG_OPTION_segment_size__+0x200>
    HPM_PIOC->PAD[IOC_PAD_PY01].FUNC_CTL = PIOC_PY01_FUNC_CTL_PGPIO_Y_01;
80006206:	f4118737          	lui	a4,0xf4118
8000620a:	6785                	lui	a5,0x1
8000620c:	97ba                	add	a5,a5,a4
8000620e:	e007a423          	sw	zero,-504(a5) # e08 <__NOR_CFG_OPTION_segment_size__+0x208>
    HPM_PIOC->PAD[IOC_PAD_PY02].FUNC_CTL = PIOC_PY02_FUNC_CTL_PGPIO_Y_02;
80006212:	f4118737          	lui	a4,0xf4118
80006216:	6785                	lui	a5,0x1
80006218:	97ba                	add	a5,a5,a4
8000621a:	e007a823          	sw	zero,-496(a5) # e10 <__NOR_CFG_OPTION_segment_size__+0x210>
    HPM_PIOC->PAD[IOC_PAD_PY03].FUNC_CTL = PIOC_PY03_FUNC_CTL_PGPIO_Y_03;
8000621e:	f4118737          	lui	a4,0xf4118
80006222:	6785                	lui	a5,0x1
80006224:	97ba                	add	a5,a5,a4
80006226:	e007ac23          	sw	zero,-488(a5) # e18 <__NOR_CFG_OPTION_segment_size__+0x218>
    HPM_PIOC->PAD[IOC_PAD_PY04].FUNC_CTL = PIOC_PY04_FUNC_CTL_PGPIO_Y_04;
8000622a:	f4118737          	lui	a4,0xf4118
8000622e:	6785                	lui	a5,0x1
80006230:	97ba                	add	a5,a5,a4
80006232:	e207a023          	sw	zero,-480(a5) # e20 <__NOR_CFG_OPTION_segment_size__+0x220>
    HPM_PIOC->PAD[IOC_PAD_PY05].FUNC_CTL = PIOC_PY05_FUNC_CTL_PGPIO_Y_05;
80006236:	f4118737          	lui	a4,0xf4118
8000623a:	6785                	lui	a5,0x1
8000623c:	97ba                	add	a5,a5,a4
8000623e:	e207a423          	sw	zero,-472(a5) # e28 <__NOR_CFG_OPTION_segment_size__+0x228>
}
80006242:	0001                	nop
80006244:	8082                	ret

Disassembly of section .text.init_uart0_pins:

80006246 <init_uart0_pins>:
    HPM_IOC->PAD[IOC_PAD_PA00].FUNC_CTL = IOC_PA00_FUNC_CTL_UART0_TXD;
80006246:	f40407b7          	lui	a5,0xf4040
8000624a:	4709                	li	a4,2
8000624c:	c398                	sw	a4,0(a5)
    HPM_IOC->PAD[IOC_PAD_PA01].FUNC_CTL = IOC_PA01_FUNC_CTL_UART0_RXD;
8000624e:	f40407b7          	lui	a5,0xf4040
80006252:	4709                	li	a4,2
80006254:	c798                	sw	a4,8(a5)
}
80006256:	0001                	nop
80006258:	8082                	ret

Disassembly of section .text.init_uart3_pins:

8000625a <init_uart3_pins>:

void init_uart3_pins(void)
{
    HPM_IOC->PAD[IOC_PAD_PA14].FUNC_CTL = IOC_PA14_FUNC_CTL_UART3_RXD;
8000625a:	f40407b7          	lui	a5,0xf4040
8000625e:	4709                	li	a4,2
80006260:	dbb8                	sw	a4,112(a5)

    HPM_IOC->PAD[IOC_PAD_PA15].FUNC_CTL = IOC_PA15_FUNC_CTL_UART3_TXD;
80006262:	f40407b7          	lui	a5,0xf4040
80006266:	4709                	li	a4,2
80006268:	dfb8                	sw	a4,120(a5)
}
8000626a:	0001                	nop
8000626c:	8082                	ret

Disassembly of section .text.sysctl_resource_any_is_busy:

8000626e <sysctl_resource_any_is_busy>:
{
8000626e:	1141                	addi	sp,sp,-16
80006270:	c62a                	sw	a0,12(sp)
    return ptr->RESOURCE[0] & SYSCTL_RESOURCE_GLB_BUSY_MASK;
80006272:	47b2                	lw	a5,12(sp)
80006274:	4398                	lw	a4,0(a5)
80006276:	800007b7          	lui	a5,0x80000
8000627a:	8ff9                	and	a5,a5,a4
8000627c:	00f037b3          	snez	a5,a5
80006280:	0ff7f793          	zext.b	a5,a5
}
80006284:	853e                	mv	a0,a5
80006286:	0141                	addi	sp,sp,16
80006288:	8082                	ret

Disassembly of section .text.gptmr_check_status:

8000628a <gptmr_check_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline bool gptmr_check_status(GPTMR_Type *ptr, uint32_t mask)
{
8000628a:	1141                	addi	sp,sp,-16
8000628c:	c62a                	sw	a0,12(sp)
8000628e:	c42e                	sw	a1,8(sp)
    return (ptr->SR & mask) == mask;
80006290:	47b2                	lw	a5,12(sp)
80006292:	2007a703          	lw	a4,512(a5) # 80000200 <_flash_size+0x7ff00200>
80006296:	47a2                	lw	a5,8(sp)
80006298:	8ff9                	and	a5,a5,a4
8000629a:	4722                	lw	a4,8(sp)
8000629c:	40f707b3          	sub	a5,a4,a5
800062a0:	0017b793          	seqz	a5,a5
800062a4:	0ff7f793          	zext.b	a5,a5
}
800062a8:	853e                	mv	a0,a5
800062aa:	0141                	addi	sp,sp,16
800062ac:	8082                	ret

Disassembly of section .text.gptmr_clear_status:

800062ae <gptmr_clear_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline void gptmr_clear_status(GPTMR_Type *ptr, uint32_t mask)
{
800062ae:	1141                	addi	sp,sp,-16
800062b0:	c62a                	sw	a0,12(sp)
800062b2:	c42e                	sw	a1,8(sp)
    ptr->SR = mask;
800062b4:	47b2                	lw	a5,12(sp)
800062b6:	4722                	lw	a4,8(sp)
800062b8:	20e7a023          	sw	a4,512(a5)
}
800062bc:	0001                	nop
800062be:	0141                	addi	sp,sp,16
800062c0:	8082                	ret

Disassembly of section .text.usb_phy_disable_dp_dm_pulldown:

800062c2 <usb_phy_disable_dp_dm_pulldown>:
 * @brief USB phy disconnect dp/dm pins pulldown resistance
 *
 * @param[in] ptr A USB peripheral base address
 */
static inline void usb_phy_disable_dp_dm_pulldown(USB_Type *ptr)
{
800062c2:	1141                	addi	sp,sp,-16
800062c4:	c62a                	sw	a0,12(sp)
    ptr->PHY_CTRL0 |= 0x001000E0u;
800062c6:	47b2                	lw	a5,12(sp)
800062c8:	2107a703          	lw	a4,528(a5)
800062cc:	001007b7          	lui	a5,0x100
800062d0:	0e078793          	addi	a5,a5,224 # 1000e0 <_flash_size+0xe0>
800062d4:	8f5d                	or	a4,a4,a5
800062d6:	47b2                	lw	a5,12(sp)
800062d8:	20e7a823          	sw	a4,528(a5)
}
800062dc:	0001                	nop
800062de:	0141                	addi	sp,sp,16
800062e0:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_is_enabled:

800062e2 <pllctlv2_xtal_is_enabled>:
{
800062e2:	1141                	addi	sp,sp,-16
800062e4:	c62a                	sw	a0,12(sp)
    return IS_HPM_BITMASK_SET(ptr->XTAL, PLLCTLV2_XTAL_ENABLE_MASK);
800062e6:	47b2                	lw	a5,12(sp)
800062e8:	4398                	lw	a4,0(a5)
800062ea:	100007b7          	lui	a5,0x10000
800062ee:	8ff9                	and	a5,a5,a4
800062f0:	00f037b3          	snez	a5,a5
800062f4:	0ff7f793          	zext.b	a5,a5
}
800062f8:	853e                	mv	a0,a5
800062fa:	0141                	addi	sp,sp,16
800062fc:	8082                	ret

Disassembly of section .text.board_init_console:

800062fe <board_init_console>:
{
800062fe:	1101                	addi	sp,sp,-32
80006300:	ce06                	sw	ra,28(sp)
    init_uart_pins((UART_Type *) BOARD_CONSOLE_UART_BASE);
80006302:	f0040537          	lui	a0,0xf0040
80006306:	2251                	jal	8000648a <init_uart_pins>
    clock_add_to_group(BOARD_CONSOLE_UART_CLK_NAME, 0);
80006308:	4581                	li	a1,0
8000630a:	011907b7          	lui	a5,0x1190
8000630e:	01578513          	addi	a0,a5,21 # 1190015 <_flash_size+0x1090015>
80006312:	9d1fd0ef          	jal	80003ce2 <clock_add_to_group>
    cfg.type = BOARD_CONSOLE_TYPE;
80006316:	c002                	sw	zero,0(sp)
    cfg.base = (uint32_t)BOARD_CONSOLE_UART_BASE;
80006318:	f00407b7          	lui	a5,0xf0040
8000631c:	c23e                	sw	a5,4(sp)
    cfg.src_freq_in_hz = clock_get_frequency(BOARD_CONSOLE_UART_CLK_NAME);
8000631e:	011907b7          	lui	a5,0x1190
80006322:	01578513          	addi	a0,a5,21 # 1190015 <_flash_size+0x1090015>
80006326:	36e9                	jal	80005ef0 <clock_get_frequency>
80006328:	87aa                	mv	a5,a0
8000632a:	c43e                	sw	a5,8(sp)
    cfg.baudrate = BOARD_CONSOLE_UART_BAUDRATE;
8000632c:	67f1                	lui	a5,0x1c
8000632e:	20078793          	addi	a5,a5,512 # 1c200 <__AHB_SRAM_segment_size__+0x14200>
80006332:	c63e                	sw	a5,12(sp)
    if (status_success != console_init(&cfg)) {
80006334:	878a                	mv	a5,sp
80006336:	853e                	mv	a0,a5
80006338:	2d1d                	jal	8000696e <console_init>
8000633a:	87aa                	mv	a5,a0
8000633c:	c391                	beqz	a5,80006340 <.L45>

8000633e <.L44>:
        while (1) {
8000633e:	a001                	j	8000633e <.L44>

80006340 <.L45>:
}
80006340:	0001                	nop
80006342:	40f2                	lw	ra,28(sp)
80006344:	6105                	addi	sp,sp,32
80006346:	8082                	ret

Disassembly of section .text.board_init:

80006348 <board_init>:
{
80006348:	1141                	addi	sp,sp,-16
8000634a:	c606                	sw	ra,12(sp)
    init_py_pins_as_pgpio();
8000634c:	357d                	jal	800061fa <init_py_pins_as_pgpio>
    board_init_usb_dp_dm_pins();
8000634e:	c77fd0ef          	jal	80003fc4 <board_init_usb_dp_dm_pins>
    board_init_clock();
80006352:	2819                	jal	80006368 <.LFE358>
    board_init_console();
80006354:	376d                	jal	800062fe <board_init_console>
    board_init_pmp();
80006356:	2a05                	jal	80006486 <board_init_pmp>
    board_print_clock_freq();
80006358:	be3fd0ef          	jal	80003f3a <board_print_clock_freq>
    board_print_banner();
8000635c:	b9dfd0ef          	jal	80003ef8 <board_print_banner>
}
80006360:	0001                	nop
80006362:	40b2                	lw	ra,12(sp)
80006364:	0141                	addi	sp,sp,16
80006366:	8082                	ret

Disassembly of section .text.board_init_clock:

80006368 <board_init_clock>:

void board_init_clock(void)
{
80006368:	1101                	addi	sp,sp,-32
8000636a:	ce06                	sw	ra,28(sp)
    uint32_t cpu0_freq = clock_get_frequency(clock_cpu0);
8000636c:	6785                	lui	a5,0x1
8000636e:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x6a6>
80006372:	3ebd                	jal	80005ef0 <clock_get_frequency>
80006374:	c62a                	sw	a0,12(sp)

    if (cpu0_freq == PLLCTL_SOC_PLL_REFCLK_FREQ) {
80006376:	4732                	lw	a4,12(sp)
80006378:	016e37b7          	lui	a5,0x16e3
8000637c:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80006380:	00f71f63          	bne	a4,a5,8000639e <.L57>
        /* Configure the External OSC ramp-up time: ~9ms */
        pllctlv2_xtal_set_rampup_time(HPM_PLLCTLV2, 32UL * 1000UL * 9U);
80006384:	000467b7          	lui	a5,0x46
80006388:	50078593          	addi	a1,a5,1280 # 46500 <__ILM_segment_end__+0x26500>
8000638c:	f40c0537          	lui	a0,0xf40c0
80006390:	b43fd0ef          	jal	80003ed2 <pllctlv2_xtal_set_rampup_time>

        /* Select clock setting preset1 */
        sysctl_clock_set_preset(HPM_SYSCTL, 2);
80006394:	4589                	li	a1,2
80006396:	f4000537          	lui	a0,0xf4000
8000639a:	ad9fd0ef          	jal	80003e72 <sysctl_clock_set_preset>

8000639e <.L57>:
    }

    /* group0[0] */
    clock_add_to_group(clock_cpu0, 0);
8000639e:	4581                	li	a1,0
800063a0:	6785                	lui	a5,0x1
800063a2:	9fc78513          	addi	a0,a5,-1540 # 9fc <__ILM_segment_used_end__+0x6a6>
800063a6:	93dfd0ef          	jal	80003ce2 <clock_add_to_group>
    clock_add_to_group(clock_ahb, 0);
800063aa:	4581                	li	a1,0
800063ac:	fffd07b7          	lui	a5,0xfffd0
800063b0:	5fe78513          	addi	a0,a5,1534 # fffd05fe <__AHB_SRAM_segment_end__+0xfbc85fe>
800063b4:	92ffd0ef          	jal	80003ce2 <clock_add_to_group>
    clock_add_to_group(clock_lmm0, 0);
800063b8:	4581                	li	a1,0
800063ba:	010117b7          	lui	a5,0x1011
800063be:	90078513          	addi	a0,a5,-1792 # 1010900 <_flash_size+0xf10900>
800063c2:	921fd0ef          	jal	80003ce2 <clock_add_to_group>
    clock_add_to_group(clock_mchtmr0, 0);
800063c6:	4581                	li	a1,0
800063c8:	01020537          	lui	a0,0x1020
800063cc:	917fd0ef          	jal	80003ce2 <clock_add_to_group>
    clock_add_to_group(clock_rom, 0);
800063d0:	4581                	li	a1,0
800063d2:	010307b7          	lui	a5,0x1030
800063d6:	50b78513          	addi	a0,a5,1291 # 103050b <_flash_size+0xf3050b>
800063da:	909fd0ef          	jal	80003ce2 <clock_add_to_group>
    clock_add_to_group(clock_mot0, 0);
800063de:	4581                	li	a1,0
800063e0:	012d07b7          	lui	a5,0x12d0
800063e4:	50578513          	addi	a0,a5,1285 # 12d0505 <_flash_size+0x11d0505>
800063e8:	8fbfd0ef          	jal	80003ce2 <clock_add_to_group>
    clock_add_to_group(clock_gpio, 0);
800063ec:	4581                	li	a1,0
800063ee:	013107b7          	lui	a5,0x1310
800063f2:	50978513          	addi	a0,a5,1289 # 1310509 <_flash_size+0x1210509>
800063f6:	8edfd0ef          	jal	80003ce2 <clock_add_to_group>
    clock_add_to_group(clock_hdma, 0);
800063fa:	4581                	li	a1,0
800063fc:	013207b7          	lui	a5,0x1320
80006400:	50a78513          	addi	a0,a5,1290 # 132050a <_flash_size+0x122050a>
80006404:	8dffd0ef          	jal	80003ce2 <clock_add_to_group>
    clock_add_to_group(clock_xpi0, 0);
80006408:	4581                	li	a1,0
8000640a:	013307b7          	lui	a5,0x1330
8000640e:	01d78513          	addi	a0,a5,29 # 133001d <_flash_size+0x123001d>
80006412:	8d1fd0ef          	jal	80003ce2 <clock_add_to_group>
    clock_add_to_group(clock_ptpc, 0);
80006416:	4581                	li	a1,0
80006418:	010807b7          	lui	a5,0x1080
8000641c:	50e78513          	addi	a0,a5,1294 # 108050e <_flash_size+0xf8050e>
80006420:	8c3fd0ef          	jal	80003ce2 <clock_add_to_group>

    /* Connect Group0 to CPU0 */
    clock_connect_group_to_cpu(0, 0);
80006424:	4581                	li	a1,0
80006426:	4501                	li	a0,0
80006428:	3b95                	jal	8000619c <clock_connect_group_to_cpu>

    /* Bump up DCDC voltage to 1275mv */
    pcfg_dcdc_set_voltage(HPM_PCFG, 1275);
8000642a:	4fb00593          	li	a1,1275
8000642e:	f4104537          	lui	a0,0xf4104
80006432:	29d5                	jal	80006926 <pcfg_dcdc_set_voltage>

    /* Configure CPU to 480MHz, AXI/AHB to 160MHz */
    sysctl_config_cpu0_domain_clock(HPM_SYSCTL, clock_source_pll0_clk0, 2, 3);
80006434:	468d                	li	a3,3
80006436:	4609                	li	a2,2
80006438:	4585                	li	a1,1
8000643a:	f4000537          	lui	a0,0xf4000
8000643e:	3af5                	jal	80005e3a <sysctl_config_cpu0_domain_clock>
    /* Configure PLL0 Post Divider */
    pllctlv2_set_postdiv(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk0, pllctlv2_div_1p0);    /* PLL0CLK0: 960MHz */
80006440:	4681                	li	a3,0
80006442:	4601                	li	a2,0
80006444:	4581                	li	a1,0
80006446:	f40c0537          	lui	a0,0xf40c0
8000644a:	2c85                	jal	800066ba <pllctlv2_set_postdiv>
    pllctlv2_set_postdiv(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk1, pllctlv2_div_1p6);    /* PLL0CLK1: 600MHz */
8000644c:	468d                	li	a3,3
8000644e:	4605                	li	a2,1
80006450:	4581                	li	a1,0
80006452:	f40c0537          	lui	a0,0xf40c0
80006456:	2495                	jal	800066ba <pllctlv2_set_postdiv>
    pllctlv2_set_postdiv(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk2, pllctlv2_div_2p4);    /* PLL0CLK2: 400MHz */
80006458:	469d                	li	a3,7
8000645a:	4609                	li	a2,2
8000645c:	4581                	li	a1,0
8000645e:	f40c0537          	lui	a0,0xf40c0
80006462:	2ca1                	jal	800066ba <pllctlv2_set_postdiv>
    /* Configure PLL0 Frequency to 960MHz */
    pllctlv2_init_pll_with_freq(HPM_PLLCTLV2, pllctlv2_pll0, 960000000);
80006464:	39387637          	lui	a2,0x39387
80006468:	4581                	li	a1,0
8000646a:	f40c0537          	lui	a0,0xf40c0
8000646e:	958fe0ef          	jal	800045c6 <pllctlv2_init_pll_with_freq>

    clock_update_core_clock();
80006472:	3b89                	jal	800061c4 <clock_update_core_clock>

    /* Configure mchtmr to 24MHz */
    clock_set_source_divider(clock_mchtmr0, clk_src_osc24m, 1);
80006474:	4605                	li	a2,1
80006476:	4581                	li	a1,0
80006478:	01020537          	lui	a0,0x1020
8000647c:	3ed5                	jal	80006070 <clock_set_source_divider>
}
8000647e:	0001                	nop
80006480:	40f2                	lw	ra,28(sp)
80006482:	6105                	addi	sp,sp,32
80006484:	8082                	ret

Disassembly of section .text.board_init_pmp:

80006486 <board_init_pmp>:
    return BOARD_LED_OFF_LEVEL;
}

void board_init_pmp(void)
{
}
80006486:	0001                	nop
80006488:	8082                	ret

Disassembly of section .text.init_uart_pins:

8000648a <init_uart_pins>:
    }
    return freq;
}

void init_uart_pins(UART_Type *ptr)
{
8000648a:	1101                	addi	sp,sp,-32
8000648c:	ce06                	sw	ra,28(sp)
8000648e:	c62a                	sw	a0,12(sp)
    if (ptr == HPM_UART0) {
80006490:	4732                	lw	a4,12(sp)
80006492:	f00407b7          	lui	a5,0xf0040
80006496:	00f71463          	bne	a4,a5,8000649e <.L153>
        init_uart0_pins();
8000649a:	3375                	jal	80006246 <init_uart0_pins>
        /* using for uart_lin function */
        init_uart3_pins();
    } else {
        ;
    }
}
8000649c:	a839                	j	800064ba <.L156>

8000649e <.L153>:
    } else if (ptr == HPM_UART2) {
8000649e:	4732                	lw	a4,12(sp)
800064a0:	f00487b7          	lui	a5,0xf0048
800064a4:	00f71563          	bne	a4,a5,800064ae <.L155>
        init_uart2_pins();
800064a8:	91bfd0ef          	jal	80003dc2 <init_uart2_pins>
}
800064ac:	a039                	j	800064ba <.L156>

800064ae <.L155>:
    } else if (ptr == HPM_UART3) {
800064ae:	4732                	lw	a4,12(sp)
800064b0:	f004c7b7          	lui	a5,0xf004c
800064b4:	00f71363          	bne	a4,a5,800064ba <.L156>
        init_uart3_pins();
800064b8:	334d                	jal	8000625a <init_uart3_pins>

800064ba <.L156>:
}
800064ba:	0001                	nop
800064bc:	40f2                	lw	ra,28(sp)
800064be:	6105                	addi	sp,sp,32
800064c0:	8082                	ret

Disassembly of section .text.uart_modem_config:

800064c2 <uart_modem_config>:
 *
 * @param [in] ptr UART base address
 * @param config Pointer to modem config struct
 */
static inline void uart_modem_config(UART_Type *ptr, uart_modem_config_t *config)
{
800064c2:	1141                	addi	sp,sp,-16
800064c4:	c62a                	sw	a0,12(sp)
800064c6:	c42e                	sw	a1,8(sp)
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
800064c8:	47a2                	lw	a5,8(sp)
800064ca:	0007c783          	lbu	a5,0(a5) # f004c000 <__FLASH_segment_end__+0x6ff4c000>
800064ce:	0796                	slli	a5,a5,0x5
800064d0:	0207f713          	andi	a4,a5,32
        | UART_MCR_LOOP_SET(config->loop_back_en)
800064d4:	47a2                	lw	a5,8(sp)
800064d6:	0017c783          	lbu	a5,1(a5)
800064da:	0792                	slli	a5,a5,0x4
800064dc:	8bc1                	andi	a5,a5,16
800064de:	8f5d                	or	a4,a4,a5
        | UART_MCR_RTS_SET(!config->set_rts_high);
800064e0:	47a2                	lw	a5,8(sp)
800064e2:	0027c783          	lbu	a5,2(a5)
800064e6:	0017c793          	xori	a5,a5,1
800064ea:	0ff7f793          	zext.b	a5,a5
800064ee:	0786                	slli	a5,a5,0x1
800064f0:	8b89                	andi	a5,a5,2
800064f2:	8f5d                	or	a4,a4,a5
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
800064f4:	47b2                	lw	a5,12(sp)
800064f6:	db98                	sw	a4,48(a5)
}
800064f8:	0001                	nop
800064fa:	0141                	addi	sp,sp,16
800064fc:	8082                	ret

Disassembly of section .text.uart_disable_irq:

800064fe <uart_disable_irq>:
 *
 * @param [in] ptr UART base address
 * @param irq_mask IRQ mask value to be disabled
 */
static inline void uart_disable_irq(UART_Type *ptr, uint32_t irq_mask)
{
800064fe:	1141                	addi	sp,sp,-16
80006500:	c62a                	sw	a0,12(sp)
80006502:	c42e                	sw	a1,8(sp)
    ptr->IER &= ~irq_mask;
80006504:	47b2                	lw	a5,12(sp)
80006506:	53d8                	lw	a4,36(a5)
80006508:	47a2                	lw	a5,8(sp)
8000650a:	fff7c793          	not	a5,a5
8000650e:	8f7d                	and	a4,a4,a5
80006510:	47b2                	lw	a5,12(sp)
80006512:	d3d8                	sw	a4,36(a5)
}
80006514:	0001                	nop
80006516:	0141                	addi	sp,sp,16
80006518:	8082                	ret

Disassembly of section .text.uart_enable_irq:

8000651a <uart_enable_irq>:
 *
 * @param [in] ptr UART base address
 * @param irq_mask IRQ mask value to be enabled
 */
static inline void uart_enable_irq(UART_Type *ptr, uint32_t irq_mask)
{
8000651a:	1141                	addi	sp,sp,-16
8000651c:	c62a                	sw	a0,12(sp)
8000651e:	c42e                	sw	a1,8(sp)
    ptr->IER |= irq_mask;
80006520:	47b2                	lw	a5,12(sp)
80006522:	53d8                	lw	a4,36(a5)
80006524:	47a2                	lw	a5,8(sp)
80006526:	8f5d                	or	a4,a4,a5
80006528:	47b2                	lw	a5,12(sp)
8000652a:	d3d8                	sw	a4,36(a5)
}
8000652c:	0001                	nop
8000652e:	0141                	addi	sp,sp,16
80006530:	8082                	ret

Disassembly of section .text.uart_default_config:

80006532 <uart_default_config>:
{
80006532:	1141                	addi	sp,sp,-16
80006534:	c62a                	sw	a0,12(sp)
80006536:	c42e                	sw	a1,8(sp)
    config->baudrate = 115200;
80006538:	47a2                	lw	a5,8(sp)
8000653a:	6771                	lui	a4,0x1c
8000653c:	20070713          	addi	a4,a4,512 # 1c200 <__AHB_SRAM_segment_size__+0x14200>
80006540:	c3d8                	sw	a4,4(a5)
    config->word_length = word_length_8_bits;
80006542:	47a2                	lw	a5,8(sp)
80006544:	470d                	li	a4,3
80006546:	00e784a3          	sb	a4,9(a5)
    config->parity = parity_none;
8000654a:	47a2                	lw	a5,8(sp)
8000654c:	00078523          	sb	zero,10(a5)
    config->num_of_stop_bits = stop_bits_1;
80006550:	47a2                	lw	a5,8(sp)
80006552:	00078423          	sb	zero,8(a5)
    config->fifo_enable = true;
80006556:	47a2                	lw	a5,8(sp)
80006558:	4705                	li	a4,1
8000655a:	00e78723          	sb	a4,14(a5)
    config->rx_fifo_level = uart_rx_fifo_trg_not_empty;
8000655e:	47a2                	lw	a5,8(sp)
80006560:	00078623          	sb	zero,12(a5)
    config->tx_fifo_level = uart_tx_fifo_trg_not_full;
80006564:	47a2                	lw	a5,8(sp)
80006566:	473d                	li	a4,15
80006568:	00e785a3          	sb	a4,11(a5)
    config->dma_enable = false;
8000656c:	47a2                	lw	a5,8(sp)
8000656e:	000786a3          	sb	zero,13(a5)
    config->modem_config.auto_flow_ctrl_en = false;
80006572:	47a2                	lw	a5,8(sp)
80006574:	000787a3          	sb	zero,15(a5)
    config->modem_config.loop_back_en = false;
80006578:	47a2                	lw	a5,8(sp)
8000657a:	00078823          	sb	zero,16(a5)
    config->modem_config.set_rts_high = false;
8000657e:	47a2                	lw	a5,8(sp)
80006580:	000788a3          	sb	zero,17(a5)
    config->rxidle_config.detect_enable = false;
80006584:	47a2                	lw	a5,8(sp)
80006586:	00078923          	sb	zero,18(a5)
    config->rxidle_config.detect_irq_enable = false;
8000658a:	47a2                	lw	a5,8(sp)
8000658c:	000789a3          	sb	zero,19(a5)
    config->rxidle_config.idle_cond = uart_rxline_idle_cond_rxline_logic_one;
80006590:	47a2                	lw	a5,8(sp)
80006592:	00078a23          	sb	zero,20(a5)
    config->rxidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
80006596:	47a2                	lw	a5,8(sp)
80006598:	4729                	li	a4,10
8000659a:	00e78aa3          	sb	a4,21(a5)
    config->txidle_config.detect_enable = false;
8000659e:	47a2                	lw	a5,8(sp)
800065a0:	00078b23          	sb	zero,22(a5)
    config->txidle_config.detect_irq_enable = false;
800065a4:	47a2                	lw	a5,8(sp)
800065a6:	00078ba3          	sb	zero,23(a5)
    config->txidle_config.idle_cond = uart_rxline_idle_cond_rxline_logic_one;
800065aa:	47a2                	lw	a5,8(sp)
800065ac:	00078c23          	sb	zero,24(a5)
    config->txidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
800065b0:	47a2                	lw	a5,8(sp)
800065b2:	4729                	li	a4,10
800065b4:	00e78ca3          	sb	a4,25(a5)
    config->rx_enable = true;
800065b8:	47a2                	lw	a5,8(sp)
800065ba:	4705                	li	a4,1
800065bc:	00e78d23          	sb	a4,26(a5)
}
800065c0:	0001                	nop
800065c2:	0141                	addi	sp,sp,16
800065c4:	8082                	ret

Disassembly of section .text.uart_flush:

800065c6 <uart_flush>:
{
800065c6:	1101                	addi	sp,sp,-32
800065c8:	c62a                	sw	a0,12(sp)
    uint32_t retry = 0;
800065ca:	ce02                	sw	zero,28(sp)
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
800065cc:	a811                	j	800065e0 <.L60>

800065ce <.L63>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
800065ce:	4772                	lw	a4,28(sp)
800065d0:	6785                	lui	a5,0x1
800065d2:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
800065d6:	00e7eb63          	bltu	a5,a4,800065ec <.L66>
        retry++;
800065da:	47f2                	lw	a5,28(sp)
800065dc:	0785                	addi	a5,a5,1
800065de:	ce3e                	sw	a5,28(sp)

800065e0 <.L60>:
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
800065e0:	47b2                	lw	a5,12(sp)
800065e2:	5bdc                	lw	a5,52(a5)
800065e4:	0407f793          	andi	a5,a5,64
800065e8:	d3fd                	beqz	a5,800065ce <.L63>
800065ea:	a011                	j	800065ee <.L62>

800065ec <.L66>:
            break;
800065ec:	0001                	nop

800065ee <.L62>:
    if (retry > HPM_UART_DRV_RETRY_COUNT) {
800065ee:	4772                	lw	a4,28(sp)
800065f0:	6785                	lui	a5,0x1
800065f2:	38878793          	addi	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
800065f6:	00e7f463          	bgeu	a5,a4,800065fe <.L64>
        return status_timeout;
800065fa:	478d                	li	a5,3
800065fc:	a011                	j	80006600 <.L65>

800065fe <.L64>:
    return status_success;
800065fe:	4781                	li	a5,0

80006600 <.L65>:
}
80006600:	853e                	mv	a0,a5
80006602:	6105                	addi	sp,sp,32
80006604:	8082                	ret

Disassembly of section .text.uart_init_rxline_idle_detection:

80006606 <uart_init_rxline_idle_detection>:
{
80006606:	1101                	addi	sp,sp,-32
80006608:	ce06                	sw	ra,28(sp)
8000660a:	c62a                	sw	a0,12(sp)
8000660c:	c42e                	sw	a1,8(sp)
    ptr->IDLE_CFG &= ~(UART_IDLE_CFG_RX_IDLE_EN_MASK
8000660e:	47b2                	lw	a5,12(sp)
80006610:	43dc                	lw	a5,4(a5)
80006612:	c007f713          	andi	a4,a5,-1024
80006616:	47b2                	lw	a5,12(sp)
80006618:	c3d8                	sw	a4,4(a5)
    ptr->IDLE_CFG |= UART_IDLE_CFG_RX_IDLE_EN_SET(rxidle_config.detect_enable)
8000661a:	47b2                	lw	a5,12(sp)
8000661c:	43d8                	lw	a4,4(a5)
8000661e:	00814783          	lbu	a5,8(sp)
80006622:	07a2                	slli	a5,a5,0x8
80006624:	1007f793          	andi	a5,a5,256
                    | UART_IDLE_CFG_RX_IDLE_THR_SET(rxidle_config.threshold)
80006628:	00b14683          	lbu	a3,11(sp)
8000662c:	8edd                	or	a3,a3,a5
                    | UART_IDLE_CFG_RX_IDLE_COND_SET(rxidle_config.idle_cond);
8000662e:	00a14783          	lbu	a5,10(sp)
80006632:	07a6                	slli	a5,a5,0x9
80006634:	2007f793          	andi	a5,a5,512
80006638:	8fd5                	or	a5,a5,a3
    ptr->IDLE_CFG |= UART_IDLE_CFG_RX_IDLE_EN_SET(rxidle_config.detect_enable)
8000663a:	8f5d                	or	a4,a4,a5
8000663c:	47b2                	lw	a5,12(sp)
8000663e:	c3d8                	sw	a4,4(a5)
    if (rxidle_config.detect_irq_enable) {
80006640:	00914783          	lbu	a5,9(sp)
80006644:	c791                	beqz	a5,80006650 <.L93>
        uart_enable_irq(ptr, uart_intr_rx_line_idle);
80006646:	800005b7          	lui	a1,0x80000
8000664a:	4532                	lw	a0,12(sp)
8000664c:	35f9                	jal	8000651a <uart_enable_irq>
8000664e:	a029                	j	80006658 <.L94>

80006650 <.L93>:
        uart_disable_irq(ptr, uart_intr_rx_line_idle);
80006650:	800005b7          	lui	a1,0x80000
80006654:	4532                	lw	a0,12(sp)
80006656:	3565                	jal	800064fe <uart_disable_irq>

80006658 <.L94>:
    return status_success;
80006658:	4781                	li	a5,0
}
8000665a:	853e                	mv	a0,a5
8000665c:	40f2                	lw	ra,28(sp)
8000665e:	6105                	addi	sp,sp,32
80006660:	8082                	ret

Disassembly of section .text.pllctlv2_pll_clk_is_stable:

80006662 <pllctlv2_pll_clk_is_stable>:
 * @param [in] pll Index of the PLL to check (pllctlv2_pll0 through pllctlv2_pll6)
 * @param [in] clk Post-divider output index (pllctlv2_clk0 through pllctlv2_clk3)
 * @return true if the PLL CLK is stable and locked, false otherwise
 */
static inline bool pllctlv2_pll_clk_is_stable(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk)
{
80006662:	1101                	addi	sp,sp,-32
80006664:	c62a                	sw	a0,12(sp)
80006666:	87ae                	mv	a5,a1
80006668:	8732                	mv	a4,a2
8000666a:	00f105a3          	sb	a5,11(sp)
8000666e:	87ba                	mv	a5,a4
80006670:	00f10523          	sb	a5,10(sp)
    uint32_t status = ptr->PLL[pll].DIV[clk];
80006674:	00b14683          	lbu	a3,11(sp)
80006678:	00a14783          	lbu	a5,10(sp)
8000667c:	4732                	lw	a4,12(sp)
8000667e:	0696                	slli	a3,a3,0x5
80006680:	97b6                	add	a5,a5,a3
80006682:	03078793          	addi	a5,a5,48
80006686:	078a                	slli	a5,a5,0x2
80006688:	97ba                	add	a5,a5,a4
8000668a:	439c                	lw	a5,0(a5)
8000668c:	ce3e                	sw	a5,28(sp)
    return (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_DIV_ENABLE_MASK)
8000668e:	4772                	lw	a4,28(sp)
80006690:	100007b7          	lui	a5,0x10000
80006694:	8ff9                	and	a5,a5,a4
         || (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_DIV_BUSY_MASK) && IS_HPM_BITMASK_SET(status, PLLCTLV2_PLL_DIV_RESPONSE_MASK)));
80006696:	cb89                	beqz	a5,800066a8 <.L7>
80006698:	47f2                	lw	a5,28(sp)
8000669a:	0007c963          	bltz	a5,800066ac <.L8>
8000669e:	4772                	lw	a4,28(sp)
800066a0:	200007b7          	lui	a5,0x20000
800066a4:	8ff9                	and	a5,a5,a4
800066a6:	c399                	beqz	a5,800066ac <.L8>

800066a8 <.L7>:
800066a8:	4785                	li	a5,1
800066aa:	a011                	j	800066ae <.L9>

800066ac <.L8>:
800066ac:	4781                	li	a5,0

800066ae <.L9>:
800066ae:	8b85                	andi	a5,a5,1
800066b0:	0ff7f793          	zext.b	a5,a5
}
800066b4:	853e                	mv	a0,a5
800066b6:	6105                	addi	sp,sp,32
800066b8:	8082                	ret

Disassembly of section .text.pllctlv2_set_postdiv:

800066ba <pllctlv2_set_postdiv>:
        ptr->PLL[pll].CONFIG |= PLLCTLV2_PLL_CONFIG_SPREAD_MASK;
    }
}

void pllctlv2_set_postdiv(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk, pllctlv2_div_t div_value)
{
800066ba:	1101                	addi	sp,sp,-32
800066bc:	ce06                	sw	ra,28(sp)
800066be:	c62a                	sw	a0,12(sp)
800066c0:	87ae                	mv	a5,a1
800066c2:	8736                	mv	a4,a3
800066c4:	00f105a3          	sb	a5,11(sp)
800066c8:	87b2                	mv	a5,a2
800066ca:	00f10523          	sb	a5,10(sp)
800066ce:	87ba                	mv	a5,a4
800066d0:	00f104a3          	sb	a5,9(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
800066d4:	47b2                	lw	a5,12(sp)
800066d6:	c7ad                	beqz	a5,80006740 <.L32>
800066d8:	00b14703          	lbu	a4,11(sp)
800066dc:	4785                	li	a5,1
800066de:	06e7e163          	bltu	a5,a4,80006740 <.L32>
        ptr->PLL[pll].DIV[clk] =
            (ptr->PLL[pll].DIV[clk] & ~PLLCTLV2_PLL_DIV_DIV_MASK) | PLLCTLV2_PLL_DIV_DIV_SET(div_value);
800066e2:	00b14683          	lbu	a3,11(sp)
800066e6:	00a14783          	lbu	a5,10(sp)
800066ea:	4732                	lw	a4,12(sp)
800066ec:	0696                	slli	a3,a3,0x5
800066ee:	97b6                	add	a5,a5,a3
800066f0:	03078793          	addi	a5,a5,48 # 20000030 <_flash_size+0x1ff00030>
800066f4:	078a                	slli	a5,a5,0x2
800066f6:	97ba                	add	a5,a5,a4
800066f8:	439c                	lw	a5,0(a5)
800066fa:	fc07f693          	andi	a3,a5,-64
800066fe:	00914783          	lbu	a5,9(sp)
80006702:	03f7f713          	andi	a4,a5,63
        ptr->PLL[pll].DIV[clk] =
80006706:	00b14603          	lbu	a2,11(sp)
8000670a:	00a14783          	lbu	a5,10(sp)
            (ptr->PLL[pll].DIV[clk] & ~PLLCTLV2_PLL_DIV_DIV_MASK) | PLLCTLV2_PLL_DIV_DIV_SET(div_value);
8000670e:	8f55                	or	a4,a4,a3
        ptr->PLL[pll].DIV[clk] =
80006710:	46b2                	lw	a3,12(sp)
80006712:	0616                	slli	a2,a2,0x5
80006714:	97b2                	add	a5,a5,a2
80006716:	03078793          	addi	a5,a5,48
8000671a:	078a                	slli	a5,a5,0x2
8000671c:	97b6                	add	a5,a5,a3
8000671e:	c398                	sw	a4,0(a5)

        while (!pllctlv2_pll_clk_is_stable(ptr, pll, clk)) {
80006720:	a011                	j	80006724 <.L30>

80006722 <.L31>:
            NOP();
80006722:	0001                	nop

80006724 <.L30>:
        while (!pllctlv2_pll_clk_is_stable(ptr, pll, clk)) {
80006724:	00a14703          	lbu	a4,10(sp)
80006728:	00b14783          	lbu	a5,11(sp)
8000672c:	863a                	mv	a2,a4
8000672e:	85be                	mv	a1,a5
80006730:	4532                	lw	a0,12(sp)
80006732:	3f05                	jal	80006662 <pllctlv2_pll_clk_is_stable>
80006734:	87aa                	mv	a5,a0
80006736:	0017c793          	xori	a5,a5,1
8000673a:	0ff7f793          	zext.b	a5,a5
8000673e:	f3f5                	bnez	a5,80006722 <.L31>

80006740 <.L32>:
        }
    }
}
80006740:	0001                	nop
80006742:	40f2                	lw	ra,28(sp)
80006744:	6105                	addi	sp,sp,32
80006746:	8082                	ret

Disassembly of section .text.pllctlv2_get_pll_freq_in_hz:

80006748 <pllctlv2_get_pll_freq_in_hz>:

uint32_t pllctlv2_get_pll_freq_in_hz(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll)
{
80006748:	7139                	addi	sp,sp,-64
8000674a:	de06                	sw	ra,60(sp)
8000674c:	c62a                	sw	a0,12(sp)
8000674e:	87ae                	mv	a5,a1
80006750:	00f105a3          	sb	a5,11(sp)
    uint32_t freq = 0;
80006754:	d602                	sw	zero,44(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
80006756:	47b2                	lw	a5,12(sp)
80006758:	12078963          	beqz	a5,8000688a <.L34>
8000675c:	00b14703          	lbu	a4,11(sp)
80006760:	4785                	li	a5,1
80006762:	12e7e463          	bltu	a5,a4,8000688a <.L34>

80006766 <.LBB3>:
        uint32_t mfi = PLLCTLV2_PLL_MFI_MFI_GET(ptr->PLL[pll].MFI);
80006766:	00b14783          	lbu	a5,11(sp)
8000676a:	4732                	lw	a4,12(sp)
8000676c:	0785                	addi	a5,a5,1
8000676e:	079e                	slli	a5,a5,0x7
80006770:	97ba                	add	a5,a5,a4
80006772:	439c                	lw	a5,0(a5)
80006774:	07f7f793          	andi	a5,a5,127
80006778:	d23e                	sw	a5,36(sp)
        uint32_t mfn = PLLCTLV2_PLL_MFN_MFN_GET(ptr->PLL[pll].MFN);
8000677a:	00b14783          	lbu	a5,11(sp)
8000677e:	4732                	lw	a4,12(sp)
80006780:	0785                	addi	a5,a5,1
80006782:	079e                	slli	a5,a5,0x7
80006784:	97ba                	add	a5,a5,a4
80006786:	43d8                	lw	a4,4(a5)
80006788:	400007b7          	lui	a5,0x40000
8000678c:	17fd                	addi	a5,a5,-1 # 3fffffff <_flash_size+0x3fefffff>
8000678e:	8ff9                	and	a5,a5,a4
80006790:	d03e                	sw	a5,32(sp)
        uint32_t mfd = PLLCTLV2_PLL_MFD_MFD_GET(ptr->PLL[pll].MFD);
80006792:	00b14783          	lbu	a5,11(sp)
80006796:	4732                	lw	a4,12(sp)
80006798:	0785                	addi	a5,a5,1
8000679a:	079e                	slli	a5,a5,0x7
8000679c:	97ba                	add	a5,a5,a4
8000679e:	4798                	lw	a4,8(a5)
800067a0:	400007b7          	lui	a5,0x40000
800067a4:	17fd                	addi	a5,a5,-1 # 3fffffff <_flash_size+0x3fefffff>
800067a6:	8ff9                	and	a5,a5,a4
800067a8:	ce3e                	sw	a5,28(sp)
        /* Trade-off for avoiding the float computing.
         * Ensure both `mfd` and `PLLCTLV2_PLL_XTAL_FREQ` are n * `FREQ_1MHz`, n is a positive integer
         */
        assert((mfd / FREQ_1MHz) * FREQ_1MHz == mfd);
800067aa:	4772                	lw	a4,28(sp)
800067ac:	431be7b7          	lui	a5,0x431be
800067b0:	e8378793          	addi	a5,a5,-381 # 431bde83 <_flash_size+0x430bde83>
800067b4:	02f737b3          	mulhu	a5,a4,a5
800067b8:	83c9                	srli	a5,a5,0x12
800067ba:	000f46b7          	lui	a3,0xf4
800067be:	24068693          	addi	a3,a3,576 # f4240 <__DLM_segment_end__+0x54240>
800067c2:	02d787b3          	mul	a5,a5,a3
800067c6:	40f707b3          	sub	a5,a4,a5
800067ca:	cb89                	beqz	a5,800067dc <.L35>
800067cc:	06f00613          	li	a2,111
800067d0:	02c18593          	addi	a1,gp,44 # 800038bc <.LC0>
800067d4:	09418513          	addi	a0,gp,148 # 80003924 <.LC1>
800067d8:	f19fd0ef          	jal	800046f0 <__SEGGER_RTL_X_assert>

800067dc <.L35>:
        assert((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * FREQ_1MHz == PLLCTLV2_PLL_XTAL_FREQ);

        uint32_t scaled_num;
        uint32_t scaled_denom;
        uint32_t shifted_mfn;
        uint32_t max_mfn = 0xFFFFFFFF / (PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz);
800067dc:	0aaab7b7          	lui	a5,0xaaab
800067e0:	aaa78793          	addi	a5,a5,-1366 # aaaaaaa <_flash_size+0xa9aaaaa>
800067e4:	cc3e                	sw	a5,24(sp)
        if (mfn < max_mfn) {
800067e6:	5702                	lw	a4,32(sp)
800067e8:	47e2                	lw	a5,24(sp)
800067ea:	02f77f63          	bgeu	a4,a5,80006828 <.L36>
            scaled_num =  (PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * mfn;
800067ee:	5702                	lw	a4,32(sp)
800067f0:	87ba                	mv	a5,a4
800067f2:	0786                	slli	a5,a5,0x1
800067f4:	97ba                	add	a5,a5,a4
800067f6:	078e                	slli	a5,a5,0x3
800067f8:	c83e                	sw	a5,16(sp)
            scaled_denom = mfd / FREQ_1MHz;
800067fa:	4772                	lw	a4,28(sp)
800067fc:	431be7b7          	lui	a5,0x431be
80006800:	e8378793          	addi	a5,a5,-381 # 431bde83 <_flash_size+0x430bde83>
80006804:	02f737b3          	mulhu	a5,a4,a5
80006808:	83c9                	srli	a5,a5,0x12
8000680a:	ca3e                	sw	a5,20(sp)
            freq = PLLCTLV2_PLL_XTAL_FREQ * mfi + scaled_num / scaled_denom;
8000680c:	5712                	lw	a4,36(sp)
8000680e:	016e37b7          	lui	a5,0x16e3
80006812:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80006816:	02f70733          	mul	a4,a4,a5
8000681a:	46c2                	lw	a3,16(sp)
8000681c:	47d2                	lw	a5,20(sp)
8000681e:	02f6d7b3          	divu	a5,a3,a5
80006822:	97ba                	add	a5,a5,a4
80006824:	d63e                	sw	a5,44(sp)
80006826:	a095                	j	8000688a <.L34>

80006828 <.L36>:
        } else {
            shifted_mfn = mfn;
80006828:	5782                	lw	a5,32(sp)
8000682a:	d43e                	sw	a5,40(sp)
            while (shifted_mfn > max_mfn) {
8000682c:	a021                	j	80006834 <.L37>

8000682e <.L38>:
                shifted_mfn >>= 1;
8000682e:	57a2                	lw	a5,40(sp)
80006830:	8385                	srli	a5,a5,0x1
80006832:	d43e                	sw	a5,40(sp)

80006834 <.L37>:
            while (shifted_mfn > max_mfn) {
80006834:	5722                	lw	a4,40(sp)
80006836:	47e2                	lw	a5,24(sp)
80006838:	fee7ebe3          	bltu	a5,a4,8000682e <.L38>
            }
            scaled_denom = mfd / FREQ_1MHz;
8000683c:	4772                	lw	a4,28(sp)
8000683e:	431be7b7          	lui	a5,0x431be
80006842:	e8378793          	addi	a5,a5,-381 # 431bde83 <_flash_size+0x430bde83>
80006846:	02f737b3          	mulhu	a5,a4,a5
8000684a:	83c9                	srli	a5,a5,0x12
8000684c:	ca3e                	sw	a5,20(sp)
            freq = PLLCTLV2_PLL_XTAL_FREQ * mfi + ((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * shifted_mfn) / scaled_denom +  ((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * (mfn - shifted_mfn)) / scaled_denom;
8000684e:	5712                	lw	a4,36(sp)
80006850:	016e37b7          	lui	a5,0x16e3
80006854:	60078793          	addi	a5,a5,1536 # 16e3600 <_flash_size+0x15e3600>
80006858:	02f706b3          	mul	a3,a4,a5
8000685c:	5722                	lw	a4,40(sp)
8000685e:	87ba                	mv	a5,a4
80006860:	0786                	slli	a5,a5,0x1
80006862:	97ba                	add	a5,a5,a4
80006864:	078e                	slli	a5,a5,0x3
80006866:	873e                	mv	a4,a5
80006868:	47d2                	lw	a5,20(sp)
8000686a:	02f757b3          	divu	a5,a4,a5
8000686e:	96be                	add	a3,a3,a5
80006870:	5702                	lw	a4,32(sp)
80006872:	57a2                	lw	a5,40(sp)
80006874:	8f1d                	sub	a4,a4,a5
80006876:	87ba                	mv	a5,a4
80006878:	0786                	slli	a5,a5,0x1
8000687a:	97ba                	add	a5,a5,a4
8000687c:	078e                	slli	a5,a5,0x3
8000687e:	873e                	mv	a4,a5
80006880:	47d2                	lw	a5,20(sp)
80006882:	02f757b3          	divu	a5,a4,a5
80006886:	97b6                	add	a5,a5,a3
80006888:	d63e                	sw	a5,44(sp)

8000688a <.L34>:
        }
    }
    return freq;
8000688a:	57b2                	lw	a5,44(sp)
}
8000688c:	853e                	mv	a0,a5
8000688e:	50f2                	lw	ra,60(sp)
80006890:	6121                	addi	sp,sp,64
80006892:	8082                	ret

Disassembly of section .text.pllctlv2_get_pll_postdiv_freq_in_hz:

80006894 <pllctlv2_get_pll_postdiv_freq_in_hz>:

uint32_t pllctlv2_get_pll_postdiv_freq_in_hz(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk)
{
80006894:	7179                	addi	sp,sp,-48
80006896:	d606                	sw	ra,44(sp)
80006898:	c62a                	sw	a0,12(sp)
8000689a:	87ae                	mv	a5,a1
8000689c:	8732                	mv	a4,a2
8000689e:	00f105a3          	sb	a5,11(sp)
800068a2:	87ba                	mv	a5,a4
800068a4:	00f10523          	sb	a5,10(sp)
    uint32_t postdiv_freq = 0;
800068a8:	ce02                	sw	zero,28(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
800068aa:	47b2                	lw	a5,12(sp)
800068ac:	cba5                	beqz	a5,8000691c <.L41>
800068ae:	00b14703          	lbu	a4,11(sp)
800068b2:	4785                	li	a5,1
800068b4:	06e7e463          	bltu	a5,a4,8000691c <.L41>

800068b8 <.LBB4>:
        uint32_t postdiv = PLLCTLV2_PLL_DIV_DIV_GET(ptr->PLL[pll].DIV[clk]);
800068b8:	00b14683          	lbu	a3,11(sp)
800068bc:	00a14783          	lbu	a5,10(sp)
800068c0:	4732                	lw	a4,12(sp)
800068c2:	0696                	slli	a3,a3,0x5
800068c4:	97b6                	add	a5,a5,a3
800068c6:	03078793          	addi	a5,a5,48
800068ca:	078a                	slli	a5,a5,0x2
800068cc:	97ba                	add	a5,a5,a4
800068ce:	439c                	lw	a5,0(a5)
800068d0:	03f7f793          	andi	a5,a5,63
800068d4:	cc3e                	sw	a5,24(sp)
        uint32_t pll_freq = pllctlv2_get_pll_freq_in_hz(ptr, pll);
800068d6:	00b14783          	lbu	a5,11(sp)
800068da:	85be                	mv	a1,a5
800068dc:	4532                	lw	a0,12(sp)
800068de:	35ad                	jal	80006748 <pllctlv2_get_pll_freq_in_hz>
800068e0:	ca2a                	sw	a0,20(sp)
        postdiv_freq = (uint32_t) (pll_freq / (100 + postdiv * 100 / 5U) * 100);
800068e2:	4762                	lw	a4,24(sp)
800068e4:	87ba                	mv	a5,a4
800068e6:	078a                	slli	a5,a5,0x2
800068e8:	97ba                	add	a5,a5,a4
800068ea:	00279713          	slli	a4,a5,0x2
800068ee:	97ba                	add	a5,a5,a4
800068f0:	078a                	slli	a5,a5,0x2
800068f2:	873e                	mv	a4,a5
800068f4:	ccccd7b7          	lui	a5,0xccccd
800068f8:	ccd78793          	addi	a5,a5,-819 # cccccccd <__FLASH_segment_end__+0x4cbccccd>
800068fc:	02f737b3          	mulhu	a5,a4,a5
80006900:	8389                	srli	a5,a5,0x2
80006902:	06478793          	addi	a5,a5,100
80006906:	4752                	lw	a4,20(sp)
80006908:	02f75733          	divu	a4,a4,a5
8000690c:	87ba                	mv	a5,a4
8000690e:	078a                	slli	a5,a5,0x2
80006910:	97ba                	add	a5,a5,a4
80006912:	00279713          	slli	a4,a5,0x2
80006916:	97ba                	add	a5,a5,a4
80006918:	078a                	slli	a5,a5,0x2
8000691a:	ce3e                	sw	a5,28(sp)

8000691c <.L41>:
    }

    return postdiv_freq;
8000691c:	47f2                	lw	a5,28(sp)
}
8000691e:	853e                	mv	a0,a5
80006920:	50b2                	lw	ra,44(sp)
80006922:	6145                	addi	sp,sp,48
80006924:	8082                	ret

Disassembly of section .text.pcfg_dcdc_set_voltage:

80006926 <pcfg_dcdc_set_voltage>:

    return PCFG_DCDC_CURRENT_LEVEL_GET(ptr->DCDC_CURRENT) * PCFG_CURRENT_MEASUREMENT_STEP;
}

hpm_stat_t pcfg_dcdc_set_voltage(PCFG_Type *ptr, uint16_t mv)
{
80006926:	1101                	addi	sp,sp,-32
80006928:	c62a                	sw	a0,12(sp)
8000692a:	87ae                	mv	a5,a1
8000692c:	00f11523          	sh	a5,10(sp)
    hpm_stat_t stat = status_success;
80006930:	ce02                	sw	zero,28(sp)
    if ((mv < PCFG_SOC_DCDC_MIN_VOLTAGE_IN_MV) || (mv > PCFG_SOC_DCDC_MAX_VOLTAGE_IN_MV)) {
80006932:	00a15703          	lhu	a4,10(sp)
80006936:	25700793          	li	a5,599
8000693a:	00e7f863          	bgeu	a5,a4,8000694a <.L26>
8000693e:	00a15703          	lhu	a4,10(sp)
80006942:	55f00793          	li	a5,1375
80006946:	00e7f463          	bgeu	a5,a4,8000694e <.L27>

8000694a <.L26>:
        return status_invalid_argument;
8000694a:	4789                	li	a5,2
8000694c:	a831                	j	80006968 <.L28>

8000694e <.L27>:
    }
    ptr->DCDC_MODE = (ptr->DCDC_MODE & ~PCFG_DCDC_MODE_VOLT_MASK) | PCFG_DCDC_MODE_VOLT_SET(mv);
8000694e:	47b2                	lw	a5,12(sp)
80006950:	4b98                	lw	a4,16(a5)
80006952:	77fd                	lui	a5,0xfffff
80006954:	8f7d                	and	a4,a4,a5
80006956:	00a15683          	lhu	a3,10(sp)
8000695a:	6785                	lui	a5,0x1
8000695c:	17fd                	addi	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
8000695e:	8ff5                	and	a5,a5,a3
80006960:	8f5d                	or	a4,a4,a5
80006962:	47b2                	lw	a5,12(sp)
80006964:	cb98                	sw	a4,16(a5)
    return stat;
80006966:	47f2                	lw	a5,28(sp)

80006968 <.L28>:
}
80006968:	853e                	mv	a0,a5
8000696a:	6105                	addi	sp,sp,32
8000696c:	8082                	ret

Disassembly of section .text.console_init:

8000696e <console_init>:
#include "hpm_uart_drv.h"

static UART_Type* g_console_uart = NULL;

hpm_stat_t console_init(console_config_t *cfg)
{
8000696e:	7139                	addi	sp,sp,-64
80006970:	de06                	sw	ra,60(sp)
80006972:	c62a                	sw	a0,12(sp)
    hpm_stat_t stat = status_fail;
80006974:	4785                	li	a5,1
80006976:	d63e                	sw	a5,44(sp)

    /* disable buffer in standard library */
    setvbuf(stdin, NULL, _IONBF, 0);
80006978:	000807b7          	lui	a5,0x80
8000697c:	3507a783          	lw	a5,848(a5) # 80350 <stdin>
80006980:	4681                	li	a3,0
80006982:	4609                	li	a2,2
80006984:	4581                	li	a1,0
80006986:	853e                	mv	a0,a5
80006988:	24b9                	jal	80006bd6 <setvbuf>
    setvbuf(stdout, NULL, _IONBF, 0);
8000698a:	000807b7          	lui	a5,0x80
8000698e:	34c7a783          	lw	a5,844(a5) # 8034c <stdout>
80006992:	4681                	li	a3,0
80006994:	4609                	li	a2,2
80006996:	4581                	li	a1,0
80006998:	853e                	mv	a0,a5
8000699a:	2c35                	jal	80006bd6 <setvbuf>

    if (cfg->type == CONSOLE_TYPE_UART) {
8000699c:	47b2                	lw	a5,12(sp)
8000699e:	439c                	lw	a5,0(a5)
800069a0:	e7b9                	bnez	a5,800069ee <.L2>

800069a2 <.LBB2>:
        uart_config_t config = {0};
800069a2:	c802                	sw	zero,16(sp)
800069a4:	ca02                	sw	zero,20(sp)
800069a6:	cc02                	sw	zero,24(sp)
800069a8:	ce02                	sw	zero,28(sp)
800069aa:	d002                	sw	zero,32(sp)
800069ac:	d202                	sw	zero,36(sp)
800069ae:	d402                	sw	zero,40(sp)
        uart_default_config((UART_Type *)cfg->base, &config);
800069b0:	47b2                	lw	a5,12(sp)
800069b2:	43dc                	lw	a5,4(a5)
800069b4:	873e                	mv	a4,a5
800069b6:	081c                	addi	a5,sp,16
800069b8:	85be                	mv	a1,a5
800069ba:	853a                	mv	a0,a4
800069bc:	3e9d                	jal	80006532 <uart_default_config>
        config.src_freq_in_hz = cfg->src_freq_in_hz;
800069be:	47b2                	lw	a5,12(sp)
800069c0:	479c                	lw	a5,8(a5)
800069c2:	c83e                	sw	a5,16(sp)
        config.baudrate = cfg->baudrate;
800069c4:	47b2                	lw	a5,12(sp)
800069c6:	47dc                	lw	a5,12(a5)
800069c8:	ca3e                	sw	a5,20(sp)
        stat = uart_init((UART_Type *)cfg->base, &config);
800069ca:	47b2                	lw	a5,12(sp)
800069cc:	43dc                	lw	a5,4(a5)
800069ce:	873e                	mv	a4,a5
800069d0:	081c                	addi	a5,sp,16
800069d2:	85be                	mv	a1,a5
800069d4:	853a                	mv	a0,a4
800069d6:	91dfd0ef          	jal	800042f2 <uart_init>
800069da:	d62a                	sw	a0,44(sp)
        if (status_success == stat) {
800069dc:	57b2                	lw	a5,44(sp)
800069de:	eb81                	bnez	a5,800069ee <.L2>
            g_console_uart = (UART_Type *)cfg->base;
800069e0:	47b2                	lw	a5,12(sp)
800069e2:	43dc                	lw	a5,4(a5)
800069e4:	873e                	mv	a4,a5
800069e6:	000807b7          	lui	a5,0x80
800069ea:	32e7ae23          	sw	a4,828(a5) # 8033c <g_console_uart>

800069ee <.L2>:
        }
    }

    return stat;
800069ee:	57b2                	lw	a5,44(sp)
}
800069f0:	853e                	mv	a0,a5
800069f2:	50f2                	lw	ra,60(sp)
800069f4:	6121                	addi	sp,sp,64
800069f6:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_write:

800069f8 <__SEGGER_RTL_X_file_write>:
__attribute__((used)) FILE *stdin  = &__SEGGER_RTL_stdin_file;  /* NOTE: Provide implementation of stdin for RTL. */
__attribute__((used)) FILE *stdout = &__SEGGER_RTL_stdout_file; /* NOTE: Provide implementation of stdout for RTL. */
__attribute__((used)) FILE *stderr = &__SEGGER_RTL_stderr_file; /* NOTE: Provide implementation of stderr for RTL. */

__attribute__((used)) int __SEGGER_RTL_X_file_write(__SEGGER_RTL_FILE *file, const char *data, unsigned int size)
{
800069f8:	7179                	addi	sp,sp,-48
800069fa:	d606                	sw	ra,44(sp)
800069fc:	c62a                	sw	a0,12(sp)
800069fe:	c42e                	sw	a1,8(sp)
80006a00:	c232                	sw	a2,4(sp)
    unsigned int count;
    (void)file;
    for (count = 0; count < size; count++) {
80006a02:	ce02                	sw	zero,28(sp)
80006a04:	a0b9                	j	80006a52 <.L13>

80006a06 <.L17>:
        if (data[count] == '\n') {
80006a06:	4722                	lw	a4,8(sp)
80006a08:	47f2                	lw	a5,28(sp)
80006a0a:	97ba                	add	a5,a5,a4
80006a0c:	0007c703          	lbu	a4,0(a5)
80006a10:	47a9                	li	a5,10
80006a12:	00f71d63          	bne	a4,a5,80006a2c <.L20>
            while (status_success != uart_send_byte(g_console_uart, '\r')) {
80006a16:	0001                	nop

80006a18 <.L15>:
80006a18:	000807b7          	lui	a5,0x80
80006a1c:	33c7a783          	lw	a5,828(a5) # 8033c <g_console_uart>
80006a20:	45b5                	li	a1,13
80006a22:	853e                	mv	a0,a5
80006a24:	a99fd0ef          	jal	800044bc <uart_send_byte>
80006a28:	87aa                	mv	a5,a0
80006a2a:	f7fd                	bnez	a5,80006a18 <.L15>

80006a2c <.L20>:
            }
        }
        while (status_success != uart_send_byte(g_console_uart, data[count])) {
80006a2c:	0001                	nop

80006a2e <.L16>:
80006a2e:	000807b7          	lui	a5,0x80
80006a32:	33c7a683          	lw	a3,828(a5) # 8033c <g_console_uart>
80006a36:	4722                	lw	a4,8(sp)
80006a38:	47f2                	lw	a5,28(sp)
80006a3a:	97ba                	add	a5,a5,a4
80006a3c:	0007c783          	lbu	a5,0(a5)
80006a40:	85be                	mv	a1,a5
80006a42:	8536                	mv	a0,a3
80006a44:	a79fd0ef          	jal	800044bc <uart_send_byte>
80006a48:	87aa                	mv	a5,a0
80006a4a:	f3f5                	bnez	a5,80006a2e <.L16>
    for (count = 0; count < size; count++) {
80006a4c:	47f2                	lw	a5,28(sp)
80006a4e:	0785                	addi	a5,a5,1
80006a50:	ce3e                	sw	a5,28(sp)

80006a52 <.L13>:
80006a52:	4772                	lw	a4,28(sp)
80006a54:	4792                	lw	a5,4(sp)
80006a56:	faf768e3          	bltu	a4,a5,80006a06 <.L17>
        }
    }
    while (status_success != uart_flush(g_console_uart)) {
80006a5a:	0001                	nop

80006a5c <.L18>:
80006a5c:	000807b7          	lui	a5,0x80
80006a60:	33c7a783          	lw	a5,828(a5) # 8033c <g_console_uart>
80006a64:	853e                	mv	a0,a5
80006a66:	3685                	jal	800065c6 <uart_flush>
80006a68:	87aa                	mv	a5,a0
80006a6a:	fbed                	bnez	a5,80006a5c <.L18>
    }
    return count;
80006a6c:	47f2                	lw	a5,28(sp)

}
80006a6e:	853e                	mv	a0,a5
80006a70:	50b2                	lw	ra,44(sp)
80006a72:	6145                	addi	sp,sp,48
80006a74:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_stat:

80006a76 <__SEGGER_RTL_X_file_stat>:
    }
    return 1;
}

__attribute__((used)) int __SEGGER_RTL_X_file_stat(__SEGGER_RTL_FILE *stream)
{
80006a76:	1141                	addi	sp,sp,-16
80006a78:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 0;
80006a7a:	4781                	li	a5,0
}
80006a7c:	853e                	mv	a0,a5
80006a7e:	0141                	addi	sp,sp,16
80006a80:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_bufsize:

80006a82 <__SEGGER_RTL_X_file_bufsize>:

__attribute__((used)) int __SEGGER_RTL_X_file_bufsize(__SEGGER_RTL_FILE *stream)
{
80006a82:	1141                	addi	sp,sp,-16
80006a84:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 1;
80006a86:	4785                	li	a5,1
}
80006a88:	853e                	mv	a0,a5
80006a8a:	0141                	addi	sp,sp,16
80006a8c:	8082                	ret

Disassembly of section .text.libc.__riscv_save_12:

80006a8e <__riscv_save_12>:
80006a8e:	7139                	addi	sp,sp,-64
80006a90:	4301                	li	t1,0
80006a92:	c66e                	sw	s11,12(sp)
80006a94:	a019                	j	80006a9a <.L__riscv_save_s10_down>

80006a96 <__riscv_save_10>:
80006a96:	7139                	addi	sp,sp,-64
80006a98:	4341                	li	t1,16

80006a9a <.L__riscv_save_s10_down>:
80006a9a:	c86a                	sw	s10,16(sp)
80006a9c:	ca66                	sw	s9,20(sp)
80006a9e:	cc62                	sw	s8,24(sp)
80006aa0:	ce5e                	sw	s7,28(sp)
80006aa2:	a021                	j	80006aaa <.L__riscv_save_s6_down>

80006aa4 <__riscv_save_4>:
80006aa4:	7139                	addi	sp,sp,-64
80006aa6:	02000313          	li	t1,32

80006aaa <.L__riscv_save_s6_down>:
80006aaa:	d05a                	sw	s6,32(sp)
80006aac:	d256                	sw	s5,36(sp)
80006aae:	d452                	sw	s4,40(sp)
80006ab0:	d64e                	sw	s3,44(sp)
80006ab2:	d84a                	sw	s2,48(sp)
80006ab4:	da26                	sw	s1,52(sp)
80006ab6:	dc22                	sw	s0,56(sp)
80006ab8:	de06                	sw	ra,60(sp)
80006aba:	911a                	add	sp,sp,t1
80006abc:	8282                	jr	t0

Disassembly of section .text.libc.__riscv_restore_12:

80006abe <__riscv_restore_12>:
80006abe:	4db2                	lw	s11,12(sp)
80006ac0:	0141                	addi	sp,sp,16

80006ac2 <__riscv_restore_11>:
80006ac2:	4d02                	lw	s10,0(sp)

80006ac4 <__riscv_restore_10>:
80006ac4:	4c92                	lw	s9,4(sp)

80006ac6 <__riscv_restore_9>:
80006ac6:	4c22                	lw	s8,8(sp)

80006ac8 <__riscv_restore_8>:
80006ac8:	4bb2                	lw	s7,12(sp)
80006aca:	0141                	addi	sp,sp,16

80006acc <__riscv_restore_7>:
80006acc:	4b02                	lw	s6,0(sp)

80006ace <__riscv_restore_6>:
80006ace:	4a92                	lw	s5,4(sp)

80006ad0 <__riscv_restore_5>:
80006ad0:	4a22                	lw	s4,8(sp)

80006ad2 <__riscv_restore_4>:
80006ad2:	49b2                	lw	s3,12(sp)
80006ad4:	0141                	addi	sp,sp,16

80006ad6 <__riscv_restore_3>:
80006ad6:	4902                	lw	s2,0(sp)

80006ad8 <__riscv_restore_2>:
80006ad8:	4492                	lw	s1,4(sp)

80006ada <__riscv_restore_1>:
80006ada:	4422                	lw	s0,8(sp)

80006adc <__riscv_restore_0>:
80006adc:	40b2                	lw	ra,12(sp)
80006ade:	0141                	addi	sp,sp,16
80006ae0:	8082                	ret

Disassembly of section .text.libc.itoa:

80006ae2 <itoa>:
80006ae2:	1141                	addi	sp,sp,-16
80006ae4:	c606                	sw	ra,12(sp)
80006ae6:	c422                	sw	s0,8(sp)
80006ae8:	842e                	mv	s0,a1
80006aea:	00055963          	bgez	a0,80006afc <itoa+0x1a>
80006aee:	45a9                	li	a1,10
80006af0:	00b61663          	bne	a2,a1,80006afc <itoa+0x1a>
80006af4:	4629                	li	a2,10
80006af6:	4685                	li	a3,1
80006af8:	85a2                	mv	a1,s0
80006afa:	a019                	j	80006b00 <itoa+0x1e>
80006afc:	85a2                	mv	a1,s0
80006afe:	4681                	li	a3,0
80006b00:	b87fd0ef          	jal	80004686 <__SEGGER_RTL_xtoa>
80006b04:	8522                	mv	a0,s0
80006b06:	40b2                	lw	ra,12(sp)
80006b08:	4422                	lw	s0,8(sp)
80006b0a:	0141                	addi	sp,sp,16
80006b0c:	8082                	ret

Disassembly of section .text.libc.abort:

80006b0e <abort>:
80006b0e:	1141                	addi	sp,sp,-16
80006b10:	c606                	sw	ra,12(sp)
80006b12:	4501                	li	a0,0
80006b14:	2011                	jal	80006b18 <raise>
80006b16:	bff5                	j	80006b12 <abort+0x4>

Disassembly of section .text.libc.raise:

80006b18 <raise>:
80006b18:	1141                	addi	sp,sp,-16
80006b1a:	c606                	sw	ra,12(sp)
80006b1c:	4615                	li	a2,5
80006b1e:	55fd                	li	a1,-1
80006b20:	04a66163          	bltu	a2,a0,80006b62 <raise+0x4a>
80006b24:	00251693          	slli	a3,a0,0x2
80006b28:	00080637          	lui	a2,0x80
80006b2c:	31460613          	addi	a2,a2,788 # 80314 <__SEGGER_RTL_aSigTab>
80006b30:	96b2                	add	a3,a3,a2
80006b32:	4290                	lw	a2,0(a3)
80006b34:	80004737          	lui	a4,0x80004
80006b38:	74270713          	addi	a4,a4,1858 # 80004742 <__SEGGER_RTL_SIGNAL_SIG_IGN>
80006b3c:	c298                	sw	a4,0(a3)
80006b3e:	c615                	beqz	a2,80006b6a <raise+0x52>
80006b40:	800047b7          	lui	a5,0x80004
80006b44:	80e78793          	addi	a5,a5,-2034 # 8000380e <__SEGGER_RTL_SIGNAL_SIG_ERR>
80006b48:	00f60d63          	beq	a2,a5,80006b62 <raise+0x4a>
80006b4c:	00e60a63          	beq	a2,a4,80006b60 <raise+0x48>
80006b50:	800035b7          	lui	a1,0x80003
80006b54:	06658593          	addi	a1,a1,102 # 80003066 <__SEGGER_RTL_SIGNAL_SIG_DFL>
80006b58:	00b60963          	beq	a2,a1,80006b6a <raise+0x52>
80006b5c:	c28c                	sw	a1,0(a3)
80006b5e:	9602                	jalr	a2
80006b60:	4581                	li	a1,0
80006b62:	852e                	mv	a0,a1
80006b64:	40b2                	lw	ra,12(sp)
80006b66:	0141                	addi	sp,sp,16
80006b68:	8082                	ret
80006b6a:	4505                	li	a0,1
80006b6c:	cecfc0ef          	jal	80003058 <exit>

Disassembly of section .text.libc.__SEGGER_RTL_puts_no_nl:

80006b70 <__SEGGER_RTL_puts_no_nl>:
80006b70:	1141                	addi	sp,sp,-16
80006b72:	c606                	sw	ra,12(sp)
80006b74:	c422                	sw	s0,8(sp)
80006b76:	c226                	sw	s1,4(sp)
80006b78:	000805b7          	lui	a1,0x80
80006b7c:	34c5a403          	lw	s0,844(a1) # 8034c <stdout>
80006b80:	84aa                	mv	s1,a0
80006b82:	69b000ef          	jal	80007a1c <strlen>
80006b86:	862a                	mv	a2,a0
80006b88:	8522                	mv	a0,s0
80006b8a:	85a6                	mv	a1,s1
80006b8c:	40b2                	lw	ra,12(sp)
80006b8e:	4422                	lw	s0,8(sp)
80006b90:	4492                	lw	s1,4(sp)
80006b92:	0141                	addi	sp,sp,16
80006b94:	b595                	j	800069f8 <__SEGGER_RTL_X_file_write>

Disassembly of section .text.libc.fwrite:

80006b96 <fwrite>:
80006b96:	1101                	addi	sp,sp,-32
80006b98:	ce06                	sw	ra,28(sp)
80006b9a:	cc22                	sw	s0,24(sp)
80006b9c:	ca26                	sw	s1,20(sp)
80006b9e:	c84a                	sw	s2,16(sp)
80006ba0:	c64e                	sw	s3,12(sp)
80006ba2:	84b6                	mv	s1,a3
80006ba4:	89b2                	mv	s3,a2
80006ba6:	842e                	mv	s0,a1
80006ba8:	892a                	mv	s2,a0
80006baa:	8536                	mv	a0,a3
80006bac:	35e9                	jal	80006a76 <__SEGGER_RTL_X_file_stat>
80006bae:	00054663          	bltz	a0,80006bba <fwrite+0x24>
80006bb2:	02898633          	mul	a2,s3,s0
80006bb6:	00867463          	bgeu	a2,s0,80006bbe <fwrite+0x28>
80006bba:	4501                	li	a0,0
80006bbc:	a031                	j	80006bc8 <fwrite+0x32>
80006bbe:	8526                	mv	a0,s1
80006bc0:	85ca                	mv	a1,s2
80006bc2:	3d1d                	jal	800069f8 <__SEGGER_RTL_X_file_write>
80006bc4:	02855533          	divu	a0,a0,s0
80006bc8:	40f2                	lw	ra,28(sp)
80006bca:	4462                	lw	s0,24(sp)
80006bcc:	44d2                	lw	s1,20(sp)
80006bce:	4942                	lw	s2,16(sp)
80006bd0:	49b2                	lw	s3,12(sp)
80006bd2:	6105                	addi	sp,sp,32
80006bd4:	8082                	ret

Disassembly of section .text.libc.setvbuf:

80006bd6 <setvbuf>:
80006bd6:	4501                	li	a0,0
80006bd8:	8082                	ret

Disassembly of section .text.libc.__mulsf3:

80006bda <__mulsf3>:
80006bda:	80000737          	lui	a4,0x80000
80006bde:	0ff00293          	li	t0,255
80006be2:	00b547b3          	xor	a5,a0,a1
80006be6:	8ff9                	and	a5,a5,a4
80006be8:	00151613          	slli	a2,a0,0x1
80006bec:	8261                	srli	a2,a2,0x18
80006bee:	00159693          	slli	a3,a1,0x1
80006bf2:	82e1                	srli	a3,a3,0x18
80006bf4:	ce29                	beqz	a2,80006c4e <.L__mulsf3_lhs_zero_or_subnormal>
80006bf6:	c6bd                	beqz	a3,80006c64 <.L__mulsf3_rhs_zero_or_subnormal>
80006bf8:	04560f63          	beq	a2,t0,80006c56 <.L__mulsf3_lhs_inf_or_nan>
80006bfc:	06568963          	beq	a3,t0,80006c6e <.L__mulsf3_rhs_inf_or_nan>
80006c00:	9636                	add	a2,a2,a3
80006c02:	0522                	slli	a0,a0,0x8
80006c04:	8d59                	or	a0,a0,a4
80006c06:	05a2                	slli	a1,a1,0x8
80006c08:	8dd9                	or	a1,a1,a4
80006c0a:	02b506b3          	mul	a3,a0,a1
80006c0e:	02b53533          	mulhu	a0,a0,a1
80006c12:	00d036b3          	snez	a3,a3
80006c16:	8d55                	or	a0,a0,a3
80006c18:	00054463          	bltz	a0,80006c20 <.L__mulsf3_normalized>
80006c1c:	0506                	slli	a0,a0,0x1
80006c1e:	167d                	addi	a2,a2,-1

80006c20 <.L__mulsf3_normalized>:
80006c20:	f8160613          	addi	a2,a2,-127
80006c24:	04064863          	bltz	a2,80006c74 <.L__mulsf3_zero_or_underflow>
80006c28:	12fd                	addi	t0,t0,-1 # ffffffff <__AHB_SRAM_segment_end__+0xfbf7fff>
80006c2a:	00565f63          	bge	a2,t0,80006c48 <.L__mulsf3_inf>
80006c2e:	01851693          	slli	a3,a0,0x18
80006c32:	8121                	srli	a0,a0,0x8
80006c34:	065e                	slli	a2,a2,0x17
80006c36:	9532                	add	a0,a0,a2
80006c38:	0006d663          	bgez	a3,80006c44 <.L__mulsf3_apply_sign>
80006c3c:	0505                	addi	a0,a0,1 # 1020001 <_flash_size+0xf20001>
80006c3e:	0686                	slli	a3,a3,0x1
80006c40:	e291                	bnez	a3,80006c44 <.L__mulsf3_apply_sign>
80006c42:	9979                	andi	a0,a0,-2

80006c44 <.L__mulsf3_apply_sign>:
80006c44:	8d5d                	or	a0,a0,a5
80006c46:	8082                	ret

80006c48 <.L__mulsf3_inf>:
80006c48:	7f800537          	lui	a0,0x7f800
80006c4c:	bfe5                	j	80006c44 <.L__mulsf3_apply_sign>

80006c4e <.L__mulsf3_lhs_zero_or_subnormal>:
80006c4e:	00568d63          	beq	a3,t0,80006c68 <.L__mulsf3_nan>

80006c52 <.L__mulsf3_signed_zero>:
80006c52:	853e                	mv	a0,a5
80006c54:	8082                	ret

80006c56 <.L__mulsf3_lhs_inf_or_nan>:
80006c56:	0526                	slli	a0,a0,0x9
80006c58:	e901                	bnez	a0,80006c68 <.L__mulsf3_nan>
80006c5a:	fe5697e3          	bne	a3,t0,80006c48 <.L__mulsf3_inf>
80006c5e:	05a6                	slli	a1,a1,0x9
80006c60:	e581                	bnez	a1,80006c68 <.L__mulsf3_nan>
80006c62:	b7dd                	j	80006c48 <.L__mulsf3_inf>

80006c64 <.L__mulsf3_rhs_zero_or_subnormal>:
80006c64:	fe5617e3          	bne	a2,t0,80006c52 <.L__mulsf3_signed_zero>

80006c68 <.L__mulsf3_nan>:
80006c68:	7fc00537          	lui	a0,0x7fc00
80006c6c:	8082                	ret

80006c6e <.L__mulsf3_rhs_inf_or_nan>:
80006c6e:	05a6                	slli	a1,a1,0x9
80006c70:	fde5                	bnez	a1,80006c68 <.L__mulsf3_nan>
80006c72:	bfd9                	j	80006c48 <.L__mulsf3_inf>

80006c74 <.L__mulsf3_zero_or_underflow>:
80006c74:	0605                	addi	a2,a2,1
80006c76:	fe71                	bnez	a2,80006c52 <.L__mulsf3_signed_zero>
80006c78:	8521                	srai	a0,a0,0x8
80006c7a:	00150293          	addi	t0,a0,1 # 7fc00001 <_flash_size+0x7fb00001>
80006c7e:	0509                	addi	a0,a0,2
80006c80:	fc0299e3          	bnez	t0,80006c52 <.L__mulsf3_signed_zero>
80006c84:	00800537          	lui	a0,0x800
80006c88:	bf75                	j	80006c44 <.L__mulsf3_apply_sign>

Disassembly of section .text.libc.__divsf3:

80006c8a <__divsf3>:
80006c8a:	0ff00293          	li	t0,255
80006c8e:	00151713          	slli	a4,a0,0x1
80006c92:	8361                	srli	a4,a4,0x18
80006c94:	00159793          	slli	a5,a1,0x1
80006c98:	83e1                	srli	a5,a5,0x18
80006c9a:	00b54333          	xor	t1,a0,a1
80006c9e:	01f35313          	srli	t1,t1,0x1f
80006ca2:	037e                	slli	t1,t1,0x1f
80006ca4:	cf4d                	beqz	a4,80006d5e <.L__divsf3_lhs_zero_or_subnormal>
80006ca6:	cbe9                	beqz	a5,80006d78 <.L__divsf3_rhs_zero_or_subnormal>
80006ca8:	0c570363          	beq	a4,t0,80006d6e <.L__divsf3_lhs_inf_or_nan>
80006cac:	0c578b63          	beq	a5,t0,80006d82 <.L__divsf3_rhs_inf_or_nan>
80006cb0:	8f1d                	sub	a4,a4,a5

80006cb2 <.Lpcrel_hi0>:
80006cb2:	d0018293          	addi	t0,gp,-768 # 80003590 <__SEGGER_RTL_fdiv_reciprocal_table>
80006cb6:	00f5d693          	srli	a3,a1,0xf
80006cba:	0fc6f693          	andi	a3,a3,252
80006cbe:	9696                	add	a3,a3,t0
80006cc0:	429c                	lw	a5,0(a3)
80006cc2:	4187d613          	srai	a2,a5,0x18
80006cc6:	00f59693          	slli	a3,a1,0xf
80006cca:	82e1                	srli	a3,a3,0x18
80006ccc:	0016f293          	andi	t0,a3,1
80006cd0:	8285                	srli	a3,a3,0x1
80006cd2:	fc068693          	addi	a3,a3,-64
80006cd6:	9696                	add	a3,a3,t0
80006cd8:	02d60633          	mul	a2,a2,a3
80006cdc:	07a2                	slli	a5,a5,0x8
80006cde:	83a1                	srli	a5,a5,0x8
80006ce0:	963e                	add	a2,a2,a5
80006ce2:	05a2                	slli	a1,a1,0x8
80006ce4:	81a1                	srli	a1,a1,0x8
80006ce6:	008007b7          	lui	a5,0x800
80006cea:	8ddd                	or	a1,a1,a5
80006cec:	02c586b3          	mul	a3,a1,a2
80006cf0:	0522                	slli	a0,a0,0x8
80006cf2:	8121                	srli	a0,a0,0x8
80006cf4:	8d5d                	or	a0,a0,a5
80006cf6:	02c697b3          	mulh	a5,a3,a2
80006cfa:	00b532b3          	sltu	t0,a0,a1
80006cfe:	00551533          	sll	a0,a0,t0
80006d02:	40570733          	sub	a4,a4,t0
80006d06:	01465693          	srli	a3,a2,0x14
80006d0a:	8a85                	andi	a3,a3,1
80006d0c:	0016c693          	xori	a3,a3,1
80006d10:	062e                	slli	a2,a2,0xb
80006d12:	8e1d                	sub	a2,a2,a5
80006d14:	8e15                	sub	a2,a2,a3
80006d16:	050a                	slli	a0,a0,0x2
80006d18:	02a617b3          	mulh	a5,a2,a0
80006d1c:	07e70613          	addi	a2,a4,126 # 8000007e <_flash_size+0x7ff0007e>
80006d20:	055a                	slli	a0,a0,0x16
80006d22:	8d0d                	sub	a0,a0,a1
80006d24:	02b786b3          	mul	a3,a5,a1
80006d28:	0fe00293          	li	t0,254
80006d2c:	00567f63          	bgeu	a2,t0,80006d4a <.L__divsf3_underflow_or_overflow>
80006d30:	40a68533          	sub	a0,a3,a0
80006d34:	000522b3          	sltz	t0,a0
80006d38:	9796                	add	a5,a5,t0
80006d3a:	0017f513          	andi	a0,a5,1
80006d3e:	8385                	srli	a5,a5,0x1
80006d40:	953e                	add	a0,a0,a5
80006d42:	065e                	slli	a2,a2,0x17
80006d44:	9532                	add	a0,a0,a2
80006d46:	951a                	add	a0,a0,t1
80006d48:	8082                	ret

80006d4a <.L__divsf3_underflow_or_overflow>:
80006d4a:	851a                	mv	a0,t1
80006d4c:	00564563          	blt	a2,t0,80006d56 <.L__divsf3_done>
80006d50:	7f800337          	lui	t1,0x7f800

80006d54 <.L__divsf3_apply_sign>:
80006d54:	951a                	add	a0,a0,t1

80006d56 <.L__divsf3_done>:
80006d56:	8082                	ret

80006d58 <.L__divsf3_inf>:
80006d58:	7f800537          	lui	a0,0x7f800
80006d5c:	bfe5                	j	80006d54 <.L__divsf3_apply_sign>

80006d5e <.L__divsf3_lhs_zero_or_subnormal>:
80006d5e:	c789                	beqz	a5,80006d68 <.L__divsf3_nan>
80006d60:	02579363          	bne	a5,t0,80006d86 <.L__divsf3_signed_zero>
80006d64:	05a6                	slli	a1,a1,0x9
80006d66:	c185                	beqz	a1,80006d86 <.L__divsf3_signed_zero>

80006d68 <.L__divsf3_nan>:
80006d68:	7fc00537          	lui	a0,0x7fc00
80006d6c:	8082                	ret

80006d6e <.L__divsf3_lhs_inf_or_nan>:
80006d6e:	0526                	slli	a0,a0,0x9
80006d70:	fd65                	bnez	a0,80006d68 <.L__divsf3_nan>
80006d72:	fe5793e3          	bne	a5,t0,80006d58 <.L__divsf3_inf>
80006d76:	bfcd                	j	80006d68 <.L__divsf3_nan>

80006d78 <.L__divsf3_rhs_zero_or_subnormal>:
80006d78:	fe5710e3          	bne	a4,t0,80006d58 <.L__divsf3_inf>
80006d7c:	0526                	slli	a0,a0,0x9
80006d7e:	f56d                	bnez	a0,80006d68 <.L__divsf3_nan>
80006d80:	bfe1                	j	80006d58 <.L__divsf3_inf>

80006d82 <.L__divsf3_rhs_inf_or_nan>:
80006d82:	05a6                	slli	a1,a1,0x9
80006d84:	f1f5                	bnez	a1,80006d68 <.L__divsf3_nan>

80006d86 <.L__divsf3_signed_zero>:
80006d86:	851a                	mv	a0,t1
80006d88:	8082                	ret

Disassembly of section .text.libc.__eqsf2:

80006d8a <__eqsf2>:
80006d8a:	ff000637          	lui	a2,0xff000
80006d8e:	00151693          	slli	a3,a0,0x1
80006d92:	02d66063          	bltu	a2,a3,80006db2 <.L__eqsf2_one>
80006d96:	00159693          	slli	a3,a1,0x1
80006d9a:	00d66c63          	bltu	a2,a3,80006db2 <.L__eqsf2_one>
80006d9e:	00b56633          	or	a2,a0,a1
80006da2:	0606                	slli	a2,a2,0x1
80006da4:	c609                	beqz	a2,80006dae <.L__eqsf2_zero>
80006da6:	8d0d                	sub	a0,a0,a1
80006da8:	00a03533          	snez	a0,a0
80006dac:	8082                	ret

80006dae <.L__eqsf2_zero>:
80006dae:	4501                	li	a0,0
80006db0:	8082                	ret

80006db2 <.L__eqsf2_one>:
80006db2:	4505                	li	a0,1
80006db4:	8082                	ret

Disassembly of section .text.libc.__fixunssfdi:

80006db6 <__fixunssfdi>:
80006db6:	04054a63          	bltz	a0,80006e0a <.L__fixunssfdi_zero_result>
80006dba:	00151613          	slli	a2,a0,0x1
80006dbe:	8261                	srli	a2,a2,0x18
80006dc0:	f8160613          	addi	a2,a2,-127 # feffff81 <__AHB_SRAM_segment_end__+0xebf7f81>
80006dc4:	04064363          	bltz	a2,80006e0a <.L__fixunssfdi_zero_result>
80006dc8:	800006b7          	lui	a3,0x80000
80006dcc:	02000293          	li	t0,32
80006dd0:	00565b63          	bge	a2,t0,80006de6 <.L__fixunssfdi_long_shift>
80006dd4:	40c00633          	neg	a2,a2
80006dd8:	067d                	addi	a2,a2,31
80006dda:	0522                	slli	a0,a0,0x8
80006ddc:	8d55                	or	a0,a0,a3
80006dde:	00c55533          	srl	a0,a0,a2
80006de2:	4581                	li	a1,0
80006de4:	8082                	ret

80006de6 <.L__fixunssfdi_long_shift>:
80006de6:	40c00633          	neg	a2,a2
80006dea:	03f60613          	addi	a2,a2,63
80006dee:	02064163          	bltz	a2,80006e10 <.L__fixunssfdi_overflow_result>
80006df2:	00851593          	slli	a1,a0,0x8
80006df6:	8dd5                	or	a1,a1,a3
80006df8:	4501                	li	a0,0
80006dfa:	c619                	beqz	a2,80006e08 <.L__fixunssfdi_shift_32>
80006dfc:	40c006b3          	neg	a3,a2
80006e00:	00d59533          	sll	a0,a1,a3
80006e04:	00c5d5b3          	srl	a1,a1,a2

80006e08 <.L__fixunssfdi_shift_32>:
80006e08:	8082                	ret

80006e0a <.L__fixunssfdi_zero_result>:
80006e0a:	4501                	li	a0,0
80006e0c:	4581                	li	a1,0
80006e0e:	8082                	ret

80006e10 <.L__fixunssfdi_overflow_result>:
80006e10:	557d                	li	a0,-1
80006e12:	55fd                	li	a1,-1
80006e14:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ldouble_to_double:

80006e16 <__SEGGER_RTL_ldouble_to_double>:
80006e16:	00169793          	slli	a5,a3,0x1
80006e1a:	453d                	li	a0,15
80006e1c:	83c5                	srli	a5,a5,0x11
80006e1e:	052a                	slli	a0,a0,0xa
80006e20:	80000837          	lui	a6,0x80000
80006e24:	00f56663          	bltu	a0,a5,80006e30 <__SEGGER_RTL_ldouble_to_double+0x1a>
80006e28:	4501                	li	a0,0
80006e2a:	0106f5b3          	and	a1,a3,a6
80006e2e:	8082                	ret
80006e30:	5545                	li	a0,-15
80006e32:	6711                	lui	a4,0x4
80006e34:	052a                	slli	a0,a0,0xa
80006e36:	953e                	add	a0,a0,a5
80006e38:	3ff70713          	addi	a4,a4,1023 # 43ff <__HEAPSIZE__+0x3ff>
80006e3c:	83a9                	srli	a5,a5,0xa
80006e3e:	00e50963          	beq	a0,a4,80006e50 <__SEGGER_RTL_ldouble_to_double+0x3a>
80006e42:	0117b713          	sltiu	a4,a5,17
80006e46:	40e00733          	neg	a4,a4
80006e4a:	8ef9                	and	a3,a3,a4
80006e4c:	8e79                	and	a2,a2,a4
80006e4e:	8df9                	and	a1,a1,a4
80006e50:	4741                	li	a4,16
80006e52:	00f77463          	bgeu	a4,a5,80006e5a <__SEGGER_RTL_ldouble_to_double+0x44>
80006e56:	7ff00513          	li	a0,2047
80006e5a:	0106f733          	and	a4,a3,a6
80006e5e:	0552                	slli	a0,a0,0x14
80006e60:	8d59                	or	a0,a0,a4
80006e62:	01c65713          	srli	a4,a2,0x1c
80006e66:	0692                	slli	a3,a3,0x4
80006e68:	0612                	slli	a2,a2,0x4
80006e6a:	01c5d793          	srli	a5,a1,0x1c
80006e6e:	8ed9                	or	a3,a3,a4
80006e70:	06b2                	slli	a3,a3,0xc
80006e72:	00c6d593          	srli	a1,a3,0xc
80006e76:	8dc9                	or	a1,a1,a0
80006e78:	00f66533          	or	a0,a2,a5
80006e7c:	8082                	ret

Disassembly of section .text.libc.__trunctfsf2:

80006e7e <__trunctfsf2>:
80006e7e:	1141                	addi	sp,sp,-16
80006e80:	c606                	sw	ra,12(sp)
80006e82:	4118                	lw	a4,0(a0)
80006e84:	414c                	lw	a1,4(a0)
80006e86:	4510                	lw	a2,8(a0)
80006e88:	4554                	lw	a3,12(a0)
80006e8a:	853a                	mv	a0,a4
80006e8c:	3769                	jal	80006e16 <__SEGGER_RTL_ldouble_to_double>
80006e8e:	bc1fd0ef          	jal	80004a4e <__truncdfsf2>
80006e92:	40b2                	lw	ra,12(sp)
80006e94:	0141                	addi	sp,sp,16
80006e96:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnan:

80006e98 <__SEGGER_RTL_float32_isnan>:
80006e98:	0506                	slli	a0,a0,0x1
80006e9a:	ff0005b7          	lui	a1,0xff000
80006e9e:	00a5b533          	sltu	a0,a1,a0
80006ea2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isinf:

80006ea4 <__SEGGER_RTL_float32_isinf>:
80006ea4:	0506                	slli	a0,a0,0x1
80006ea6:	8105                	srli	a0,a0,0x1
80006ea8:	7f8005b7          	lui	a1,0x7f800
80006eac:	8d2d                	xor	a0,a0,a1
80006eae:	00153513          	seqz	a0,a0
80006eb2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnormal:

80006eb4 <__SEGGER_RTL_float32_isnormal>:
80006eb4:	00151593          	slli	a1,a0,0x1
80006eb8:	7f800637          	lui	a2,0x7f800
80006ebc:	81e1                	srli	a1,a1,0x18
80006ebe:	8d71                	and	a0,a0,a2
80006ec0:	0ff5b593          	sltiu	a1,a1,255
80006ec4:	00a03533          	snez	a0,a0
80006ec8:	8d6d                	and	a0,a0,a1
80006eca:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_signbit:

80006ecc <__SEGGER_RTL_float32_signbit>:
80006ecc:	817d                	srli	a0,a0,0x1f
80006ece:	8082                	ret

Disassembly of section .text.libc.ldexpf:

80006ed0 <ldexpf>:
80006ed0:	00151613          	slli	a2,a0,0x1
80006ed4:	8261                	srli	a2,a2,0x18
80006ed6:	f0160693          	addi	a3,a2,-255 # 7f7fff01 <_flash_size+0x7f6fff01>
80006eda:	f0200713          	li	a4,-254
80006ede:	02e6ea63          	bltu	a3,a4,80006f12 <ldexpf+0x42>
80006ee2:	95b2                	add	a1,a1,a2
80006ee4:	fff58613          	addi	a2,a1,-1 # 7f7fffff <_flash_size+0x7f6fffff>
80006ee8:	0fd00693          	li	a3,253
80006eec:	00c6e963          	bltu	a3,a2,80006efe <ldexpf+0x2e>
80006ef0:	80800637          	lui	a2,0x80800
80006ef4:	167d                	addi	a2,a2,-1 # 807fffff <__FLASH_segment_end__+0x6fffff>
80006ef6:	8d71                	and	a0,a0,a2
80006ef8:	05de                	slli	a1,a1,0x17
80006efa:	8d4d                	or	a0,a0,a1
80006efc:	8082                	ret
80006efe:	0015a593          	slti	a1,a1,1
80006f02:	80000637          	lui	a2,0x80000
80006f06:	8d71                	and	a0,a0,a2
80006f08:	15fd                	addi	a1,a1,-1
80006f0a:	7f800637          	lui	a2,0x7f800
80006f0e:	8df1                	and	a1,a1,a2
80006f10:	8d4d                	or	a0,a0,a1
80006f12:	8082                	ret

Disassembly of section .text.libc.fmodf:

80006f14 <fmodf>:
80006f14:	b91ff2ef          	jal	t0,80006aa4 <__riscv_save_4>
80006f18:	84aa                	mv	s1,a0
80006f1a:	01755993          	srli	s3,a0,0x17
80006f1e:	fff98513          	addi	a0,s3,-1
80006f22:	0fd00613          	li	a2,253
80006f26:	0ea66363          	bltu	a2,a0,8000700c <fmodf+0xf8>
80006f2a:	0175d513          	srli	a0,a1,0x17
80006f2e:	f0150513          	addi	a0,a0,-255 # 7fbfff01 <_flash_size+0x7fafff01>
80006f32:	f0200613          	li	a2,-254
80006f36:	0cc56b63          	bltu	a0,a2,8000700c <fmodf+0xf8>
80006f3a:	00149413          	slli	s0,s1,0x1
80006f3e:	8005                	srli	s0,s0,0x1
80006f40:	80000537          	lui	a0,0x80000
80006f44:	00a4f933          	and	s2,s1,a0
80006f48:	1085f063          	bgeu	a1,s0,80007048 <fmodf+0x134>
80006f4c:	00800637          	lui	a2,0x800
80006f50:	0ff9f513          	zext.b	a0,s3
80006f54:	fff60693          	addi	a3,a2,-1 # 7fffff <_flash_size+0x6fffff>
80006f58:	c509                	beqz	a0,80006f62 <fmodf+0x4e>
80006f5a:	00d4f433          	and	s0,s1,a3
80006f5e:	8c51                	or	s0,s0,a2
80006f60:	a831                	j	80006f7c <fmodf+0x68>
80006f62:	01745513          	srli	a0,s0,0x17
80006f66:	e911                	bnez	a0,80006f7a <fmodf+0x66>
80006f68:	8622                	mv	a2,s0
80006f6a:	00161413          	slli	s0,a2,0x1
80006f6e:	01665713          	srli	a4,a2,0x16
80006f72:	157d                	addi	a0,a0,-1 # 7fffffff <_flash_size+0x7fefffff>
80006f74:	8622                	mv	a2,s0
80006f76:	db75                	beqz	a4,80006f6a <fmodf+0x56>
80006f78:	a011                	j	80006f7c <fmodf+0x68>
80006f7a:	4501                	li	a0,0
80006f7c:	00159613          	slli	a2,a1,0x1
80006f80:	8261                	srli	a2,a2,0x18
80006f82:	ca01                	beqz	a2,80006f92 <fmodf+0x7e>
80006f84:	8df5                	and	a1,a1,a3
80006f86:	008006b7          	lui	a3,0x800
80006f8a:	8dd5                	or	a1,a1,a3
80006f8c:	02a64063          	blt	a2,a0,80006fac <fmodf+0x98>
80006f90:	a081                	j	80006fd0 <fmodf+0xbc>
80006f92:	0175d613          	srli	a2,a1,0x17
80006f96:	ea15                	bnez	a2,80006fca <fmodf+0xb6>
80006f98:	86ae                	mv	a3,a1
80006f9a:	00169593          	slli	a1,a3,0x1
80006f9e:	0166d713          	srli	a4,a3,0x16
80006fa2:	167d                	addi	a2,a2,-1
80006fa4:	86ae                	mv	a3,a1
80006fa6:	db75                	beqz	a4,80006f9a <fmodf+0x86>
80006fa8:	02a65463          	bge	a2,a0,80006fd0 <fmodf+0xbc>
80006fac:	40b406b3          	sub	a3,s0,a1
80006fb0:	0006c563          	bltz	a3,80006fba <fmodf+0xa6>
80006fb4:	04b40a63          	beq	s0,a1,80007008 <fmodf+0xf4>
80006fb8:	a011                	j	80006fbc <fmodf+0xa8>
80006fba:	86a2                	mv	a3,s0
80006fbc:	157d                	addi	a0,a0,-1
80006fbe:	00169413          	slli	s0,a3,0x1
80006fc2:	fea645e3          	blt	a2,a0,80006fac <fmodf+0x98>
80006fc6:	8532                	mv	a0,a2
80006fc8:	a021                	j	80006fd0 <fmodf+0xbc>
80006fca:	4601                	li	a2,0
80006fcc:	fea040e3          	bgtz	a0,80006fac <fmodf+0x98>
80006fd0:	40b40633          	sub	a2,s0,a1
80006fd4:	00064563          	bltz	a2,80006fde <fmodf+0xca>
80006fd8:	00b41463          	bne	s0,a1,80006fe0 <fmodf+0xcc>
80006fdc:	a035                	j	80007008 <fmodf+0xf4>
80006fde:	8622                	mv	a2,s0
80006fe0:	01765593          	srli	a1,a2,0x17
80006fe4:	e989                	bnez	a1,80006ff6 <fmodf+0xe2>
80006fe6:	00161593          	slli	a1,a2,0x1
80006fea:	01665693          	srli	a3,a2,0x16
80006fee:	157d                	addi	a0,a0,-1
80006ff0:	862e                	mv	a2,a1
80006ff2:	daf5                	beqz	a3,80006fe6 <fmodf+0xd2>
80006ff4:	a011                	j	80006ff8 <fmodf+0xe4>
80006ff6:	85b2                	mv	a1,a2
80006ff8:	04a05c63          	blez	a0,80007050 <fmodf+0x13c>
80006ffc:	fff50613          	addi	a2,a0,-1
80007000:	065e                	slli	a2,a2,0x17
80007002:	964a                	add	a2,a2,s2
80007004:	00c58933          	add	s2,a1,a2
80007008:	854a                	mv	a0,s2
8000700a:	b4d9                	j	80006ad0 <__riscv_restore_5>
8000700c:	00149413          	slli	s0,s1,0x1
80007010:	ff000537          	lui	a0,0xff000
80007014:	02856c63          	bltu	a0,s0,8000704c <fmodf+0x138>
80007018:	00159a13          	slli	s4,a1,0x1
8000701c:	05456063          	bltu	a0,s4,8000705c <fmodf+0x148>
80007020:	8005                	srli	s0,s0,0x1
80007022:	7f800537          	lui	a0,0x7f800
80007026:	7fc00937          	lui	s2,0x7fc00
8000702a:	fca40fe3          	beq	s0,a0,80007008 <fmodf+0xf4>
8000702e:	e409                	bnez	s0,80007038 <fmodf+0x124>
80007030:	852e                	mv	a0,a1
80007032:	4581                	li	a1,0
80007034:	3b99                	jal	80006d8a <__eqsf2>
80007036:	e919                	bnez	a0,8000704c <fmodf+0x138>
80007038:	001a5593          	srli	a1,s4,0x1
8000703c:	d5f1                	beqz	a1,80007008 <fmodf+0xf4>
8000703e:	7f800537          	lui	a0,0x7f800
80007042:	eea59fe3          	bne	a1,a0,80006f40 <fmodf+0x2c>
80007046:	a019                	j	8000704c <fmodf+0x138>
80007048:	fc8580e3          	beq	a1,s0,80007008 <fmodf+0xf4>
8000704c:	8926                	mv	s2,s1
8000704e:	bf6d                	j	80007008 <fmodf+0xf4>
80007050:	4601                	li	a2,0
80007052:	4685                	li	a3,1
80007054:	8e89                	sub	a3,a3,a0
80007056:	00d5d5b3          	srl	a1,a1,a3
8000705a:	b75d                	j	80007000 <fmodf+0xec>
8000705c:	892e                	mv	s2,a1
8000705e:	b76d                	j	80007008 <fmodf+0xf4>

Disassembly of section .text.libc.floorf:

80007060 <floorf>:
80007060:	00151593          	slli	a1,a0,0x1
80007064:	81e1                	srli	a1,a1,0x18
80007066:	fff58613          	addi	a2,a1,-1
8000706a:	0fe00693          	li	a3,254
8000706e:	04d67963          	bgeu	a2,a3,800070c0 <floorf+0x60>
80007072:	07e00613          	li	a2,126
80007076:	00b66763          	bltu	a2,a1,80007084 <floorf+0x24>
8000707a:	857d                	srai	a0,a0,0x1f
8000707c:	bf8005b7          	lui	a1,0xbf800
80007080:	8d6d                	and	a0,a0,a1
80007082:	8082                	ret
80007084:	09500613          	li	a2,149
80007088:	02b66b63          	bltu	a2,a1,800070be <floorf+0x5e>
8000708c:	f8158593          	addi	a1,a1,-127 # bf7fff81 <__FLASH_segment_end__+0x3f6fff81>
80007090:	ff800637          	lui	a2,0xff800
80007094:	00052693          	slti	a3,a0,0
80007098:	40b65633          	sra	a2,a2,a1
8000709c:	8e69                	and	a2,a2,a0
8000709e:	00b51533          	sll	a0,a0,a1
800070a2:	0016c693          	xori	a3,a3,1
800070a6:	0526                	slli	a0,a0,0x9
800070a8:	8125                	srli	a0,a0,0x9
800070aa:	00153513          	seqz	a0,a0
800070ae:	8d55                	or	a0,a0,a3
800070b0:	008006b7          	lui	a3,0x800
800070b4:	00b6d5b3          	srl	a1,a3,a1
800070b8:	157d                	addi	a0,a0,-1 # 7f7fffff <_flash_size+0x7f6fffff>
800070ba:	8d6d                	and	a0,a0,a1
800070bc:	9532                	add	a0,a0,a2
800070be:	8082                	ret
800070c0:	fdfd                	bnez	a1,800070be <floorf+0x5e>
800070c2:	800005b7          	lui	a1,0x80000
800070c6:	bf6d                	j	80007080 <floorf+0x20>

Disassembly of section .text.libc.__udivdi3:

800070c8 <__udivdi3>:
800070c8:	872e                	mv	a4,a1
800070ca:	e2b1                	bnez	a3,8000710e <__udivdi3+0x46>
800070cc:	2a070863          	beqz	a4,8000737c <__udivdi3+0x2b4>
800070d0:	01865793          	srli	a5,a2,0x18
800070d4:	8fd5                	or	a5,a5,a3
800070d6:	ef85                	bnez	a5,8000710e <__udivdi3+0x46>
800070d8:	00563813          	sltiu	a6,a2,5
800070dc:	0016b793          	seqz	a5,a3
800070e0:	0107f7b3          	and	a5,a5,a6
800070e4:	3c078363          	beqz	a5,800074aa <__udivdi3+0x3e2>
800070e8:	4689                	li	a3,2
800070ea:	3ec6ce63          	blt	a3,a2,800074e6 <__udivdi3+0x41e>
800070ee:	4785                	li	a5,1
800070f0:	86aa                	mv	a3,a0
800070f2:	28f60f63          	beq	a2,a5,80007390 <__udivdi3+0x2c8>
800070f6:	4681                	li	a3,0
800070f8:	4789                	li	a5,2
800070fa:	4701                	li	a4,0
800070fc:	28f61a63          	bne	a2,a5,80007390 <__udivdi3+0x2c8>
80007100:	8105                	srli	a0,a0,0x1
80007102:	01f59693          	slli	a3,a1,0x1f
80007106:	8ec9                	or	a3,a3,a0
80007108:	0015d713          	srli	a4,a1,0x1
8000710c:	a451                	j	80007390 <__udivdi3+0x2c8>
8000710e:	14068e63          	beqz	a3,8000726a <__udivdi3+0x1a2>
80007112:	0106d813          	srli	a6,a3,0x10
80007116:	00155293          	srli	t0,a0,0x1
8000711a:	01f59713          	slli	a4,a1,0x1f
8000711e:	0015d893          	srli	a7,a1,0x1
80007122:	00165313          	srli	t1,a2,0x1
80007126:	800073b7          	lui	t2,0x80007
8000712a:	5b438393          	addi	t2,t2,1460 # 800075b4 <__SEGGER_RTL_Moeller_inverse_lut>
8000712e:	00183793          	seqz	a5,a6
80007132:	00e2e2b3          	or	t0,t0,a4
80007136:	00479813          	slli	a6,a5,0x4
8000713a:	010697b3          	sll	a5,a3,a6
8000713e:	0187d713          	srli	a4,a5,0x18
80007142:	00173713          	seqz	a4,a4
80007146:	070e                	slli	a4,a4,0x3
80007148:	00e79e33          	sll	t3,a5,a4
8000714c:	00e86833          	or	a6,a6,a4
80007150:	01ce5793          	srli	a5,t3,0x1c
80007154:	0017b793          	seqz	a5,a5
80007158:	078a                	slli	a5,a5,0x2
8000715a:	00fe1e33          	sll	t3,t3,a5
8000715e:	00f86833          	or	a6,a6,a5
80007162:	01ee5713          	srli	a4,t3,0x1e
80007166:	00173713          	seqz	a4,a4
8000716a:	0706                	slli	a4,a4,0x1
8000716c:	00ee17b3          	sll	a5,t3,a4
80007170:	00e86733          	or	a4,a6,a4
80007174:	fff7c793          	not	a5,a5
80007178:	83fd                	srli	a5,a5,0x1f
8000717a:	8f5d                	or	a4,a4,a5
8000717c:	00e697b3          	sll	a5,a3,a4
80007180:	01f74813          	xori	a6,a4,31
80007184:	01035733          	srl	a4,t1,a6
80007188:	00e7efb3          	or	t6,a5,a4
8000718c:	001ff313          	andi	t1,t6,1
80007190:	016fd713          	srli	a4,t6,0x16
80007194:	0706                	slli	a4,a4,0x1
80007196:	971e                	add	a4,a4,t2
80007198:	c0075383          	lhu	t2,-1024(a4)
8000719c:	00bfd713          	srli	a4,t6,0xb
800071a0:	001fde13          	srli	t3,t6,0x1
800071a4:	00170e93          	addi	t4,a4,1
800071a8:	02738733          	mul	a4,t2,t2
800071ac:	03d73eb3          	mulhu	t4,a4,t4
800071b0:	8f7e                	mv	t5,t6
800071b2:	9e1a                	add	t3,t3,t1
800071b4:	40600333          	neg	t1,t1
800071b8:	0392                	slli	t2,t2,0x4
800071ba:	fffec713          	not	a4,t4
800071be:	93ba                	add	t2,t2,a4
800071c0:	0013d713          	srli	a4,t2,0x1
800071c4:	00e37333          	and	t1,t1,a4
800071c8:	87fe                	mv	a5,t6
800071ca:	03c38733          	mul	a4,t2,t3
800071ce:	40e30733          	sub	a4,t1,a4
800071d2:	00f39313          	slli	t1,t2,0xf
800071d6:	02e3b733          	mulhu	a4,t2,a4
800071da:	8305                	srli	a4,a4,0x1
800071dc:	00e30e33          	add	t3,t1,a4
800071e0:	03fe0333          	mul	t1,t3,t6
800071e4:	03fe33b3          	mulhu	t2,t3,t6
800071e8:	9f1a                	add	t5,t5,t1
800071ea:	006f3733          	sltu	a4,t5,t1
800071ee:	97ba                	add	a5,a5,a4
800071f0:	979e                	add	a5,a5,t2
800071f2:	40fe0733          	sub	a4,t3,a5
800071f6:	03173333          	mulhu	t1,a4,a7
800071fa:	03170733          	mul	a4,a4,a7
800071fe:	00e283b3          	add	t2,t0,a4
80007202:	0053b7b3          	sltu	a5,t2,t0
80007206:	989a                	add	a7,a7,t1
80007208:	00f88333          	add	t1,a7,a5
8000720c:	00130893          	addi	a7,t1,1 # 7f800001 <_flash_size+0x7f700001>
80007210:	03f887b3          	mul	a5,a7,t6
80007214:	40f287b3          	sub	a5,t0,a5
80007218:	00f3b733          	sltu	a4,t2,a5
8000721c:	40e00733          	neg	a4,a4
80007220:	01f772b3          	and	t0,a4,t6
80007224:	92be                	add	t0,t0,a5
80007226:	00f3e363          	bltu	t2,a5,8000722c <__udivdi3+0x164>
8000722a:	8346                	mv	t1,a7
8000722c:	01f2b733          	sltu	a4,t0,t6
80007230:	00174713          	xori	a4,a4,1
80007234:	971a                	add	a4,a4,t1
80007236:	01075733          	srl	a4,a4,a6
8000723a:	fff70793          	addi	a5,a4,-1
8000723e:	00f73733          	sltu	a4,a4,a5
80007242:	177d                	addi	a4,a4,-1
80007244:	8ff9                	and	a5,a5,a4
80007246:	02f68833          	mul	a6,a3,a5
8000724a:	02f638b3          	mulhu	a7,a2,a5
8000724e:	02f60733          	mul	a4,a2,a5
80007252:	9846                	add	a6,a6,a7
80007254:	41058833          	sub	a6,a1,a6
80007258:	00e535b3          	sltu	a1,a0,a4
8000725c:	40b805b3          	sub	a1,a6,a1
80007260:	12d58163          	beq	a1,a3,80007382 <__udivdi3+0x2ba>
80007264:	00d5b533          	sltu	a0,a1,a3
80007268:	a205                	j	80007388 <__udivdi3+0x2c0>
8000726a:	10070963          	beqz	a4,8000737c <__udivdi3+0x2b4>
8000726e:	12c77463          	bgeu	a4,a2,80007396 <__udivdi3+0x2ce>
80007272:	01065693          	srli	a3,a2,0x10
80007276:	00155893          	srli	a7,a0,0x1
8000727a:	80007837          	lui	a6,0x80007
8000727e:	5b480813          	addi	a6,a6,1460 # 800075b4 <__SEGGER_RTL_Moeller_inverse_lut>
80007282:	0016b693          	seqz	a3,a3
80007286:	0692                	slli	a3,a3,0x4
80007288:	00d61733          	sll	a4,a2,a3
8000728c:	01875793          	srli	a5,a4,0x18
80007290:	0017b793          	seqz	a5,a5
80007294:	078e                	slli	a5,a5,0x3
80007296:	00f71733          	sll	a4,a4,a5
8000729a:	8edd                	or	a3,a3,a5
8000729c:	01c75793          	srli	a5,a4,0x1c
800072a0:	0017b793          	seqz	a5,a5
800072a4:	078a                	slli	a5,a5,0x2
800072a6:	00f71733          	sll	a4,a4,a5
800072aa:	8edd                	or	a3,a3,a5
800072ac:	01e75793          	srli	a5,a4,0x1e
800072b0:	0017b793          	seqz	a5,a5
800072b4:	0786                	slli	a5,a5,0x1
800072b6:	00f71733          	sll	a4,a4,a5
800072ba:	8edd                	or	a3,a3,a5
800072bc:	fff74713          	not	a4,a4
800072c0:	837d                	srli	a4,a4,0x1f
800072c2:	8ed9                	or	a3,a3,a4
800072c4:	00d59733          	sll	a4,a1,a3
800072c8:	01f6c793          	xori	a5,a3,31
800072cc:	00d512b3          	sll	t0,a0,a3
800072d0:	00d616b3          	sll	a3,a2,a3
800072d4:	00f8d633          	srl	a2,a7,a5
800072d8:	0016f593          	andi	a1,a3,1
800072dc:	00b6d793          	srli	a5,a3,0xb
800072e0:	0166d513          	srli	a0,a3,0x16
800072e4:	0506                	slli	a0,a0,0x1
800072e6:	9542                	add	a0,a0,a6
800072e8:	c0055503          	lhu	a0,-1024(a0)
800072ec:	0016d813          	srli	a6,a3,0x1
800072f0:	00c768b3          	or	a7,a4,a2
800072f4:	0785                	addi	a5,a5,1 # 800001 <_flash_size+0x700001>
800072f6:	02a50733          	mul	a4,a0,a0
800072fa:	02f73733          	mulhu	a4,a4,a5
800072fe:	87b6                	mv	a5,a3
80007300:	982e                	add	a6,a6,a1
80007302:	40b005b3          	neg	a1,a1
80007306:	0512                	slli	a0,a0,0x4
80007308:	fff74713          	not	a4,a4
8000730c:	953a                	add	a0,a0,a4
8000730e:	00155713          	srli	a4,a0,0x1
80007312:	8df9                	and	a1,a1,a4
80007314:	8736                	mv	a4,a3
80007316:	03050633          	mul	a2,a0,a6
8000731a:	8d91                	sub	a1,a1,a2
8000731c:	00f51613          	slli	a2,a0,0xf
80007320:	02b53533          	mulhu	a0,a0,a1
80007324:	8105                	srli	a0,a0,0x1
80007326:	9532                	add	a0,a0,a2
80007328:	02d505b3          	mul	a1,a0,a3
8000732c:	02d53633          	mulhu	a2,a0,a3
80007330:	97ae                	add	a5,a5,a1
80007332:	00b7b5b3          	sltu	a1,a5,a1
80007336:	972e                	add	a4,a4,a1
80007338:	9732                	add	a4,a4,a2
8000733a:	8d19                	sub	a0,a0,a4
8000733c:	031535b3          	mulhu	a1,a0,a7
80007340:	03150533          	mul	a0,a0,a7
80007344:	00a28733          	add	a4,t0,a0
80007348:	00573533          	sltu	a0,a4,t0
8000734c:	95c6                	add	a1,a1,a7
8000734e:	952e                	add	a0,a0,a1
80007350:	00150613          	addi	a2,a0,1
80007354:	02d605b3          	mul	a1,a2,a3
80007358:	40b287b3          	sub	a5,t0,a1
8000735c:	00f735b3          	sltu	a1,a4,a5
80007360:	40b005b3          	neg	a1,a1
80007364:	8df5                	and	a1,a1,a3
80007366:	95be                	add	a1,a1,a5
80007368:	00f76363          	bltu	a4,a5,8000736e <__udivdi3+0x2a6>
8000736c:	8532                	mv	a0,a2
8000736e:	4701                	li	a4,0
80007370:	00d5b5b3          	sltu	a1,a1,a3
80007374:	0015c693          	xori	a3,a1,1
80007378:	96aa                	add	a3,a3,a0
8000737a:	a819                	j	80007390 <__udivdi3+0x2c8>
8000737c:	02c556b3          	divu	a3,a0,a2
80007380:	a801                	j	80007390 <__udivdi3+0x2c8>
80007382:	8d19                	sub	a0,a0,a4
80007384:	00c53533          	sltu	a0,a0,a2
80007388:	4701                	li	a4,0
8000738a:	00154693          	xori	a3,a0,1
8000738e:	96be                	add	a3,a3,a5
80007390:	8536                	mv	a0,a3
80007392:	85ba                	mv	a1,a4
80007394:	8082                	ret
80007396:	02c758b3          	divu	a7,a4,a2
8000739a:	01065693          	srli	a3,a2,0x10
8000739e:	00155293          	srli	t0,a0,0x1
800073a2:	80007837          	lui	a6,0x80007
800073a6:	5b480813          	addi	a6,a6,1460 # 800075b4 <__SEGGER_RTL_Moeller_inverse_lut>
800073aa:	0016b693          	seqz	a3,a3
800073ae:	02c885b3          	mul	a1,a7,a2
800073b2:	0692                	slli	a3,a3,0x4
800073b4:	8f0d                	sub	a4,a4,a1
800073b6:	00d617b3          	sll	a5,a2,a3
800073ba:	0187d593          	srli	a1,a5,0x18
800073be:	0015b593          	seqz	a1,a1
800073c2:	058e                	slli	a1,a1,0x3
800073c4:	00b797b3          	sll	a5,a5,a1
800073c8:	8dd5                	or	a1,a1,a3
800073ca:	01c7d693          	srli	a3,a5,0x1c
800073ce:	0016b693          	seqz	a3,a3
800073d2:	068a                	slli	a3,a3,0x2
800073d4:	00d797b3          	sll	a5,a5,a3
800073d8:	8dd5                	or	a1,a1,a3
800073da:	01e7d693          	srli	a3,a5,0x1e
800073de:	0016b693          	seqz	a3,a3
800073e2:	0686                	slli	a3,a3,0x1
800073e4:	00d797b3          	sll	a5,a5,a3
800073e8:	8dd5                	or	a1,a1,a3
800073ea:	fff7c693          	not	a3,a5
800073ee:	82fd                	srli	a3,a3,0x1f
800073f0:	8dd5                	or	a1,a1,a3
800073f2:	00b71733          	sll	a4,a4,a1
800073f6:	01f5c793          	xori	a5,a1,31
800073fa:	00b51333          	sll	t1,a0,a1
800073fe:	00b61633          	sll	a2,a2,a1
80007402:	00f2d5b3          	srl	a1,t0,a5
80007406:	00167693          	andi	a3,a2,1
8000740a:	00b65793          	srli	a5,a2,0xb
8000740e:	01665513          	srli	a0,a2,0x16
80007412:	0506                	slli	a0,a0,0x1
80007414:	9542                	add	a0,a0,a6
80007416:	c0055503          	lhu	a0,-1024(a0)
8000741a:	00165813          	srli	a6,a2,0x1
8000741e:	00b762b3          	or	t0,a4,a1
80007422:	0785                	addi	a5,a5,1
80007424:	02a50733          	mul	a4,a0,a0
80007428:	02f73733          	mulhu	a4,a4,a5
8000742c:	87b2                	mv	a5,a2
8000742e:	9836                	add	a6,a6,a3
80007430:	40d006b3          	neg	a3,a3
80007434:	0512                	slli	a0,a0,0x4
80007436:	fff74713          	not	a4,a4
8000743a:	953a                	add	a0,a0,a4
8000743c:	00155713          	srli	a4,a0,0x1
80007440:	8ef9                	and	a3,a3,a4
80007442:	8732                	mv	a4,a2
80007444:	030505b3          	mul	a1,a0,a6
80007448:	8e8d                	sub	a3,a3,a1
8000744a:	00f51593          	slli	a1,a0,0xf
8000744e:	02d53533          	mulhu	a0,a0,a3
80007452:	8105                	srli	a0,a0,0x1
80007454:	952e                	add	a0,a0,a1
80007456:	02c505b3          	mul	a1,a0,a2
8000745a:	02c536b3          	mulhu	a3,a0,a2
8000745e:	97ae                	add	a5,a5,a1
80007460:	00b7b5b3          	sltu	a1,a5,a1
80007464:	972e                	add	a4,a4,a1
80007466:	9736                	add	a4,a4,a3
80007468:	8d19                	sub	a0,a0,a4
8000746a:	025535b3          	mulhu	a1,a0,t0
8000746e:	02550533          	mul	a0,a0,t0
80007472:	00a307b3          	add	a5,t1,a0
80007476:	0067b533          	sltu	a0,a5,t1
8000747a:	9596                	add	a1,a1,t0
8000747c:	952e                	add	a0,a0,a1
8000747e:	00150713          	addi	a4,a0,1
80007482:	02c705b3          	mul	a1,a4,a2
80007486:	40b305b3          	sub	a1,t1,a1
8000748a:	00b7b6b3          	sltu	a3,a5,a1
8000748e:	40d006b3          	neg	a3,a3
80007492:	8ef1                	and	a3,a3,a2
80007494:	96ae                	add	a3,a3,a1
80007496:	00b7e363          	bltu	a5,a1,8000749c <__udivdi3+0x3d4>
8000749a:	853a                	mv	a0,a4
8000749c:	00c6b5b3          	sltu	a1,a3,a2
800074a0:	0015c693          	xori	a3,a1,1
800074a4:	96aa                	add	a3,a3,a0
800074a6:	8746                	mv	a4,a7
800074a8:	b5e5                	j	80007390 <__udivdi3+0x2c8>
800074aa:	01065793          	srli	a5,a2,0x10
800074ae:	02c5d733          	divu	a4,a1,a2
800074b2:	8edd                	or	a3,a3,a5
800074b4:	02c707b3          	mul	a5,a4,a2
800074b8:	8d9d                	sub	a1,a1,a5
800074ba:	e6a9                	bnez	a3,80007504 <__udivdi3+0x43c>
800074bc:	01055693          	srli	a3,a0,0x10
800074c0:	05c2                	slli	a1,a1,0x10
800074c2:	0542                	slli	a0,a0,0x10
800074c4:	8dd5                	or	a1,a1,a3
800074c6:	8141                	srli	a0,a0,0x10
800074c8:	02c5d5b3          	divu	a1,a1,a2
800074cc:	02c587b3          	mul	a5,a1,a2
800074d0:	8e9d                	sub	a3,a3,a5
800074d2:	06c2                	slli	a3,a3,0x10
800074d4:	8d55                	or	a0,a0,a3
800074d6:	02c556b3          	divu	a3,a0,a2
800074da:	05c2                	slli	a1,a1,0x10
800074dc:	96ae                	add	a3,a3,a1
800074de:	00b6b533          	sltu	a0,a3,a1
800074e2:	972a                	add	a4,a4,a0
800074e4:	b575                	j	80007390 <__udivdi3+0x2c8>
800074e6:	468d                	li	a3,3
800074e8:	06d60d63          	beq	a2,a3,80007562 <__udivdi3+0x49a>
800074ec:	4681                	li	a3,0
800074ee:	4791                	li	a5,4
800074f0:	4701                	li	a4,0
800074f2:	e8f61fe3          	bne	a2,a5,80007390 <__udivdi3+0x2c8>
800074f6:	8109                	srli	a0,a0,0x2
800074f8:	01e59693          	slli	a3,a1,0x1e
800074fc:	8ec9                	or	a3,a3,a0
800074fe:	0025d713          	srli	a4,a1,0x2
80007502:	b579                	j	80007390 <__udivdi3+0x2c8>
80007504:	01855813          	srli	a6,a0,0x18
80007508:	05a2                	slli	a1,a1,0x8
8000750a:	00851793          	slli	a5,a0,0x8
8000750e:	01051693          	slli	a3,a0,0x10
80007512:	0ff57893          	zext.b	a7,a0
80007516:	0105e5b3          	or	a1,a1,a6
8000751a:	83e1                	srli	a5,a5,0x18
8000751c:	0186d813          	srli	a6,a3,0x18
80007520:	02c5d533          	divu	a0,a1,a2
80007524:	02c506b3          	mul	a3,a0,a2
80007528:	0562                	slli	a0,a0,0x18
8000752a:	8d95                	sub	a1,a1,a3
8000752c:	05a2                	slli	a1,a1,0x8
8000752e:	8ddd                	or	a1,a1,a5
80007530:	02c5d6b3          	divu	a3,a1,a2
80007534:	02c687b3          	mul	a5,a3,a2
80007538:	06c2                	slli	a3,a3,0x10
8000753a:	8d9d                	sub	a1,a1,a5
8000753c:	9536                	add	a0,a0,a3
8000753e:	05a2                	slli	a1,a1,0x8
80007540:	0105e5b3          	or	a1,a1,a6
80007544:	02c5d6b3          	divu	a3,a1,a2
80007548:	02c687b3          	mul	a5,a3,a2
8000754c:	06a2                	slli	a3,a3,0x8
8000754e:	8d9d                	sub	a1,a1,a5
80007550:	05a2                	slli	a1,a1,0x8
80007552:	0115e5b3          	or	a1,a1,a7
80007556:	02c5d5b3          	divu	a1,a1,a2
8000755a:	9536                	add	a0,a0,a3
8000755c:	00b506b3          	add	a3,a0,a1
80007560:	bd05                	j	80007390 <__udivdi3+0x2c8>
80007562:	555555b7          	lui	a1,0x55555
80007566:	55558593          	addi	a1,a1,1365 # 55555555 <_flash_size+0x55455555>
8000756a:	02a5b633          	mulhu	a2,a1,a0
8000756e:	02a58533          	mul	a0,a1,a0
80007572:	02e5b6b3          	mulhu	a3,a1,a4
80007576:	02e585b3          	mul	a1,a1,a4
8000757a:	962e                	add	a2,a2,a1
8000757c:	00b635b3          	sltu	a1,a2,a1
80007580:	9532                	add	a0,a0,a2
80007582:	95b6                	add	a1,a1,a3
80007584:	00c536b3          	sltu	a3,a0,a2
80007588:	96ae                	add	a3,a3,a1
8000758a:	00d60733          	add	a4,a2,a3
8000758e:	9536                	add	a0,a0,a3
80007590:	00c73633          	sltu	a2,a4,a2
80007594:	00d536b3          	sltu	a3,a0,a3
80007598:	0505                	addi	a0,a0,1
8000759a:	95b2                	add	a1,a1,a2
8000759c:	00d70633          	add	a2,a4,a3
800075a0:	00153693          	seqz	a3,a0
800075a4:	00e63533          	sltu	a0,a2,a4
800075a8:	96b2                	add	a3,a3,a2
800075aa:	952e                	add	a0,a0,a1
800075ac:	00c6b733          	sltu	a4,a3,a2
800075b0:	972a                	add	a4,a4,a0
800075b2:	bbf9                	j	80007390 <__udivdi3+0x2c8>

Disassembly of section .text.libc.memset:

800079b4 <memset>:
800079b4:	872a                	mv	a4,a0
800079b6:	c22d                	beqz	a2,80007a18 <.Lmemset_memset_end>

800079b8 <.Lmemset_unaligned_byte_set_loop>:
800079b8:	01e51693          	slli	a3,a0,0x1e
800079bc:	c699                	beqz	a3,800079ca <.Lmemset_fast_set>
800079be:	00b50023          	sb	a1,0(a0)
800079c2:	0505                	addi	a0,a0,1
800079c4:	167d                	addi	a2,a2,-1 # ff7fffff <__AHB_SRAM_segment_end__+0xf3f7fff>
800079c6:	fa6d                	bnez	a2,800079b8 <.Lmemset_unaligned_byte_set_loop>
800079c8:	a881                	j	80007a18 <.Lmemset_memset_end>

800079ca <.Lmemset_fast_set>:
800079ca:	0ff5f593          	zext.b	a1,a1
800079ce:	00859693          	slli	a3,a1,0x8
800079d2:	8dd5                	or	a1,a1,a3
800079d4:	01059693          	slli	a3,a1,0x10
800079d8:	8dd5                	or	a1,a1,a3
800079da:	02000693          	li	a3,32
800079de:	00d66f63          	bltu	a2,a3,800079fc <.Lmemset_word_set>

800079e2 <.Lmemset_fast_set_loop>:
800079e2:	c10c                	sw	a1,0(a0)
800079e4:	c14c                	sw	a1,4(a0)
800079e6:	c50c                	sw	a1,8(a0)
800079e8:	c54c                	sw	a1,12(a0)
800079ea:	c90c                	sw	a1,16(a0)
800079ec:	c94c                	sw	a1,20(a0)
800079ee:	cd0c                	sw	a1,24(a0)
800079f0:	cd4c                	sw	a1,28(a0)
800079f2:	9536                	add	a0,a0,a3
800079f4:	8e15                	sub	a2,a2,a3
800079f6:	fed676e3          	bgeu	a2,a3,800079e2 <.Lmemset_fast_set_loop>
800079fa:	ce19                	beqz	a2,80007a18 <.Lmemset_memset_end>

800079fc <.Lmemset_word_set>:
800079fc:	4691                	li	a3,4
800079fe:	00d66863          	bltu	a2,a3,80007a0e <.Lmemset_byte_set_loop>

80007a02 <.Lmemset_word_set_loop>:
80007a02:	c10c                	sw	a1,0(a0)
80007a04:	9536                	add	a0,a0,a3
80007a06:	8e15                	sub	a2,a2,a3
80007a08:	fed67de3          	bgeu	a2,a3,80007a02 <.Lmemset_word_set_loop>
80007a0c:	c611                	beqz	a2,80007a18 <.Lmemset_memset_end>

80007a0e <.Lmemset_byte_set_loop>:
80007a0e:	00b50023          	sb	a1,0(a0)
80007a12:	0505                	addi	a0,a0,1
80007a14:	167d                	addi	a2,a2,-1
80007a16:	fe65                	bnez	a2,80007a0e <.Lmemset_byte_set_loop>

80007a18 <.Lmemset_memset_end>:
80007a18:	853a                	mv	a0,a4
80007a1a:	8082                	ret

Disassembly of section .text.libc.strlen:

80007a1c <strlen>:
80007a1c:	85aa                	mv	a1,a0
80007a1e:	00357693          	andi	a3,a0,3
80007a22:	c29d                	beqz	a3,80007a48 <.Lstrlen_aligned>
80007a24:	00054603          	lbu	a2,0(a0)
80007a28:	ce21                	beqz	a2,80007a80 <.Lstrlen_done>
80007a2a:	0505                	addi	a0,a0,1
80007a2c:	00357693          	andi	a3,a0,3
80007a30:	ce81                	beqz	a3,80007a48 <.Lstrlen_aligned>
80007a32:	00054603          	lbu	a2,0(a0)
80007a36:	c629                	beqz	a2,80007a80 <.Lstrlen_done>
80007a38:	0505                	addi	a0,a0,1
80007a3a:	00357693          	andi	a3,a0,3
80007a3e:	c689                	beqz	a3,80007a48 <.Lstrlen_aligned>
80007a40:	00054603          	lbu	a2,0(a0)
80007a44:	ce15                	beqz	a2,80007a80 <.Lstrlen_done>
80007a46:	0505                	addi	a0,a0,1

80007a48 <.Lstrlen_aligned>:
80007a48:	01010637          	lui	a2,0x1010
80007a4c:	10160613          	addi	a2,a2,257 # 1010101 <_flash_size+0xf10101>
80007a50:	00761693          	slli	a3,a2,0x7

80007a54 <.Lstrlen_wordstrlen>:
80007a54:	4118                	lw	a4,0(a0)
80007a56:	0511                	addi	a0,a0,4
80007a58:	40c707b3          	sub	a5,a4,a2
80007a5c:	fff74713          	not	a4,a4
80007a60:	8ff9                	and	a5,a5,a4
80007a62:	8ff5                	and	a5,a5,a3
80007a64:	dbe5                	beqz	a5,80007a54 <.Lstrlen_wordstrlen>
80007a66:	1571                	addi	a0,a0,-4
80007a68:	01879713          	slli	a4,a5,0x18
80007a6c:	eb11                	bnez	a4,80007a80 <.Lstrlen_done>
80007a6e:	0505                	addi	a0,a0,1
80007a70:	01079713          	slli	a4,a5,0x10
80007a74:	e711                	bnez	a4,80007a80 <.Lstrlen_done>
80007a76:	0505                	addi	a0,a0,1
80007a78:	00879713          	slli	a4,a5,0x8
80007a7c:	e311                	bnez	a4,80007a80 <.Lstrlen_done>
80007a7e:	0505                	addi	a0,a0,1

80007a80 <.Lstrlen_done>:
80007a80:	8d0d                	sub	a0,a0,a1
80007a82:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pow10f:

80007a84 <__SEGGER_RTL_pow10f>:
80007a84:	1101                	addi	sp,sp,-32
80007a86:	ce06                	sw	ra,28(sp)
80007a88:	cc22                	sw	s0,24(sp)
80007a8a:	ca26                	sw	s1,20(sp)
80007a8c:	c84a                	sw	s2,16(sp)
80007a8e:	c64e                	sw	s3,12(sp)
80007a90:	892a                	mv	s2,a0
80007a92:	c515                	beqz	a0,80007abe <__SEGGER_RTL_pow10f+0x3a>
80007a94:	41f95513          	srai	a0,s2,0x1f
80007a98:	e0018413          	addi	s0,gp,-512 # 80003690 <__SEGGER_RTL_aPower2f>
80007a9c:	00a944b3          	xor	s1,s2,a0
80007aa0:	8c89                	sub	s1,s1,a0
80007aa2:	3f8009b7          	lui	s3,0x3f800
80007aa6:	0014f513          	andi	a0,s1,1
80007aaa:	c511                	beqz	a0,80007ab6 <__SEGGER_RTL_pow10f+0x32>
80007aac:	400c                	lw	a1,0(s0)
80007aae:	854e                	mv	a0,s3
80007ab0:	92aff0ef          	jal	80006bda <__mulsf3>
80007ab4:	89aa                	mv	s3,a0
80007ab6:	8085                	srli	s1,s1,0x1
80007ab8:	0411                	addi	s0,s0,4
80007aba:	f4f5                	bnez	s1,80007aa6 <__SEGGER_RTL_pow10f+0x22>
80007abc:	a019                	j	80007ac2 <__SEGGER_RTL_pow10f+0x3e>
80007abe:	3f8009b7          	lui	s3,0x3f800
80007ac2:	3f800537          	lui	a0,0x3f800
80007ac6:	85ce                	mv	a1,s3
80007ac8:	9c2ff0ef          	jal	80006c8a <__divsf3>
80007acc:	00094363          	bltz	s2,80007ad2 <__SEGGER_RTL_pow10f+0x4e>
80007ad0:	854e                	mv	a0,s3
80007ad2:	40f2                	lw	ra,28(sp)
80007ad4:	4462                	lw	s0,24(sp)
80007ad6:	44d2                	lw	s1,20(sp)
80007ad8:	4942                	lw	s2,16(sp)
80007ada:	49b2                	lw	s3,12(sp)
80007adc:	6105                	addi	sp,sp,32
80007ade:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_current_locale:

80007ae0 <__SEGGER_RTL_current_locale>:
80007ae0:	00080537          	lui	a0,0x80
80007ae4:	32c52503          	lw	a0,812(a0) # 8032c <__SEGGER_RTL_locale_ptr>
80007ae8:	e509                	bnez	a0,80007af2 <__SEGGER_RTL_current_locale+0x12>
80007aea:	00080537          	lui	a0,0x80
80007aee:	30050513          	addi	a0,a0,768 # 80300 <__RAL_global_locale>
80007af2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_mbtowc:

80007af4 <__SEGGER_RTL_ascii_mbtowc>:
80007af4:	4701                	li	a4,0
80007af6:	c19d                	beqz	a1,80007b1c <__SEGGER_RTL_ascii_mbtowc+0x28>
80007af8:	c215                	beqz	a2,80007b1c <__SEGGER_RTL_ascii_mbtowc+0x28>
80007afa:	0005c603          	lbu	a2,0(a1)
80007afe:	01861593          	slli	a1,a2,0x18
80007b02:	0005cc63          	bltz	a1,80007b1a <__SEGGER_RTL_ascii_mbtowc+0x26>
80007b06:	85e1                	srai	a1,a1,0x18
80007b08:	c111                	beqz	a0,80007b0c <__SEGGER_RTL_ascii_mbtowc+0x18>
80007b0a:	c110                	sw	a2,0(a0)
80007b0c:	0006a023          	sw	zero,0(a3) # 800000 <_flash_size+0x700000>
80007b10:	0006a223          	sw	zero,4(a3)
80007b14:	00b03733          	snez	a4,a1
80007b18:	a011                	j	80007b1c <__SEGGER_RTL_ascii_mbtowc+0x28>
80007b1a:	5779                	li	a4,-2
80007b1c:	853a                	mv	a0,a4
80007b1e:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_wctomb:

80007b20 <__SEGGER_RTL_ascii_wctomb>:
80007b20:	07f00613          	li	a2,127
80007b24:	00b67463          	bgeu	a2,a1,80007b2c <__SEGGER_RTL_ascii_wctomb+0xc>
80007b28:	5579                	li	a0,-2
80007b2a:	8082                	ret
80007b2c:	00b50023          	sb	a1,0(a0)
80007b30:	4505                	li	a0,1
80007b32:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_isctype:

80007b34 <__SEGGER_RTL_ascii_isctype>:
80007b34:	07f00613          	li	a2,127
80007b38:	02a66263          	bltu	a2,a0,80007b5c <__SEGGER_RTL_ascii_isctype+0x28>
80007b3c:	80008637          	lui	a2,0x80008
80007b40:	cfa60613          	addi	a2,a2,-774 # 80007cfa <__SEGGER_RTL_ascii_ctype_map>
80007b44:	9532                	add	a0,a0,a2
80007b46:	80008637          	lui	a2,0x80008
80007b4a:	cc560613          	addi	a2,a2,-827 # 80007cc5 <__SEGGER_RTL_ascii_ctype_mask>
80007b4e:	95b2                	add	a1,a1,a2
80007b50:	00054503          	lbu	a0,0(a0)
80007b54:	0005c583          	lbu	a1,0(a1)
80007b58:	8d6d                	and	a0,a0,a1
80007b5a:	8082                	ret
80007b5c:	4501                	li	a0,0
80007b5e:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_iswctype:

80007b60 <__SEGGER_RTL_ascii_iswctype>:
80007b60:	07f00613          	li	a2,127
80007b64:	02a66263          	bltu	a2,a0,80007b88 <__SEGGER_RTL_ascii_iswctype+0x28>
80007b68:	80008637          	lui	a2,0x80008
80007b6c:	cfa60613          	addi	a2,a2,-774 # 80007cfa <__SEGGER_RTL_ascii_ctype_map>
80007b70:	9532                	add	a0,a0,a2
80007b72:	80008637          	lui	a2,0x80008
80007b76:	cc560613          	addi	a2,a2,-827 # 80007cc5 <__SEGGER_RTL_ascii_ctype_mask>
80007b7a:	95b2                	add	a1,a1,a2
80007b7c:	00054503          	lbu	a0,0(a0)
80007b80:	0005c583          	lbu	a1,0(a1)
80007b84:	8d6d                	and	a0,a0,a1
80007b86:	8082                	ret
80007b88:	4501                	li	a0,0
80007b8a:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_zero:

80008140 <__SEGGER_init_zero>:
80008140:	4008                	lw	a0,0(s0)
80008142:	404c                	lw	a1,4(s0)
80008144:	0421                	addi	s0,s0,8
80008146:	c591                	beqz	a1,80008152 <.L__SEGGER_init_zero_Done>

80008148 <.L__SEGGER_init_zero_Loop>:
80008148:	00050023          	sb	zero,0(a0)
8000814c:	0505                	addi	a0,a0,1
8000814e:	15fd                	addi	a1,a1,-1
80008150:	fde5                	bnez	a1,80008148 <.L__SEGGER_init_zero_Loop>

80008152 <.L__SEGGER_init_zero_Done>:
80008152:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_copy:

80008154 <__SEGGER_init_copy>:
80008154:	4008                	lw	a0,0(s0)
80008156:	404c                	lw	a1,4(s0)
80008158:	4410                	lw	a2,8(s0)
8000815a:	0431                	addi	s0,s0,12
8000815c:	ca09                	beqz	a2,8000816e <.L__SEGGER_init_copy_Done>

8000815e <.L__SEGGER_init_copy_Loop>:
8000815e:	00058683          	lb	a3,0(a1)
80008162:	00d50023          	sb	a3,0(a0)
80008166:	0505                	addi	a0,a0,1
80008168:	0585                	addi	a1,a1,1
8000816a:	167d                	addi	a2,a2,-1
8000816c:	fa6d                	bnez	a2,8000815e <.L__SEGGER_init_copy_Loop>

8000816e <.L__SEGGER_init_copy_Done>:
8000816e:	8082                	ret
