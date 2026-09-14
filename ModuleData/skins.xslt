<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="yes"/>

    <!-- ============================================================
         🔴 本文件是【默认脸的主配置】（2026-09-14 起）
             human 男 -> 萨菲罗斯头 head_sephiroth_a
             human 女 -> 蒂法头     head_tifa_a
             专属 race（如 lwn_nobunaga 织田信长）不受影响，各用自己的头

         🔴 为什么放在 Taikou、不放 TifaHead2：
            游戏是用 VS 启动参数指定模块的 ——
            `/singleplayer _MODULES_*...*StoryMode*LivingWorldNpcs*Taikou*_MODULES_`
            **列表里没有 TifaHead2** → 放在那边的 skins.xslt 永远不会被加载。
            而 Taikou 一定加载，并且是**双端 junction 同源**（1.2.12 / Steam 共用同一份）→ 改这里两端都生效。
            本文件内容 = 原 `TifaHead2\ModuleData\skins.xslt.master`（那边保留作历史，不再使用）。

         🔴 改匹配时务必锚定 `race[@id='human']`：`skin[@name='man']` 是**跨 race** 的写法，
            会把专属 race（lwn_nobunaga 的 skin 也叫 man）一起改掉，"特殊人物用自己的脸"当场失效。
         ============================================================ -->

    <!-- ==== TifaHead: 女性皮肤的头 -> 蒂法头 head_tifa_a ==== -->

    <!-- 0. Identity: 默认原样拷贝 -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- 1. 女头网格: head_female_a -> head_tifa_a -->
    <xsl:template match="race[@id='human']/skin[@name='woman']/@face_meta_mesh">
        <xsl:attribute name="face_meta_mesh">head_tifa_a</xsl:attribute>
    </xsl:template>

    <!-- 2. 眉毛: 不改（原版 5 条照用）。
         曾清空成 <eyebrow_meshes/>，但原版与 xxFemale 都至少留 1 条——空列表会被引擎按索引取到越界。
         蒂法眉毛虽烘在 .3.1 子网格里，多一层原版眉毛也只是观感问题，不崩。 -->

    <!-- 3. 脸皮: 🔴 条数必须与原版/xxFemale 同量级（原版 4 条 / xxFemale 5 条）。
         脸部贴图合成在 AddSkinMeshes 里按索引取 face_textures[i]（索引来自角色 BodyProperties，0~5），
         只写 1 条 → 索引越界 → native AccessViolation。故照 xxFemale 的 5 条 + tag 分布(2,2,3,4,5)写，
         全部指向蒂法头材质（我们只有一张脸皮）。 -->
    <xsl:template match="race[@id='human']/skin[@name='woman']/face_textures">
        <face_textures>
            <face_texture name="head_tifa_a" lod_material="head_tifa_a" color="0xFFCAD3E0" tags="face_texture2"></face_texture>
            <face_texture name="head_tifa_a" lod_material="head_tifa_a" color="0xFFCAD3E0" tags="face_texture2"></face_texture>
            <face_texture name="head_tifa_a" lod_material="head_tifa_a" color="0xFFCAD3E0" tags="face_texture3"></face_texture>
            <face_texture name="head_tifa_a" lod_material="head_tifa_a" color="0xFFCAD3E0" tags="face_texture4"></face_texture>
            <face_texture name="head_tifa_a" lod_material="head_tifa_a" color="0xFFCAD3E0" tags="face_texture5"></face_texture>
        </face_textures>
    </xsl:template>

    <!-- ================= 男皮肤 = 萨菲罗斯头 head_sephiroth_a =================
         男头与原版/女头结构【不同】，三处必须照原版 man 走，别照抄 woman：
           · 原版 man 头是【3 件】：脸 / 眼(.1) / 嘴(.2)，没有睫毛件
             （女头是 4 件 脸/嘴/眼/睫；在售的自定义男头 Shokuho sho_head_male_japanese 也是 3 件）
           · deform_keys 不动：原版 man 的 key_time_point 序列与 woman 【逐位完全相同】
             （实测 62 条全同，只差第 48 条 id 名），我们的 FBX 提供的是同一套 KeyTime_1..59 → 直接对齐
           · eyebrow_meshes / mouth_textures 不动（原版 10 条 / 6 条照用） -->

    <!-- 6. 男头网格: head_male_a -> head_sephiroth_a -->
    <xsl:template match="race[@id='human']/skin[@name='man']/@face_meta_mesh">
        <xsl:attribute name="face_meta_mesh">head_sephiroth_a</xsl:attribute>
    </xsl:template>

    <!-- 7. 男脸皮: 🔴 条数与 tag 分布【照抄原版 man】，只把名字换成我们的材质。
         为什么不照 Shokuho 写 1 条：Shokuho 的 man 皮肤确实只写 1 条（tags=face_texture1,2）也能跑，
         但 woman 那边实测过"写 1 条 → 引擎按索引取 face_textures[i] 越界 → native AccessViolation"。
         原版 man 是 4 条、tags 覆盖 face_texture1..10，保持这个条数 = 索引空间不变 = 零风险。 -->
    <xsl:template match="race[@id='human']/skin[@name='man']/face_textures">
        <face_textures group_id="1">
            <face_texture name="head_sephiroth_a" lod_material="head_sephiroth_a" color="0xFFFFFFFF" tags="face_texture1,face_texture2"></face_texture>
            <face_texture name="head_sephiroth_a" lod_material="head_sephiroth_a" color="0xFFFFFFFF" tags="face_texture3,face_texture4"></face_texture>
            <face_texture name="head_sephiroth_a" lod_material="head_sephiroth_a" color="0xFFFFFFFF" tags="face_texture5,face_texture6,face_texture7"></face_texture>
            <face_texture name="head_sephiroth_a" lod_material="head_sephiroth_a" color="0xFFFFFFFF" tags="face_texture8,face_texture9,face_texture10"></face_texture>
        </face_textures>
    </xsl:template>

    <!-- 4. 嘴: 不改（原版 5 条照用）。
         曾改成 1 条，同理会按索引越界；xxFemale 也是完全不动这一段。 -->

    <!-- 5. woman deform_keys / constraints 沿用 xxFemale 那套
         (蒂法的 59 个 KeyTime 通道由 xxFemale 通道位移场移植而来, min/max 必须同源) -->
