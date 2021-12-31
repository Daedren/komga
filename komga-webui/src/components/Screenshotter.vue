<template>
    <div>
        <v-card>
        <v-toolbar dark color="primary">
            <v-btn icon dark @click="goBack">
              <v-icon>mdi-close</v-icon>
            </v-btn>
            <v-toolbar-title>
              Screenshot
            </v-toolbar-title>
            <v-spacer/>
            <v-btn icon dark @click="cropImage">
              <v-icon>mdi-scissors-cutting</v-icon>
            </v-btn>
        </v-toolbar>
        <v-toolbar>
            {{filename}}
        </v-toolbar>
        <v-container>
          <v-row>
            <v-col
                  v-for="(option, index) in filenameOptions"
                  :key="option"
            >
                <v-checkbox
                  v-model="filenameChoices"
                  :label="option"
                  :value="index"
                  hide-details
                ></v-checkbox>
            </v-col>
          </v-row>
        </v-container>
        </v-card>
        <div class="cropper_parent">
          <cropper ref="cropper" class="cropper"
          imageRestriction="none"
          :defaultSize="defaultSize"
          :src="imgSrc" />
        </div>
    </div>
</template>

<style>

.cropper_parent {
  height: 60vh;
}
</style>

<script lang="ts">
import Vue, {PropType} from 'vue'
import { Cropper } from 'vue-advanced-cropper'
import {BookDto} from '@/types/komga-books'
import {SeriesDto} from '@/types/komga-series'
import 'vue-advanced-cropper/dist/style.css'

export default Vue.extend({
    name: 'Screenshotter',
    components: {
        Cropper,
    },
    props: {
      imgSrc: String,
      series: Object as PropType<SeriesDto>,
      book: Object as PropType<BookDto>,
      page: Number,
    },
    data: () => {
      return {
        filenameOptions: ['Series', 'Book name', 'Book number', 'Page number'],
        filenameChoices: [0, 1, 3],
      }
    },
    computed: {
      filename(): string {
        var filenameOpt = []
        const sortedOptions = this.filenameChoices.slice().sort()
        for(const value of sortedOptions) {
          switch(value) {
            case 0:
              filenameOpt.push(this.series.metadata.title)
              break
            case 1:
              filenameOpt.push(this.book.metadata.title)
              break
            case 2:
              filenameOpt.push(this.book.metadata.number)
              break
            case 3:
              filenameOpt.push(this.page)
              break
          }
        }
        return `${filenameOpt.join(' - ').replaceAll(' ', '_')}.png`
      },
    },
    methods: {
      defaultPosition() {
        return {
          left: 100,
          top: 100,
        }
		},
      defaultSize() {
        return {
          width: 200,
          height: 200,
        }
      },
      cropImage() {
          const cropper = this.$refs.cropper as Cropper
          const canvas = cropper.getResult().canvas

          if (canvas) {
            canvas.toBlob((blob) => {
              if (blob) {
                var file = new File([blob], this.filename, {type: 'image/png'})
                const shareParams: ShareData = {
                        // @ts-ignore ShareData with files comes in Typescript 4
                        files: [file],
                    }

                // @ts-ignore canShare support added in Typescript 4
                if(navigator.canShare && navigator.canShare(shareParams)) {
                    navigator.share(shareParams)
                } else {
                    const link = document.createElement('a')
                    link.download = this.filename
                    link.href = URL.createObjectURL(blob)
                    link.click()
                }
              }
            })
          }

      },
      goBack() {
          this.$emit('onComplete')
      },
    },
})
</script>