<xsl:template match='race[@id="human"]/skin[@name="woman"]/deform_keys | race[@id="human"]/skin[@name="man"]/deform_keys'>
        <deform_keys>
            <deform_key
                id="face_width"
                key_time_point="1"
                key_min="-0.0"
                key_max="1.0"
                name="Face Width"
                group_id="1"
                helmet_scaling_factor_min="-0.1, 0.0, 0.0"
                helmet_scaling_factor_max="0.02, 0.0, 0.0"
                deforms_hair="1.0" />
            <deform_key
                id="face_depth"
                key_time_point="2"
                key_min="-0.7"
                key_max="0.7"
                name="Face Depth"
                group_id="1"
                helmet_scaling_factor_min="0.0, -0.05, 0.0"
                helmet_scaling_factor_max="0.0, 0.025, 0.0" />
            <deform_key
                id="center_height"
                key_time_point="10"
                key_min="-0.7"
                key_max="0.25"
                name="Center Height"
                group_id="1"
                helmet_scaling_factor_min="0.0, 0.0, 0.0"
                helmet_scaling_factor_max="0.0, 0.0, 0.0025"
                deforms_hair="1.0" />
            <deform_key
                id="face_ratio"
                key_time_point="3"
                key_min="-0.35"
                key_max="0.35"
                name="Face Ratio"
                group_id="1"
                helmet_scaling_factor_min="0.0, 0.0, -0.002"
                helmet_scaling_factor_max="0.0, 0.0, 0.0"
                deforms_hair="1.0" />
            <deform_key
                id="cheeks"
                key_time_point="4"
                key_min="-0.5"
                key_max="0.5"
                name="Face Weight"
                group_id="1"
                helmet_scaling_factor_min="-0.02, 0.0, 0.0"
                helmet_scaling_factor_max="0.02, 0.0, 0.0"
                deforms_hair="1.0" />
            <deform_key
                id="cheekbone_height"
                key_time_point="5"
                key_min="-0.8"
                key_max="0.5"
                name="Cheekbone Height"
                group_id="1"
                deforms_hair="1.0" />
            <deform_key
                id="cheekbone_width"
                key_time_point="6"
                key_min="-0.5"
                key_max="0.5"
                name="Cheekbone Width"
                group_id="1"
                helmet_scaling_factor_min="0.0, 0.0, 0.0"
                helmet_scaling_factor_max="0.025, 0.0, 0.0"
                deforms_hair="1.0" />
            <deform_key
                id="cheekbone_depth"
                key_time_point="7"
                key_min="-0.5"
                key_max="0.8"
                name="Cheekbone Depth"
                group_id="1"
                deforms_hair="0.4" />
            <deform_key
                id="face_sharpness"
                key_time_point="12"
                key_min="-0.5"
                key_max="0.5"
                name="Face Sharpness"
                group_id="1"
                deforms_hair="1.0" />
            <deform_key
                id="temple_width"
                key_time_point="13"
                key_min="-0.5"
                key_max="0.5"
                name="Temple width"
                group_id="1"
                helmet_scaling_factor_min="-0.025, 0.0, 0.0"
                helmet_scaling_factor_max="0.01, 0.0, 0.0"
                deforms_hair="1.0" />
            <deform_key
                id="eye_socket_size"
                key_time_point="53"
                key_min="-0.5"
                key_max="0.8"
                name="Eye Socket Size"
                group_id="1"
                helmet_scaling_factor_min="-0.01, 0.0, 0.0"
                helmet_scaling_factor_max="0.02, 0.0, 0.0"
                deforms_hair="1.0" />
            <deform_key
                id="ear_shape"
                key_time_point="52"
                key_min="-0.5"
                key_max="0.5"
                name="Ear Shape"
                group_id="1"
                deforms_hair="1.0" />
            <deform_key
                id="ear_size"
                key_time_point="56"
                key_min="-0.5"
                key_max="0.5"
                name="Ear Size"
                group_id="1"
                deforms_hair="1.0" />
            <deform_key
                id="face_asymmetry"
                key_time_point="47"
                key_min="-0.5"
                key_max="0.5"
                name="Face Asymmetry"
                group_id="1"
                deforms_hair="1.0" />
            <deform_key
                id="eyebrow_depth"
                key_time_point="22"
                key_min="0.5"
                key_max="-0.8"
                name="Eyebrow Depth"
                group_id="2"
                deforms_hair="1.0"
                helmet_scaling_factor_min="0.0, -0.025, 0.0"
                helmet_scaling_factor_max="0.0, 0.025, 0.0" />
            <deform_key
                id="brow_outer_height"
                key_time_point="24"
                key_min="-0.5"
                key_max="0.5"
                name="Brow Outer Height"
                group_id="2"
                deforms_hair="1.0" />
            <deform_key
                id="brow_middle_height"
                key_time_point="25"
                key_min="-0.5"
                key_max="0.5"
                name="Brow Middle Height"
                group_id="2"
                deforms_hair="0.1" />
            <deform_key
                id="brow_inner_height"
                key_time_point="26"
                key_min="0.5"
                key_max="-0.5"
                name="Brow Inner Height"
                group_id="2"
                deforms_hair="0.1" />
            <deform_key
                id="eye_position"
                key_time_point="23"
                key_min="0.5"
                key_max="-0.5"
                name="Eye Position"
                group_id="2"
                helmet_scaling_factor_min="0.0, 0.0, 0.0010"
                helmet_scaling_factor_max="0.0, 0.0, -0.0010"
                deforms_hair="1.0" />
            <deform_key
                id="eye_size"
                key_time_point="17"
                key_min="-1.0"
                key_max="1.0"
                name="Eye Size"
                group_id="2" />
            <deform_key
                id="monolid_eyes"
                key_time_point="19"
                key_min="-0.6"
                key_max="0.6"
                name="Monolid Eyes"
                group_id="2" />
            <deform_key
                id="eyelid_height"
                key_time_point="18"
                key_min="0.5"
                key_max="-0.1"
                name="Eyelid Height"
                group_id="2"
                deforms_hair="1.0" />
            <deform_key
                id="eye_depth"
                key_time_point="14"
                key_min="0.85"
                key_max="-0.5"
                name="Eye Depth"
                group_id="2"
                deforms_hair="1.0" />
            <deform_key
                id="eye_shape"
                key_time_point="15"
                key_min="-0.5"
                key_max="0.5"
                name="Eye Shape"
                group_id="2" />
            <deform_key
                id="eye_outer_corner_height"
                key_time_point="20"
                key_min="-0.5"
                key_max="0.5"
                name="Eye Outer Height"
                group_id="2" />
            <deform_key
                id="eye_inner_corner_height"
                key_time_point="21"
                key_min="0.5"
                key_max="-0.65"
                name="Eye Inner Height"
                group_id="2" />
            <deform_key
                id="eye_to_eye_distance"
                key_time_point="16"
                key_min="-1.2"
                key_max="1.0"
                name="Eye To Eye Distance"
                group_id="2" />
            <deform_key
                id="eye_asymetry"
                key_time_point="48"
                key_min="-0.5"
                key_max="0.5"
                name="Eye Asymmetry"
                group_id="2"
                deforms_hair="1.0" />
            <deform_key
                id="nose_angle"
                key_time_point="9"
                key_min="0.5"
                key_max="-0.5"
                name="Nose Angle"
                group_id="3"
                helmet_scaling_factor_min="0.0, -0.005, 0.0"
                helmet_scaling_factor_max="0.0, 0.005, 0.0" />
            <deform_key
                id="nose_length"
                key_time_point="27"
                key_min="-0.5"
                key_max="0.5"
                name="Nose Length"
                group_id="3" />
            <deform_key
                id="nose_bridge"
                key_time_point="28"
                key_min="-0.6"
                key_max="0.6"
                name="Nose Bridge"
                group_id="3" />
            <deform_key
                id="nose_tip_height"
                key_time_point="29"
                key_min="-0.7"
                key_max="0.7"
                name="Nose Tip Height"
                group_id="3" />
            <deform_key
                id="nose_size"
                key_time_point="30"
                key_min="-0.8"
                key_max="0.8"
                name="Nose Size"
                group_id="3"
                helmet_scaling_factor_min="0.0, -0.005, 0.0"
                helmet_scaling_factor_max="0.0, 0.005, 0.0" />
            <deform_key
                id="nose_width"
                key_time_point="31"
                key_min="-0.6"
                key_max="0.6"
                name="Nose Width"
                group_id="3" />
            <deform_key
                id="nostril_height"
                key_time_point="32"
                key_min="-0.5"
                key_max="0.5"
                name="Nostril Height"
                group_id="3" />
            <deform_key
                id="nostril_scale"
                key_time_point="34"
                key_min="-0.5"
                key_max="0.5"
                name="Nostril Size"
                group_id="3" />
            <deform_key
                id="nose_bump"
                key_time_point="37"
                key_min="-0.5"
                key_max="0.5"
                name="Nose Bump"
                group_id="3" />
            <deform_key
                id="nose_definition"
                key_time_point="33"
                key_min="-0.5"
                key_max="0.5"
                name="Nose Definition"
                group_id="3" />
            <deform_key
                id="nose_shape"
                key_time_point="54"
                key_min="-0.5"
                key_max="0.5"
                name="Nose Shape"
                group_id="3" />
            <deform_key
                id="nose_asymetry"
                key_time_point="45"
                key_min="-0.5"
                key_max="0.5"
                name="Nose Asymmetry"
                group_id="3"
                deforms_hair="1.0" />
            <deform_key
                id="mouth_width"
                key_time_point="35"
                key_min="-0.4"
                key_max="0.4"
                name="Mouth Width"
                group_id="4" />
            <deform_key
                id="mouth_position"
                key_time_point="36"
                key_min="-0.55"
                key_max="0.55"
                name="Mouth Position"
                group_id="4" />
            <deform_key
                id="lips_frown"
                key_time_point="41"
                key_min="-0.5"
                key_max="0.5"
                name="Frown/Smile"
                group_id="4" />
            <deform_key
                id="lip_thickness"
                key_time_point="42"
                key_min="-0.5"
                key_max="0.5"
                name="Lip Thickness"
                group_id="4" />
            <deform_key
                id="lips_forward"
                key_time_point="43"
                key_min="-0.5"
                key_max="0.5"
                name="Mouth Forward"
                group_id="4"
                helmet_scaling_factor_min="0.0, -0.025, 0.0"
                helmet_scaling_factor_max="0.0, 0.045, 0.0" />
            <deform_key
                id="lip_shape_bottom"
                key_time_point="44"
                key_min="-0.7"
                key_max="0.7"
                name="Bottom Lip Shape"
                group_id="4" />
            <deform_key
                id="lip_shape_top"
                key_time_point="8"
                key_min="-0.5"
                key_max="0.5"
                name="Top Mouth Size"
                group_id="4" />
            <deform_key
                id="mouth"
                key_time_point="55"
                key_min="0.5"
                key_max="-0.8"
                name="Lips concave/convex"
                group_id="4" />
            <deform_key
                id="jaw_line"
                key_time_point="11"
                key_min="-0.5"
                key_max="0.5"
                name="Jaw Line"
                group_id="4"
                helmet_scaling_factor_min="-0.005, 0.0, 0.0"
                helmet_scaling_factor_max="0.02, 0.0, 0.0" />
            <deform_key
                id="neck_slope"
                key_time_point="50"
                key_min="-0.8"
                key_max="0.5"
                name="Jaw Shape"
                group_id="4" />
            <deform_key
                id="jaw_height"
                key_time_point="49"
                key_min="0.5"
                key_max="-0.5"
                name="Jaw Height"
                group_id="4" />
            <deform_key
                id="chin_forward"
                key_time_point="38"
                key_min="-0.8"
                key_max="0.5"
                name="Chin Forward"
                group_id="4"
                helmet_scaling_factor_min="0.0, -0.015, 0.0000"
                helmet_scaling_factor_max="-0.00, 0.045, -0.0000" />
            <deform_key
                id="chin_shape"
                key_time_point="39"
                key_min="-0.9"
                key_max="0.5"
                name="Chin Shape"
                group_id="4"
                helmet_scaling_factor_min="0.0, -0.015, 0.0000"
                helmet_scaling_factor_max="-0.00, 0.045, -0.0000" />
            <deform_key
                id="chin_length"
                key_time_point="40"
                key_min="-0.7"
                key_max="0.6"
                name="Chin Length"
                group_id="4"
                helmet_scaling_factor_min="-0.00, 0.0, 0.0"
                helmet_scaling_factor_max="0.0, 0.0, -0.005" />
            <deform_key
                id="head_scaling"
                key_time_point="46"
                key_min="0.3"
                key_max="-0.3"
                name="Head Scaling"
                group_id="-1"
                helmet_scaling_factor_min="0.1, 0.1, 0.005"
                helmet_scaling_factor_max="-0.05, -0.05, -0.00"
                deforms_hair="1.0" />
            <deform_key
                id="hide_ears"
                key_time_point="51"
                key_min="0"
                key_max="0"
                name="Hide Ears"
                group_id="-1"
                deforms_hair="1.0"
                auto_activate_when_ears_are_hidden="true" />
            <deform_key
                id="old_face"
                key_time_point="57"
                key_min="-0.25"
                key_max="1.25"
                name="Old face"
                group_id="-1"
                deforms_hair="1.0" />
            <deform_key
                id="kid_face"
                key_time_point="58"
                key_min="0.0"
                key_max="-0.15"
                name="kid face"
                group_id="-1"
                deforms_hair="1.0" />
            <deform_key
                id="eyebump"
                key_time_point="59"
                key_min="0"
                key_max="0"
                name="eyebump"
                group_id="-1"
                deforms_hair="1.0" />
            <deform_key
                id="weight"
                key_time_point="60"
                name="Weight"
                group_id="0">
                <xsl:apply-templates select="deform_key[@id='weight']/bone_scales" />
            </deform_key>
            <deform_key
                id="build"
                key_time_point="61"
                name="Build"
                group_id="0">
                <xsl:apply-templates select="deform_key[@id='build']/bone_scales" />
            </deform_key>
            <deform_key
                id="height"
                key_time_point="62"
                name="Height Multiplier"
                group_id="0" />
            <deform_key
                id="age"
                key_time_point="63"
                name="Age"
                group_id="0" />
            <!-- the last key is used from the application for post modifications, do not delete
            the entry 
            <deform_key id="skinkey_post_edit" key_time_point="10" key_min="0" key_max="1" name="Post-Edit"
                group_id="4" />-->
        </deform_keys>
    </xsl:template>

    <!-- 6. woman constraints (同 xxFemale) -->
<xsl:template match='race[@id="human"]/skin[@name="woman"]/constraints | race[@id="human"]/skin[@name="man"]/constraints'>
        <constraints>
            <constraint
                proportional_negative_and_positive="1.0">
                <term
                    coefficient="1.0"
                    key_id="height" />
                <term
                    coefficient="1.0"
                    key_id="head_scaling" />
            </constraint>
            <constraint
                proportional_negative_and_positive="1.0">
                <term
                    coefficient="1.0"
                    key_id="age" />
                <term
                    coefficient="1.0"
                    key_id="kid_face" />
            </constraint>
        </constraints>
    </xsl:template>
</xsl:stylesheet>
